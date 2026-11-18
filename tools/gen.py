"""Writes JournalGearBIS's Classic data (Data.lua) and spec profiles (Profiles.lua)."""
import os
HERE = os.path.dirname(os.path.abspath(__file__))
BUILD = os.environ.get("GEARBIS_BUILD", os.path.join(HERE, "build"))
import pickle, sys, collections, math
sys.path.insert(0, HERE)
from sqlload import Table  # noqa
from profiles import PROFILES, BY_TREE, CLASS_BIT, WEAPON_SKILL, ARMOR_SKILL
from curated import CURATED, CRAFTED
from crafts import PROFESSIONS

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
        # an item id names one item where several share a name (Mark of the Champion: melee and caster)
        for i in ([name] if isinstance(name, int) else byname.get(name, [])):
            it = items[i]
            name = it["name"]
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
        if it["InventoryType"] not in SLOT_OF:
            continue  # consumables, enchants and recipes: extras.py's
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


from crafts import Crafts as _Crafts
early_crafts = _Crafts(BUILD, lambda t: db[t].rows, items, SPELLS)


def src_lua(i, crafted=True):
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
            out.append("{ \"Q\", %d, %s, %d, %d, %d, %d, %d, %s, %s, %d }" % (s["q"], lstr(s["n"]), s["i"] or 0, s["st"], s["races"] or 0,
                       s["lvl"] or 0, s["need"], ch(s["chains"]["A"]), ch(s["chains"]["H"]), s["classes"] or 0))
        elif s["k"] == "V":
            name = s["n"] + (" <%s>" % s["sub"] if s["sub"] else "")
            out.append("{ \"V\", %s, %d, %d, %d, %d }" % (lstr(name), s["price"] or 0, s["rep"] or 0, s["rank"] or 0, s["st"]))
    if items[i]["name"] in CRAFTED:
        way = next(iter(early_crafts.made_by(i)), None)
        if way and items[i].get("bonding") == 1:
            # Bind on Pickup: only a crafter with the skill can have it
            out.append("{ \"X\", %s, %d, %d, 0, \"\", 0, 1 }" % (lstr(CRAFTED[items[i]["name"]]), way[0], way[1]))
        else:
            out.append("{ \"X\", %s }" % lstr(CRAFTED[items[i]["name"]]))
    elif crafted:
        for s in sources.get(i, []):
            if s["k"] == "X":
                out.append("{ \"X\", %s, %d, %d }" % (lstr("Crafted: " + PROFESSIONS[s["skill"]]), s["skill"], s["rank"]))
                break
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
L.append("--                     Alliance chain, Horde chain, classes (bit mask, 0 = all) }")
L.append("--                a chain: { first quest, \"its title\", quest givers, 1 if they're all trainers, quests in it }")
L.append("--              { \"V\", \"vendor\", price in copper, faction, standing, stage }")
L.append("--              { \"X\", \"how it's made\", profession, skill }")
L.append("--   profession gear (Engineering goggles) adds: profession and skill needed to wear it, after sources")
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
    prof = ", %d, %d" % (it["RequiredSkill"], it["RequiredSkillRank"]) if (it.get("RequiredSkill") or 0) else ""
    L.append("\t[%d] = { %s, %d, %d, %d, %d, %d, %d, %d, %d, %s, %s%s }," % (
        i, lstr(it["name"]), it["InventoryType"], it["class"] * 100 + it["subclass"], it["ItemLevel"], it["RequiredLevel"],
        it["Quality"], usable_mask(it), races, uniq, ltable(stats(it)), src_lua(i), prof))
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
P.append("--   speed:   per hand, { speed, worth per second away from it, \"slow\" or \"fast\" }: a weapon quicker (\"fast\":")
P.append("--            slower) than that loses that much of its value per second, up to a tenth. Not hand-picked items.")
P.append("")
P.append("local G = JournalGearBIS")
P.append("")
P.append("G.profiles = {")
for k, p in PROFILES.items():
    extra = ""
    for hand in ("mh", "oh"):
        if p.get(hand):
            extra += ", %s = { %s }" % (hand, ", ".join("[%d] = true" % x for x in sorted(p[hand])))
    if p.get("speed"):
        extra += ", speed = { %s }" % ", ".join("%s = { %s, %s, %s }" % (h, v[0], v[1], lstr(v[2])) for h, v in sorted(p["speed"].items()))
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

