"""Tiny MySQL dump loader: AzerothCore base tables, then mod-individual-progression's statements on top.

Only what the gear data needs: INSERT/REPLACE/UPDATE/DELETE with simple WHERE clauses."""
import os
HERE = os.path.dirname(os.path.abspath(__file__))
BUILD = os.environ.get("GEARBIS_BUILD", os.path.join(HERE, "build"))
import os, re, pickle, sys

AC = os.environ.get("GEARBIS_AC", "azerothcore-wotlk/data/sql/base/db_world")
MOD = os.environ.get("GEARBIS_MOD", "mod-individual-progression/data/sql/world/base")
TABLES = ["item_template", "creature_template", "creature", "creature_loot_template", "reference_loot_template",
          "gameobject_loot_template", "gameobject_template", "gameobject", "quest_template", "npc_vendor",
          "creature_queststarter", "gameobject_queststarter", "item_loot_template", "instance_encounters",
          "quest_template_addon", "conditions"]
# Columns we never need (saves memory on the big tables)
KEEP = {
    "creature": {"guid", "id1", "map"},
    "gameobject": {"guid", "id", "map"},
}

TOKEN = re.compile(r"""\s*(?:'((?:[^'\\]|\\.|'')*)'|"((?:[^"\\]|\\.)*)"|(NULL)|(-?\d+(?:\.\d+)?(?:[eE][-+]?\d+)?)|([(),]))""", re.S)


def unescape(s):
    return s.replace("\\'", "'").replace("''", "'").replace('\\"', '"').replace("\\n", "\n").replace("\\\\", "\\")


def parse_tuples(text, pos):
    """Parse '(..),(..);' from pos; returns list of tuples and end pos."""
    rows, row, depth = [], None, 0
    n = len(text)
    while pos < n:
        m = TOKEN.match(text, pos)
        if not m:
            # end of statement
            if text[pos:pos + 1].isspace():
                pos += 1
                continue
            break
        pos = m.end()
        s, s2, null, num, punct = m.groups()
        if s2 is not None:
            s = s2
        if punct == "(":
            depth += 1
            row = []
        elif punct == ")":
            depth -= 1
            rows.append(row)
        elif punct == ",":
            pass
        elif s is not None:
            row.append(unescape(s))
        elif null:
            row.append(None)
        elif num is not None:
            row.append(float(num) if ("." in num or "e" in num.lower()) else int(num))
        if depth == 0 and text[pos:pos + 1] == ";":
            break
    return rows, pos


def columns_of(text, table):
    m = re.search(r"CREATE TABLE `%s` \((.*?)\n\)" % table, text, re.S)
    return re.findall(r"^\s*`(\w+)`", m.group(1), re.M)


class Table:
    def __init__(self, name, cols):
        self.name, self.cols = name, cols
        self.rows = []

    def add(self, cols, values):
        keep = KEEP.get(self.name)
        d = dict(zip(cols, values))
        if self.name == "creature" and "id1" not in d and "id" in d:
            d["id1"] = d["id"]
        if keep:
            d = {k: v for k, v in d.items() if k in keep}
        self.rows.append(d)


def load_base():
    db = {}
    for t in TABLES:
        path = os.path.join(AC, t + ".sql")
        text = open(path, encoding="utf8", errors="replace").read()
        cols = columns_of(text, t)
        tab = Table(t, cols)
        for m in re.finditer(r"INSERT INTO `%s`(?: \(([^)]*)\))? VALUES" % t, text):
            c = [x.strip(" `") for x in m.group(1).split(",")] if m.group(1) else cols
            rows, _ = parse_tuples(text, m.end())
            for r in rows:
                tab.add(c, r)
        db[t] = tab
        print(t, len(tab.rows), file=sys.stderr)
    return db


# ---- module statements ----

def split_statements(text):
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    out, cur, i, n, q = [], [], 0, len(text), None
    while i < n:
        c = text[i]
        if q:
            cur.append(c)
            if c == "\\":
                cur.append(text[i + 1]); i += 2; continue
            if c == q:
                q = None
        elif c in "'\"":
            q = c; cur.append(c)
        elif c == "-" and text[i:i + 2] == "--":
            j = text.find("\n", i)
            i = n if j < 0 else j
            continue
        elif c == "#":
            j = text.find("\n", i); i = n if j < 0 else j; continue
        elif c == ";":
            out.append("".join(cur).strip()); cur = []
        else:
            cur.append(c)
        i += 1
    if "".join(cur).strip():
        out.append("".join(cur).strip())
    return out


