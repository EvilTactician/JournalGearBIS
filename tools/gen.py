"""Writes JournalGearBIS's Classic data (Data.lua) and spec profiles (Profiles.lua)."""
import os
HERE = os.path.dirname(os.path.abspath(__file__))
BUILD = os.environ.get("GEARBIS_BUILD", os.path.join(HERE, "build"))
import pickle, sys, collections, math
sys.path.insert(0, HERE)
from sqlload import Table  # noqa
from profiles import PROFILES, BY_TREE, CLASS_BIT, WEAPON_SKILL, ARMOR_SKILL
from curated import CURATED, CRAFTED

db = pickle.load(open(os.path.join(BUILD, "db.pkl"), "rb"))
SRC = pickle.load(open(os.path.join(BUILD, "sources.pkl"), "rb"))
items = {r["entry"]: r for r in db["item_template"].rows}
sources, INSTANCES = SRC["sources"], SRC["instances"]
byname = collections.defaultdict(list)
for r in items.values():
    byname[r["name"]].append(r["entry"])

STAT = {3: "agi", 4: "str", 5: "int", 6: "spi", 7: "sta", 12: "def", 13: "dodge", 14: "parry", 15: "block",
        16: "mhit", 17: "mhit", 18: "shit", 19: "mcrit", 20: "mcrit", 21: "scrit", 28: "mhaste", 29: "mhaste",
        30: "shaste", 31: "hit", 32: "crit", 36: "haste", 37: "exp", 38: "ap", 39: "rap", 40: "fap", 41: "heal",
        42: "dmg", 43: "mp5", 44: "arp", 45: "sp", 47: "spen", 48: "bv"}

SLOT_OF = {1: "HEAD", 2: "NECK", 3: "SHOULDER", 16: "BACK", 5: "CHEST", 20: "CHEST", 9: "WRIST", 10: "HANDS",
           6: "WAIST", 7: "LEGS", 8: "FEET", 11: "FINGER", 12: "TRINKET", 13: "WEAPON", 17: "WEAPON", 21: "WEAPON",
           22: "WEAPON", 14: "WEAPON", 23: "WEAPON", 15: "RANGED", 25: "RANGED", 26: "RANGED", 28: "RANGED"}


from dbc import load as dbc_load, i32
SPELLS, _spell_str, _ = dbc_load(os.path.join(BUILD, "dbc", "Spell.dbc"))
SCHOOL = {2: "holy", 4: "fire", 8: "nature", 16: "frost", 32: "shadow", 64: "arcane"}
STATS5 = {0: "str", 1: "agi", 2: "sta", 3: "int", 4: "spi"}


def rating_keys(mask):
    out = []
    for bits, both, melee, spell in (((5, 6, 7), "hit", "mhit", "shit"), ((8, 9, 10), "crit", "mcrit", "scrit"),
                                     ((17, 18, 19), "haste", "mhaste", "shaste")):
        have = [b for b in bits if mask & (1 << b)]
        if len(have) == 3:
            out.append(both)
        elif have:
            out.append(spell if have == [bits[2]] else melee)
    for b, k in ((1, "def"), (2, "dodge"), (3, "parry"), (4, "block"), (23, "exp"), (24, "arp")):
        if mask & (1 << b):
            out.append(k)
    if mask & ((1 << 0) | (1 << 20) | (1 << 21) | (1 << 22)):
        out.append("wskill")
    return out


def spell_stats(sid, s):
    r = SPELLS.get(sid)
    if not r:
        return
    feral = r[12] != 0
    eff = [(r[95 + k], i32(r[80 + k]) + 1, i32(r[110 + k])) for k in range(3) if r[71 + k] == 6]
    auras = {a for a, _, _ in eff}
    for aura, val, misc in eff:
        if aura == 189:
            for k in rating_keys(misc):
                s[k] += val
        elif aura == 99:
            s["fap" if feral else "ap"] += val
        elif aura == 124 and 99 not in auras:
            s["rap"] += val
        elif aura == 13 and val > 0:
            if misc & 126 == 126:
                s["sp" if 135 in auras else "dmg"] += val
            else:
                for bit, name in SCHOOL.items():
                    if misc & bit:
                        s[name] += val
        elif aura == 135 and not (13 in auras):
            s["heal"] += val
        elif aura == 85 and misc == 0:
            s["mp5"] += val
        elif aura == 29:
            for st in (STATS5.values() if misc == -1 else [STATS5.get(misc)]):
                if st:
                    s[st] += val
        elif aura == 22 and misc & 1:
            s["armor"] += val
        elif aura == 158:
            s["bv"] += val
        elif aura == 30 and misc == 95:
            s["def"] += val * 1.5
        elif aura == 123 and val < 0:
            s["spen"] += -val
        elif aura == 34:
            s["sta"] += val / 10.0