# ---------------------------------------------------------------- Extras.lua: enchants, glyphs, consumables
from crafts import Crafts, CLASSIC_CAP
from curated import GLYPHS, CONSUMABLES, ENCHANT_PROCS, PROFESSION_CONSUMABLES
crafts = early_crafts
ENCH, ench_str, _ = dbc_load(os.path.join(BUILD, "dbc", "SpellItemEnchantment.dbc"))
GLYPH_PROPS = dbc_load(os.path.join(BUILD, "dbc", "GlyphProperties.dbc"))[0]
EXTRA = set(SRC.get("extra", []))
CLASSIC_ID, CLASSIC_SPELL = 23728, 26000  # the first ids of The Burning Crusade's items and profession spells
ARMOR_SLOTS = {1: "HEAD", 3: "SHOULDER", 5: "CHEST", 20: "CHEST", 6: "WAIST", 7: "LEGS", 8: "FEET", 9: "WRIST", 10: "HANDS",
               16: "BACK", 11: "FINGER"}
TWO_HAND, RANGED_GUNS = {1, 5, 6, 8, 10}, {2, 3, 18}


def stage_of_rank(rank):
    """The stage a profession reaches a skill at: Artisan (300) before 8, Master (375) before 13."""
    return 0 if rank <= 300 else (8 if rank <= 375 else 13)


def enchant_stats(e):
    """What an enchant gives, in the profile stat keys; 'proc' names a proc ENCHANT_PROCS can value."""
    r = ENCH.get(e)
    s = collections.defaultdict(float)
    if not r:
        return s, None
    proc = None
    for k in range(3):
        kind, pts, arg = r[2 + k], i32(r[5 + k]), r[11 + k]
        if kind == 5 and arg in STAT:
            s[STAT[arg]] += pts
        elif kind == 3:
            spell_stats(arg, s)
        elif kind == 2:
            s["wdmg"] += pts
        elif kind == 4 and arg == 0:
            s["armor"] += pts
        elif kind == 1:
            proc = ench_str(r[14])
    return s, proc


def enchant_slots(sid):
    """The slots a spell can enchant: armor slots, 'SHIELD', 'WEAPON', '2H' (two-handers only) or 'RANGED'."""
    r = SPELLS.get(sid)
    if not r:
        return set()
    cls, sub, inv = i32(r[68]), r[69], r[70]
    if cls == 4:
        out = {name for bit, name in ARMOR_SLOTS.items() if inv & (1 << bit)}
        if sub & (1 << 6) and not inv:
            out.add("SHIELD")
        return out
    if cls == 2:
        subs = {b for b in range(21) if sub & (1 << b)}
        if subs and subs <= RANGED_GUNS:
            return {"RANGED"}
        if subs and subs <= TWO_HAND:
            return {"TWOHAND"}
        return {"WEAPON"}
    return set()


def recipe_way(skill, rank, sid, recipe, label=None):
    """{ "X", "Crafted: Alchemy", profession, skill, stage, "where the recipe comes from", the recipe's instance }."""
    stage, where, inst = stage_of_rank(rank), "from a trainer", 0
    for s in sources.get(recipe, []):
        if s["k"] == "V":
            stage = max(stage, s["st"])
            where = "recipe sold by %s" % s["n"]
            if s["rep"]:
                where += " (%s)" % ["Hated", "Hostile", "Unfriendly", "Neutral", "Friendly", "Honored", "Revered", "Exalted"][s["rank"]]
            break
        if s["k"] in ("D", "C"):
            where = "recipe drops in %s" % INSTANCES[s["i"]][0]
            stage, inst = max(stage, INSTANCES[s["i"]][3]), s["i"]
            break
        if s["k"] == "Q":
            where = "recipe from the quest %s" % s["n"]
            stage = max(stage, s["st"])
            break
    else:
        if recipe:
            where = "from a recipe"
    return "{ \"X\", %s, %d, %d, %d, %s, %d }" % (lstr(label or ("Crafted: " + PROFESSIONS[skill])), skill, rank, stage, lstr(where), inst)