def where_fn(clause, variables):
    """Turn a simple SQL WHERE into a python predicate over a row dict."""
    if clause is None:
        return lambda r: True
    e = clause.replace("`", "")
    # strings to python
    e = re.sub(r"\bIS NOT NULL\b", "!= None", e, flags=re.I)
    e = re.sub(r"\bIS NULL\b", "== None", e, flags=re.I)
    e = re.sub(r"\bNOT IN\s*\(", " not in (", e, flags=re.I)
    e = re.sub(r"\bIN\s*\(", " in (", e, flags=re.I)
    e = re.sub(r"\bBETWEEN\s+(\S+)\s+AND\s+(\S+)", r" in range(\1, \2 + 1)", e, flags=re.I)
    e = re.sub(r"\bAND\b", " and ", e, flags=re.I)
    e = re.sub(r"\bOR\b", " or ", e, flags=re.I)
    e = re.sub(r"\bNOT\b", " not ", e, flags=re.I)
    e = re.sub(r"<>", "!=", e)
    e = re.sub(r"(?<![<>!=])=(?!=)", "==", e)
    e = re.sub(r"@(\w+)", lambda m: repr(variables.get(m.group(1).upper(), 0)), e)
    # 1-tuples: "in (5)" -> "in (5,)"
    e = re.sub(r"in \(([^(),]+)\)", r"in (\1,)", e)
    e = re.sub(r"\bLIKE\s+'([^']*)'", lambda m: ".__class__ and False", e, flags=re.I)
    code = compile(e, "<where>", "eval")

    def pred(r):
        try:
            return eval(code, {"range": range}, r)
        except NameError:
            return False
    return pred


def set_fn(clause, variables):
    parts = []
    # split on commas outside quotes
    depth, q, cur = 0, None, ""
    for c in clause:
        if q:
            cur += c
            if c == q: q = None
            continue
        if c in "'\"": q = c
        if c == "(": depth += 1
        if c == ")": depth -= 1
        if c == "," and depth == 0:
            parts.append(cur); cur = ""
        else:
            cur += c
    parts.append(cur)
    sets = []
    for p in parts:
        k, v = p.split("=", 1)
        k = k.strip().strip("`").split(".")[-1].strip("`")
        v = v.strip()
        if re.fullmatch(r"-?\d+", v):
            sets.append((k, int(v), None))
        elif re.fullmatch(r"-?\d+\.\d+", v):
            sets.append((k, float(v), None))
        elif v.startswith("'"):
            sets.append((k, unescape(v[1:-1]), None))
        elif v.startswith("@"):
            sets.append((k, variables.get(v[1:].upper(), 0), None))
        else:
            # expression like `Flags` | 4 or `col` + 1
            ex = re.sub(r"`(\w+)`", r"\1", v)
            sets.append((k, None, compile(ex, "<set>", "eval")))
    return sets


def apply_module(db, folder=MOD):
    stats = {"ok": 0, "skip": 0, "err": 0}
    variables = {}
    files = sorted(f for f in os.listdir(folder) if f.endswith(".sql"))
    for f in files:
        text = open(os.path.join(folder, f), encoding="utf8", errors="replace").read()
        for st in split_statements(text):
            m = re.match(r"SET\s+@(\w+)\s*:?=\s*(-?\d+)", st, re.I)
            if m:
                variables[m.group(1).upper()] = int(m.group(2)); continue
            m = re.match(r"(INSERT(?: IGNORE)?|REPLACE)\s+INTO\s+`?(\w+)`?\s*(?:\(([^)]*)\))?\s*VALUES", st, re.I | re.S)
            if m:
                t = m.group(2)
                if t not in db: stats["skip"] += 1; continue
                tab = db[t]
                cols = [x.strip(" `\n\t") for x in m.group(3).split(",")] if m.group(3) else tab.cols
                body = re.sub(r"@(\w+)", lambda mm: str(variables.get(mm.group(1).upper(), 0)), st[m.end():])
                # simple arithmetic like @ENTRY+1 -> evaluate
                body = re.sub(r"(-?\d+)\s*\+\s*(\d+)", lambda mm: str(int(mm.group(1)) + int(mm.group(2))), body)
                rows, _ = parse_tuples(body + ";", 0)
                for r in rows:
                    if len(r) != len(cols): stats["err"] += 1; continue
                    tab.add(cols, r)
                stats["ok"] += 1
                continue
            m = re.match(r"UPDATE\s+`?(\w+)`?\s+SET\s+(.*?)(?:\s+WHERE\s+(.*))?$", st, re.I | re.S)
            if m:
                t = m.group(1)
                if t not in db: stats["skip"] += 1; continue
                try:
                    sets = set_fn(m.group(2), variables)
                    pred = where_fn(m.group(3), variables)
                    for r in db[t].rows:
                        if pred(r):
                            for k, v, ex in sets:
                                r[k] = eval(ex, {}, r) if ex else v
                    stats["ok"] += 1
                except Exception as e:
                    stats["err"] += 1
                continue
            m = re.match(r"DELETE\s+FROM\s+`?(\w+)`?(?:\s+WHERE\s+(.*))?$", st, re.I | re.S)
            if m:
                t = m.group(1)
                if t not in db: stats["skip"] += 1; continue
                try:
                    pred = where_fn(m.group(2), variables)
                    db[t].rows = [r for r in db[t].rows if not pred(r)]
                    stats["ok"] += 1
                except Exception:
                    stats["err"] += 1
                continue
            stats["skip"] += 1
    print("module", stats, file=sys.stderr)


if __name__ == "__main__":
    db = load_base()
    pickle.dump(db, open(os.path.join(BUILD, "base.pkl"), "wb"))
    apply_module(db)
    pickle.dump(db, open(os.path.join(BUILD, "db.pkl"), "wb"))