def stats(it):
    s = collections.defaultdict(float)
    for i in range(1, 11):
        t, v = it.get("stat_type%d" % i) or 0, it.get("stat_value%d" % i) or 0
        if t in STAT and v:
            s[STAT[t]] += v
    for i in range(1, 6):
        if it.get("spellid_%d" % i) and it.get("spelltrigger_%d" % i) == 1:
            spell_stats(it["spellid_%d" % i], s)
    if it.get("armor"):
        s["armor"] += it["armor"]
    if it.get("block"):
        s["bv"] += it["block"]
    if it["class"] == 2 and it.get("delay"):
        dps = ((it.get("dmg_min1") or 0) + (it.get("dmg_max1") or 0)) / 2.0 / (it["delay"] / 1000.0)
        if dps > 0:
            s["wdps"] = round(dps, 1)
            s["speed"] = round(it["delay"] / 1000.0, 1)
    return {k: (round(v, 1) if isinstance(v, float) and v != int(v) else int(v)) for k, v in s.items()}


def usable_mask(it):
    mask = 0
    allow = it["AllowableClass"]
    for cls, bit in CLASS_BIT.items():
        if cls == "DEATHKNIGHT":
            continue
        if allow not in (-1, 0) and not (allow & bit) and allow != 32767 and allow != 262143:
            continue
        if it["class"] == 2 and it["subclass"] not in WEAPON_SKILL[cls]:
            continue
        if it["class"] == 4 and it["subclass"] not in ARMOR_SKILL[cls]:
            continue
        mask |= bit
    return mask


def score(st, wts, part):
    s = 0.0
    for k, v in st.items():
        if k in ("wdps", "speed"):
            continue
        s += wts.get(k, 0) * v
    if "wdps" in st:
        s += wts.get(part, 0) * st["wdps"]
    return s


def fits(prof, it, slot):
    """Can this profile use the item in this slot ('MH', 'OH', 'RANGED' or an armor slot)?"""
    inv, sub, kind = it["InventoryType"], it["subclass"], prof["weapons"]
    if slot == "RANGED":
        r = prof["ranged"]
        if r == "wand":
            return inv == 26 and it["class"] == 2 and sub == 19
        if r == "relic":
            return inv == 28
        return inv in (15, 25, 26) and it["class"] == 2 and sub != 19
    if slot == "MH":
        if kind == "2h":
            return inv == 17
        ok = inv in (13, 21) or (inv == 17 and kind in ("caster", "hunter"))
        return ok and (prof.get("mh") is None or sub in prof["mh"] or inv == 17)
    if slot == "OH":
        if kind == "dw" or kind == "hunter":
            return inv in (13, 22) and (prof.get("oh") is None or sub in prof["oh"])
        if kind == "tank":
            return inv == 14
        if kind == "caster":
            return inv in (14, 23)
        return False
    return True


def group_keys(srcs):
    keys = set()
    for s in srcs:
        if s["k"] in ("D", "C"):
            keys.add(s["i"])
        elif s["k"] == "Q":
            keys.add(s["i"] if s["i"] else "E")
        else:
            keys.add("E")
    return keys


# ---------------------------------------------------------------- curated
curated, curated_ids = {}, set()
for prof, lst in CURATED.items():
    out = []
    pcls = CLASS_BIT[PROFILES[prof]["cls"]]
    for e in lst:
        name, value = (e, None) if isinstance(e, str) else e
        for i in byname.get(name, []):
            it = items[i]
            if it["ItemLevel"] > 92 or not (usable_mask(it) & pcls):
                continue
            if not sources.get(i) and name not in CRAFTED:
                continue
            out.append((i, value))
            curated_ids.add(i)
    curated[prof] = out

# ---------------------------------------------------------------- prefilter
keep = set(curated_ids)
TOP = 6
for pk, prof in PROFILES.items():
    pcls = CLASS_BIT[prof["cls"]]
    buckets = collections.defaultdict(list)
    for i, srcs in sources.items():
        it = items[i]
        if it["RequiredLevel"] < 40 and it["ItemLevel"] < 50:
            continue
        if not (usable_mask(it) & pcls):
            continue
        st = stats(it)
        slot = SLOT_OF.get(it["InventoryType"])
        if slot == "WEAPON":
            parts = [s for s in ("MH", "OH") if fits(prof, it, s)]
        elif slot == "RANGED":
            parts = ["RANGED"] if fits(prof, it, "RANGED") else []
        else:
            parts = [slot]
        for part in parts:
            sc = score(st, prof["w"], {"MH": "dps", "OH": "odps", "RANGED": "rdps"}.get(part, "dps"))
            if sc <= 0:
                continue
            for g in group_keys(srcs):
                buckets[(part, g)].append((sc, i))
    for (part, g), lst in buckets.items():
        lst.sort(reverse=True)
        n = TOP + (4 if part in ("FINGER", "TRINKET", "OH", "MH") else 0)
        for sc, i in lst[:n]:
            keep.add(i)