extra_items = set()
options = collections.defaultdict(list)   # slot -> [lua]
known = set()

# enchants an enchanter puts on (the realm's Classic recipes, up to Artisan)
for e in sorted(crafts.enchants):
    # Classic's own recipes: The Burning Crusade and Wrath added a few at 300 and below
    ways = [w for w in crafts.enchanted_by(e) if w[0] == 333 and w[1] <= CLASSIC_CAP and w[2] < CLASSIC_SPELL
            and (not w[3] or w[3] < CLASSIC_ID)]
    if not ways or e not in ENCH:
        continue
    known.add(e)
    skill, rank, sid, recipe = ways[0]
    for slot in enchant_slots(sid):
        options[slot].append("{ e = %d, spell = %d, level = %d, ways = { %s } }" % (e, sid, ENCH[e][37], recipe_way(skill, rank, sid, recipe, "Enchanting")))

# enchants that come as an item (arcanums, signets, armor kits, scopes)
for i in sorted(EXTRA):
    it = items[i]
    sid = it.get("spellid_1") or 0
    sp = SPELLS.get(sid)
    if not sp or it.get("spelltrigger_1") != 0 or 53 not in sp[71:74] or not sources.get(i):
        continue
    e = sp[110 + list(sp[71:74]).index(53)]
    if e not in ENCH:
        continue
    known.add(e)
    extra_items.add(i)
    allow = it["AllowableClass"]
    classes = 0 if allow in (-1, 0, 32767, 262143) else allow
    for slot in enchant_slots(sid):
        options[slot].append("{ e = %d, item = %d, level = %d, classes = %d }" % (
            e, i, max(ENCH[e][37], it["RequiredLevel"] or 0), classes))

X = []
X.append("-- Enchants, glyphs and consumables for JournalGearBIS, generated from the realm's world database and the")
X.append("-- client's DBC files (tools/gen.py). Don't edit by hand: tools/curated.py has the hand-picked lists.")
X.append("--")
X.append("--   enchants[slot] = { { e = enchant, spell = enchanting spell or item = the item that puts it on,")
X.append("--                        level = level needed, classes = bit mask (0 = all), ways = { source, ... } } }")
X.append("--                    slots: armor slots, SHIELD, WEAPON (any weapon), TWOHAND (two-handers) and RANGED (bows, guns)")
X.append("--   enchantStats[enchant] = { stats } (wdmg = weapon damage), with proc = value by profile for procs")
X.append("--   extraItems[id] = { name, quality, required level, sources } (sources as in Data.lua)")
X.append("--   enchantNames[enchant] = \"what it gives\"")
X.append("--   glyphs[profile] = { major = { { item, glyph spell, Inscription skill, stage, level, \"talent\", \"name\" } },")
X.append("--                       minor = { ... } }, best first")
X.append("--   consumables[profile] = { { item, \"note\" } }")
X.append("--   elixirs[item] = 1 battle elixir, 2 guardian elixir, 3 both (a flask): one of each at a time")
X.append("--   professionConsumables[profession] = { { item, skill needed to use it, \"what it's for\" } }")
X.append("")
X.append("local G = JournalGearBIS")
X.append("")
X.append("G.enchants = {")
for slot in sorted(options):
    X.append("\t%s = {" % slot)
    for o in options[slot]:
        X.append("\t\t%s," % o)
    X.append("\t},")
X.append("}")
X.append("")
X.append("G.enchantStats = {")
for e in sorted(known):
    st, proc = enchant_stats(e)
    st = {k: (round(v, 1) if v != int(v) else int(v)) for k, v in st.items() if v}
    if proc and proc in ENCHANT_PROCS:
        st["proc"] = 1
    X.append("\t[%d] = %s, -- %s" % (e, ltable(st), ench_str(ENCH[e][14])))
X.append("}")
X.append("")
X.append("G.enchantNames = {")
for e in sorted(known):
    X.append("\t[%d] = %s," % (e, lstr(ench_str(ENCH[e][14]))))
X.append("}")
X.append("")
X.append("G.enchantProcs = {")
for e in sorted(known):
    proc = enchant_stats(e)[1]
    if proc in ENCHANT_PROCS:
        X.append("\t[%d] = %s, -- %s" % (e, ltable(ENCHANT_PROCS[proc]), proc))
X.append("}")

# glyphs
X.append("")
X.append("G.glyphs = {")
for prof, kinds in GLYPHS.items():
    X.append("\t%s = {" % prof)
    for kind in ("major", "minor"):
        rows = []
        for entry in kinds[kind]:
            name, talent = (entry, "") if isinstance(entry, str) else entry
            for i in byname.get(name, []):
                it = items[i]
                if it["class"] != 16:
                    continue
                sp = SPELLS.get(it.get("spellid_1") or 0)
                gp = sp and next((GLYPH_PROPS.get(sp[110 + k]) for k in range(3) if sp[71 + k] == 74), None)
                ways = crafts.made_by(i)
                if not gp or not ways:
                    continue
                rank = ways[0][1]
                rows.append("{ %d, %d, %d, %d, %d, %s, %s }," % (i, gp[1], rank, stage_of_rank(rank), it["RequiredLevel"], lstr(talent), lstr(name)))
                break
            else:
                print("glyph not found:", name, file=sys.stderr)
        X.append("\t\t%s = {" % kind)
        for row in rows:
            X.append("\t\t\t%s" % row)
        X.append("\t\t},")
    X.append("\t},")
X.append("}")

# consumables
X.append("")
X.append("G.consumables = {")
for prof, lst in CONSUMABLES.items():
    X.append("\t%s = {" % prof)
    for entry in lst:
        name, note = (entry, "") if isinstance(entry, str) else entry
        ids = [i for i in byname.get(name, []) if i in EXTRA]
        if not ids:
            print("consumable not found:", name, file=sys.stderr)
            continue
        extra_items.add(ids[0])
        X.append("\t\t{ %d, %s }, -- %s" % (ids[0], lstr(note), name))
    X.append("\t},")
X.append("}")


X.append("")
X.append("G.elixirs = {")
_groups = collections.defaultdict(int)
for r in db["spell_group"].rows:
    if r["id"] in (1, 2):
        _groups[r["spell_id"]] |= r["id"]
_cons = {e if isinstance(e, str) else e[0] for lst in CONSUMABLES.values() for e in lst}
for i in sorted(extra_items):
    g = _groups.get(items[i].get("spellid_1") or 0)
    if g and items[i]["name"] in _cons:
        X.append("\t[%d] = %d, -- %s" % (i, g, items[i]["name"]))
X.append("}")
X.append("")
X.append("G.professionConsumables = {")
for prof, lst in PROFESSION_CONSUMABLES.items():
    skill = next(k for k, v in PROFESSIONS.items() if v == prof)
    X.append("\t[%d] = { -- %s" % (skill, prof))
    for name, note in lst:
        ids = [i for i in byname.get(name, []) if i in EXTRA]
        if not ids:
            print("profession consumable not found:", name, file=sys.stderr)
            continue
        extra_items.add(ids[0])
        X.append("\t\t{ %d, %d, %s }, -- %s" % (ids[0], items[ids[0]]["RequiredSkillRank"] or 0, lstr(note), name))
    X.append("\t},")
X.append("}")


def extra_src_lua(i):
    out = [src_lua(i, False)[2:-2]]
    for s in sources.get(i, []):
        if s["k"] == "X":
            out.append(recipe_way(s["skill"], s["rank"], s["spell"], s["recipe"]))
            break
    return "{ " + ", ".join(o for o in out if o) + " }"


X.append("")
X.append("G.extraItems = {")
for i in sorted(extra_items):
    it = items[i]
    X.append("\t[%d] = { %s, %d, %d, %s }," % (i, lstr(it["name"]), it["Quality"], it["RequiredLevel"] or 0, extra_src_lua(i)))
X.append("}")
open(os.path.join(HERE, "..", "JournalGearBIS", "Extras.lua"), "w").write("\n".join(X) + "\n")
print("extras: %d enchants, %d items" % (len(known), len(extra_items)), file=sys.stderr)