print("items kept:", len(keep), file=sys.stderr)


# ---------------------------------------------------------------- Lua output
def lstr(s):
    return '"' + str(s).replace("\\", "\\\\").replace('"', '\\"').replace("\n", " ") + '"'


def lval(v):
    if isinstance(v, str):
        return lstr(v)
    if isinstance(v, float):
        return ("%.3f" % v).rstrip("0").rstrip(".")
    return str(v)


def ltable(d):
    return "{ " + ", ".join("%s = %s" % (k if k.isidentifier() and k not in ("end", "and", "or", "not") else "[%s]" % lstr(k), lval(v))
                            for k, v in sorted(d.items())) + " }"


def src_lua(i):
    out = []
    per_inst = collections.defaultdict(list)
    for s in sources.get(i, []):
        if s["k"] in ("D", "C"):
            per_inst[(s["k"], s["i"])].append(s)
    for (k, inst), lst in per_inst.items():
        names, miss = [], 1.0
        for s in sorted(lst, key=lambda x: -x["c"]):
            if s["n"] not in names:
                names.append(s["n"])
                miss *= (1 - s["c"])
        chance = round(1 - miss, 3)
        out.append("{ %s, %d, %s, %s }" % (lstr(k), inst, lval(chance), lstr(", ".join(names[:3]) + (" and others" if len(names) > 3 else ""))))
    seenq = set()
    for s in sources.get(i, []):
        if s["k"] == "Q" and s["q"] not in seenq:
            seenq.add(s["q"])
            ch = lambda c: "{ %d, %s, %d, %d, %d }" % (c[0], lstr(c[1]), c[2], c[3], c[4])
            out.append("{ \"Q\", %d, %s, %d, %d, %d, %d, %d, %s, %s }" % (s["q"], lstr(s["n"]), s["i"] or 0, s["st"], s["races"] or 0,
                       s["lvl"] or 0, s["need"], ch(s["chains"]["A"]), ch(s["chains"]["H"])))
        elif s["k"] == "V":
            name = s["n"] + (" <%s>" % s["sub"] if s["sub"] else "")
            out.append("{ \"V\", %s, %d, %d, %d, %d }" % (lstr(name), s["price"] or 0, s["rep"] or 0, s["rank"] or 0, s["st"]))
    if items[i]["name"] in CRAFTED:
        out.append("{ \"X\", %s }" % lstr(CRAFTED[items[i]["name"]]))
    return "{ " + ", ".join(out) + " }"


L = []
L.append("-- Classic gear for JournalGearBIS, generated from the realm's world database (AzerothCore with")
L.append("-- mod-individual-progression's Classic item and loot changes). Don't edit by hand: Curated.lua and Profiles.lua")
L.append("-- are the files to change.")
L.append("--")
L.append("--   instances[key] = { name, raid, players, stage (progression stage that opens it), level, map }")
L.append("--   items[id] = { name, inventory type, class*100+subclass, item level, required level, quality,")
L.append("--                 classes (bit mask of classes that can use it), races (bit mask, 0 = all), unique,")
L.append("--                 stats = { ... }, sources = { ... } }")
L.append("--   a source:  { \"D\", instance, chance (all its bosses together), \"who\" }   a drop")
L.append("--              { \"C\", instance, chance, \"chest\" }                         a chest")
L.append("--              { \"Q\", quest, \"title\", instance it needs or 0, stage, races, quest level, level needed,")
L.append("--                     Alliance chain, Horde chain }")
L.append("--                a chain: { first quest, \"its title\", quest givers, 1 if they're all trainers, quests in it }")
L.append("--              { \"V\", \"vendor\", price in copper, faction, standing, stage }")
L.append("--              { \"X\", \"how it's made\" }")
L.append("")
L.append("JournalGearBIS = JournalGearBIS or {}")
L.append("local G = JournalGearBIS")
L.append("")
L.append("G.instances = {")
for k in sorted(INSTANCES):
    name, raid, players, stage, level = INSTANCES[k]
    L.append("\t[%d] = { name = %s, raid = %s, players = %d, stage = %d, level = %d, map = %d }," % (
        k, lstr(name), "true" if raid else "false", players, stage, level, 229 if k == 2291 else k))
L.append("}")
L.append("")
L.append("G.items = {")
for i in sorted(keep):
    it = items[i]
    races = it["AllowableRace"] if it["AllowableRace"] not in (-1, 0) and (it["AllowableRace"] & 0x2FF) != 0x2FF else 0
    uniq = 1 if (it.get("maxcount") or 0) == 1 else 0
    L.append("\t[%d] = { %s, %d, %d, %d, %d, %d, %d, %d, %d, %s, %s }," % (
        i, lstr(it["name"]), it["InventoryType"], it["class"] * 100 + it["subclass"], it["ItemLevel"], it["RequiredLevel"],
        it["Quality"], usable_mask(it), races, uniq, ltable(stats(it)), src_lua(i)))
L.append("}")
L.append("")
L.append("-- Raid drops you hand in for an item (tier tokens, Head of Onyxia): token = { items it can become }.")
tokens = collections.defaultdict(set)
for i in keep:
    for s in sources.get(i, []):
        if s["k"] == "Q":
            for tk in s.get("tokens", []):
                tokens[tk].add(i)
L.append("G.tokens = {")
for tk in sorted(tokens):
    L.append("\t[%d] = { %s }, -- %s" % (tk, ", ".join(str(x) for x in sorted(tokens[tk])), items[tk]["name"] if tk in items else "?"))
L.append("}")
open(os.path.join(HERE, "..", "JournalGearBIS", "Data.lua"), "w").write("\n".join(L) + "\n")

# ---------------------------------------------------------------- Profiles.lua
P = []
P.append("-- Spec profiles for JournalGearBIS: what each stat is worth, and which weapons a spec uses. Edit freely.")
P.append("--")
P.append("--   weights: per point of a stat, in the profile's own units (attack power for melee and hunters, spell power")
P.append("--            for casters and healers, stamina for tanks). Ratings are per rating point.")
P.append("--            dps / odps / rdps: per point of main hand / off hand / ranged weapon damage per second.")
P.append("--   weapons: \"dw\" two one-handers, \"2h\" a two-hander, \"caster\" a one-hander and held item or shield, or a")
P.append("--            staff, \"tank\" a one-hander and shield, \"hunter\" melee stat stick and a bow, gun or crossbow.")
P.append("--   mh / oh: weapon subclasses allowed in that hand (4 mace, 7 sword, 13 fist, 15 dagger); none = any.")
P.append("--   ranged:  \"ranged\" bows, guns, crossbows and thrown; \"wand\"; \"relic\" (libram, idol or totem).")
P.append("")
P.append("local G = JournalGearBIS")
P.append("")
P.append("G.profiles = {")
for k, p in PROFILES.items():
    extra = ""
    for hand in ("mh", "oh"):
        if p.get(hand):
            extra += ", %s = { %s }" % (hand, ", ".join("[%d] = true" % x for x in sorted(p[hand])))
    P.append("\t%s = { class = %s, name = %s, role = %s, weapons = %s, ranged = %s%s," % (
        k, lstr(p["cls"]), lstr(p["name"]), lstr(p["role"]), lstr(p["weapons"]), lstr(p["ranged"]), extra))
    P.append("\t\tweights = %s }," % ltable(p["w"]))
P.append("}")
P.append("")
P.append("-- The profile for each talent tree (1, 2, 3), by class.")
P.append("G.byTree = {")
for c, lst in BY_TREE.items():
    P.append("\t%s = { %s }," % (c, ", ".join(lstr(x) for x in lst)))
P.append("}")
open(os.path.join(HERE, "..", "JournalGearBIS", "Profiles.lua"), "w").write("\n".join(P) + "\n")

# ---------------------------------------------------------------- Curated.lua
C = []
C.append("-- Hand-picked Classic best-in-slot items and key upgrades, by spec profile. These win their raid or dungeon")
C.append("-- tier's step over the stat-weighted pick. { item, value } gives an item whose worth is a proc or use effect")
C.append("-- (Hand of Justice, Kiss of the Spider) a value in the profile's units. Add specs or items freely:")
C.append("-- the item must also be in Data.lua.")
C.append("")
C.append("local G = JournalGearBIS")
C.append("")
C.append("G.curated = {")
for prof, lst in curated.items():
    C.append("\t%s = {" % prof)
    for i, v in lst:
        C.append("\t\t{ %d%s }, -- %s" % (i, (", %d" % v) if v else "", items[i]["name"]))
    C.append("\t},")
C.append("}")
open(os.path.join(HERE, "..", "JournalGearBIS", "Curated.lua"), "w").write("\n".join(C) + "\n")
print("done", file=sys.stderr)
