"""Builds the Classic gear data for JournalGearBIS from the realm's world DB (db.pkl from sqlload.py)."""
import os
HERE = os.path.dirname(os.path.abspath(__file__))
BUILD = os.environ.get("GEARBIS_BUILD", os.path.join(HERE, "build"))
import pickle, sys, re, json, collections
sys.path.insert(0, HERE)
from sqlload import Table  # noqa: F401 (pickle needs it)

db = pickle.load(open(os.path.join(BUILD, "db.pkl"), "rb"))
R = lambda t: db[t].rows

items = {r["entry"]: r for r in R("item_template")}
ctpl = {r["entry"]: r for r in R("creature_template")}
gtpl = {r["entry"]: r for r in R("gameobject_template")}
quests = {r["ID"]: r for r in R("quest_template")}
qaddon = {r["ID"]: r for r in R("quest_template_addon")}

# ---------------------------------------------------------------- instances (Classic)
# key: map id, or 2291 for Upper Blackrock Spire (map 229). stage = default progression stage that opens it.
INSTANCES = {
    70: ("Uldaman", False, 5, 0, 37), 209: ("Zul'Farrak", False, 5, 0, 39), 349: ("Maraudon", False, 5, 0, 41),
    109: ("Sunken Temple", False, 5, 0, 45), 230: ("Blackrock Depths", False, 5, 0, 48),
    229: ("Lower Blackrock Spire", False, 5, 0, 52), 2291: ("Upper Blackrock Spire", False, 10, 0, 55),
    429: ("Dire Maul", False, 5, 0, 52), 289: ("Scholomance", False, 5, 0, 55), 329: ("Stratholme", False, 5, 0, 55),
    409: ("Molten Core", True, 40, 0, 58), 249: ("Onyxia's Lair", True, 40, 1, 58), 469: ("Blackwing Lair", True, 40, 2, 58),
    309: ("Zul'Gurub", True, 20, 3, 58), 509: ("Ruins of Ahn'Qiraj", True, 20, 4, 58),
    531: ("Temple of Ahn'Qiraj", True, 40, 4, 58), 533: ("Naxxramas", True, 40, 6, 58),
}
UBRS_BOSSES = {"Pyroguard Emberseer", "Solakar Flamewreath", "Jed Runewatcher", "Goraluk Anvilcrack", "Warchief Rend Blackhand",
               "Gyth", "The Beast", "General Drakkisath", "Lord Valthalak", "Father Flame", "Rookery Hatcher"}

# creature -> instance maps it spawns in
cmaps = collections.defaultdict(set)
for r in R("creature"):
    if r["map"] in INSTANCES:
        cmaps[r["id1"]].add(r["map"])
gmaps = collections.defaultdict(set)
for r in R("gameobject"):
    if r["map"] in INSTANCES:
        gmaps[r["id"]].add(r["map"])

# Bosses the realm summons rather than spawns
SUMMONED = {10584: 229, 10268: 229, 10264: 2291, 10813: 329, 10439: 329, 8443: 109, 7273: 209, 7796: 209, 7275: 209,
            11583: 469, 11502: 409, 15517: 531, 15083: 309, 15114: 309, 14515: 309}
SUMMONED.update({e: 533 for e in range(351000, 351040)})
BY_NAME = {"Gri'lek": 309, "Renataki": 309, "Wushoolay": 309, "Lord Valthalak": 2291, "Mor Grayhoof": 229, "Isalien": 429,
           "Kormok": 289, "Sothos": 329, "Jarien": 329, "Postmaster Malown": 329, "Lord Kri": 531, "Vem": 531,
           "Princess Yauj": 531}
for c in ctpl.values():
    if c["name"] in BY_NAME and c["lootid"] and c["maxlevel"] <= 63:
        SUMMONED.setdefault(c["entry"], BY_NAME[c["name"]])
GO_BY_NAME = {"Cache of the Firelord": 409}
for g in gtpl.values():
    if g["name"] in GO_BY_NAME and g["type"] == 3:
        gmaps[g["entry"]].add(GO_BY_NAME[g["name"]])

# ---------------------------------------------------------------- loot
def group_loot(table):
    by = collections.defaultdict(list)
    for r in R(table):
        r.setdefault("Reference", 0); r.setdefault("LootMode", 1); r.setdefault("QuestRequired", 0)
        r.setdefault("GroupId", 0); r.setdefault("MaxCount", 1)
        by[r["Entry"]].append(r)
    return by

CLT, RLT, GLT = group_loot("creature_loot_template"), group_loot("reference_loot_template"), group_loot("gameobject_loot_template")


def resolve(rows, depth=0, quest=False):
    """item -> chance (0..1) for one loot template's rows, references followed. quest: quest items too."""
    out = collections.defaultdict(float)
    if depth > 4:
        return out
    groups = collections.defaultdict(list)
    for r in rows:
        if (r.get("QuestRequired") and not quest) or not (r.get("LootMode", 1) & 1):
            continue
        groups[r.get("GroupId", 0)].append(r)
    for gid, rs in groups.items():
        if gid == 0:
            for r in rs:
                ch = (r["Chance"] or 100) / 100.0 if r["Reference"] else abs(r["Chance"]) / 100.0
                if r["Reference"]:
                    rolls = max(1, r.get("MaxCount") or 1)
                    for it, c in resolve(RLT.get(r["Reference"], []), depth + 1, quest).items():
                        out[it] = min(1.0, out[it] + ch * min(1.0, c * rolls))
                else:
                    out[r["Item"]] = min(1.0, out[r["Item"]] + ch)
        else:
            explicit = sum(abs(r["Chance"]) for r in rs if r["Chance"])
            zero = [r for r in rs if not r["Chance"]]
            share = max(0.0, 100 - explicit) / len(zero) if zero else 0
            for r in rs:
                ch = (abs(r["Chance"]) if r["Chance"] else share) / 100.0
                if r["Reference"]:
                    for it, c in resolve(RLT.get(r["Reference"], []), depth + 1, quest).items():
                        out[it] = min(1.0, out[it] + ch * c)
                else:
                    out[r["Item"]] = min(1.0, out[r["Item"]] + ch)
    return out


def inst_key(mapid, name):
    if mapid == 229 and name in UBRS_BOSSES:
        return 2291
    return mapid


EQUIP = {1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 20, 21, 22, 23, 25, 26, 28}


def classic_gear(e):
    it = items.get(e)
    return (it is not None and it["InventoryType"] in EQUIP and it["Quality"] >= 2 and it["ItemLevel"] <= 92
            and it["RequiredLevel"] <= 60 and it["ItemLevel"] >= 35)


sources = collections.defaultdict(list)   # item -> [source]
drops_of = collections.defaultdict(dict)  # item -> {inst: chance} for token detection (any item)

for e, maps in list(cmaps.items()) + [(k, {v}) for k, v in SUMMONED.items()]:
    c = ctpl.get(e)
    if not c or not c["lootid"]:
        continue
    loot = resolve(CLT.get(c["lootid"], []))
    for m in maps:
        ik = inst_key(m if m != 2291 else 229, c["name"]) if m != 2291 else 2291
        for it, ch in resolve(CLT.get(c["lootid"], []), quest=True).items():
            if it not in loot and ch >= 0.004:
                drops_of[it][ik] = max(drops_of[it].get(ik, 0), ch)
        for it, ch in loot.items():
            if ch < 0.004:
                continue
            drops_of[it][ik] = max(drops_of[it].get(ik, 0), ch)
            if classic_gear(it):
                sources[it].append({"k": "D", "i": ik, "n": c["name"], "c": round(ch, 4), "rank": c["rank"]})

for e, maps in gmaps.items():
    g = gtpl.get(e)
    if not g or g["type"] != 3 or not g["Data1"]:
        continue
    loot = resolve(GLT.get(g["Data1"], []))
    for m in maps:
        for it, ch in loot.items():
            if ch < 0.004:
                continue
            drops_of[it][m] = max(drops_of[it].get(m, 0), ch)
            if classic_gear(it):
                sources[it].append({"k": "C", "i": m, "n": g["name"], "c": round(ch, 4)})

# Item containers (e.g. tier bags / Cache of the Firelord style items that are opened)
for e, rows in group_loot("item_loot_template").items():
    loot = resolve(rows)
    origin = drops_of.get(e)
    if not origin:
        continue
    for it, ch in loot.items():
        for ik, och in origin.items():
            drops_of[it][ik] = max(drops_of[it].get(ik, 0), ch * och)
            if classic_gear(it) and ch * och >= 0.004:
                sources[it].append({"k": "D", "i": ik, "n": items[e]["name"], "c": round(ch * och, 4)})

# ---------------------------------------------------------------- quests
RAIDS = {k for k, v in INSTANCES.items() if v[1]}
# Quests filed under an instance (their zone is the instance's area): they're done there.
QUEST_ZONE = {19: 309, 2717: 409, 2677: 469, 2159: 249, 3429: 509, 3428: 531, 3456: 533, 2017: 329, 2057: 289,
              1584: 230, 1583: 229, 2557: 429, 1477: 109, 2100: 349, 1176: 209, 1337: 70}
# Quests behind a world boss event.
SKIP_QUESTS = {8736}
SILITHUS = 1377
FACTION_STAGE = {270: 3, 609: 4, 910: 4}
qstarters = collections.defaultdict(list)
for r in R("creature_queststarter"):
    qstarters[r["quest"]].append(r["id"])


def quest_ok(q):
    if not (q["ID"] < 9500 or q["ID"] >= 100000):
        return False
    if (q.get("MinLevel") or 0) > 60 or (q.get("QuestLevel") or 0) > 63:
        return False
    return True


prev_of = collections.defaultdict(set)
for q in quests.values():
    if q.get("RewardNextQuest"):
        prev_of[q["RewardNextQuest"]].add(q["ID"])
for a in qaddon.values():
    if (a.get("PrevQuestID") or 0) > 0:
        prev_of[a["ID"]].add(a["PrevQuestID"])
    if (a.get("NextQuestID") or 0) > 0:
        prev_of[a["NextQuestID"]].add(a["ID"])


def quest_via(qid, depth=0, seen=None):
    """The raid a quest's required items (or those of the quests before it) drop in, and its stage."""
    seen = seen or set()
    if qid in seen or depth > 6 or qid not in quests:
        return None, 0
    seen.add(qid)
    q = quests[qid]
    via, stage = None, 0
    for ri in [q.get("RequiredItemId%d" % i) for i in range(1, 7)] + [q.get("StartItem")]:
        for ik in drops_of.get(ri or 0, {}):
            if ik in RAIDS and (via is None or INSTANCES[ik][3] > stage):
                via, stage = ik, INSTANCES[ik][3]
    if via is None:
        for p in prev_of.get(qid, ()):
            v, st = quest_via(p, depth + 1, seen)
            if v is not None and (via is None or st > stage):
                via, stage = v, st
    return via, stage


def quest_tokens(qid, depth=0, seen=None):
    """The raid drops a quest (or the quests before it) asks you to hand in: tier tokens, Head of Onyxia."""
    seen = seen or set()
    if qid in seen or depth > 6 or qid not in quests:
        return set()
    seen.add(qid)
    q = quests[qid]
    out = set()
    for ri in [q.get("RequiredItemId%d" % i) for i in range(1, 7)] + [q.get("StartItem")]:
        if ri and any(ik in RAIDS for ik in drops_of.get(ri, {})):
            out.add(ri)
    if not out:
        for p in prev_of.get(qid, ()):
            out |= quest_tokens(p, depth + 1, seen)
    return out


# mod-individual-progression's quest gating, as the Journal reads it: conditions on its stage quests
# (66000 + stage), and the era scripts on the quest's giver. -> quest: (first stage, stage it goes away at)
ERA_SCRIPTS = {"npc_ipp_preaq": (3, 255), "gobject_ipp_preaq": (3, 255), "npc_ipp_we": (3, 4), "npc_ipp_aqwewar": (3, 5),
               "npc_ipp_aqwar": (4, 5), "gobject_ipp_aqwar": (4, 5), "npc_ipp_aq": (5, 255), "npc_ipp_si": (6, 7),
               "gobject_ipp_si": (6, 7), "npc_ipp_naxx40": (6, 255), "gobject_ipp_naxx40": (6, 255),
               "npc_ipp_pre_naxx40": (0, 6), "npc_ipp_pre_tbc": (0, 8), "gobject_ipp_pre_tbc": (0, 8),
               "npc_ipp_tbc": (8, 255), "gobject_ipp_tbc": (8, 255), "npc_ipp_zg": (3, 255), "npc_ipp_ds2": (3, 255)}
quest_era = collections.defaultdict(lambda: [0, 255])
for r in R("conditions"):
    if (r.get("SourceTypeOrReferenceId") == 19 and r.get("ConditionTypeOrReference") == 8 and not r.get("NegativeCondition")
            and 66001 <= (r.get("ConditionValue1") or 0) <= 66018):
        e = quest_era[r["SourceEntry"]]
        e[0] = max(e[0], r["ConditionValue1"] - 66000)
for r in R("creature_queststarter"):
    sc = (ctpl.get(r["id"]) or {}).get("ScriptName") or ""
    if sc in ERA_SCRIPTS:
        e = quest_era[r["quest"]]
        e[0], e[1] = max(e[0], ERA_SCRIPTS[sc][0]), min(e[1], ERA_SCRIPTS[sc][1])
for r in R("gameobject_queststarter"):
    sc = (gtpl.get(r["id"]) or {}).get("ScriptName") or ""
    if sc in ERA_SCRIPTS:
        e = quest_era[r["quest"]]
        e[0], e[1] = max(e[0], ERA_SCRIPTS[sc][0]), min(e[1], ERA_SCRIPTS[sc][1])

# Quests that need an epic quest item from outside the instances (world bosses' dragon heads and the like)
# aren't something to point a player at. Epic crafting materials (Nexus Crystals) don't count.
instance_items = set(drops_of)


def era_of(qid, depth=0, seen=None):
    """A quest's (first stage, stage it goes away at): its own, or the chain's before it."""
    seen = seen or set()
    if qid in seen or depth > 10:
        return None
    seen.add(qid)
    if qid in quest_era:
        return quest_era[qid]
    for p in prev_of.get(qid, ()):
        e = era_of(p, depth + 1, seen)
        if e:
            return e
    return None


def quest_min_level(q):
    return (q.get("MinLevel") or 0) or max(1, (q.get("QuestLevel") or 1) - 4)


HORDE, ALLIANCE = 690, 1101  # race masks
gstarters = collections.defaultdict(list)
for r in R("gameobject_queststarter"):
    gstarters[r["quest"]].append(r["id"])


def chain_start(qid, races=0):
    """The first quest of a quest's chain for a faction (races: its race mask, 0 for either), and how many
    quests the chain has up to and including it."""
    def fits(p):
        m = quests[p].get("AllowableRaces") or 0
        return not races or not m or (m & races)
    seen, cur, n = {qid}, qid, 1
    while True:
        prevs = [p for p in sorted(prev_of.get(cur, ())) if p in quests and p not in seen and fits(p)]
        if not prevs:
            return cur, n
        a = qaddon.get(cur, {})
        cur = a.get("PrevQuestID") if a.get("PrevQuestID") in prevs else prevs[0]
        seen.add(cur)
        n += 1
        if n > 25:
            return cur, n


def giver_info(qid):
    """How many quest givers start a quest, and whether they're all trainers (a class quest from any trainer)."""
    cs = qstarters.get(qid, [])
    trainer = bool(cs) and all(((ctpl.get(c) or {}).get("npcflag") or 0) & 16 for c in cs)
    return len(cs) + len(gstarters.get(qid, [])), trainer


def needs_world_epic(q, depth=0):
    for ri in [q.get("RequiredItemId%d" % i) for i in range(1, 7)] + [q.get("StartItem")]:
        it = items.get(ri or 0)
        if it and it["Quality"] >= 4 and it["class"] == 12 and ri not in instance_items:
            return True
    if depth < 6:
        for p in prev_of.get(q["ID"], ()):
            if p in quests and needs_world_epic(quests[p], depth + 1):
                return True
    # a quest an item starts: that item's own quest chain
    return False


for q in quests.values():
    if not quest_ok(q) or needs_world_epic(q):
        continue
    rewards = [(q.get("RewardItem%d" % i) or 0) for i in range(1, 5)] + [(q.get("RewardChoiceItemID%d" % i) or 0) for i in range(1, 7)]
    rewards = [x for x in rewards if x and classic_gear(x)]
    if not rewards:
        continue
    title = q.get("LogTitle") or ""
    if q["ID"] in SKIP_QUESTS or (q.get("QuestSortID") or 0) in (-364, -25, 2597, 3277, 3358):
        continue  # world events, the Darkmoon Faire, battlegrounds
    if re.search(r"UNUSED|NYI|\[PH\]|<TXT>|<TEST>|DEPRECATED|OLD\b", title, re.I) or not title:
        continue
    via, stage = quest_via(q["ID"])
    if via is None and (q.get("QuestSortID") or 0) in QUEST_ZONE:
        via = QUEST_ZONE[q["QuestSortID"]]
        stage = max(stage, INSTANCES[via][3])
    if (q.get("QuestSortID") or 0) == SILITHUS:
        stage = max(stage, 4)
    a = qaddon.get(q["ID"], {})
    for f in (q.get("RequiredFactionId1"), q.get("RequiredFactionId2"), a.get("RequiredMinRepFaction")):
        if f in FACTION_STAGE:
            stage = max(stage, FACTION_STAGE[f])
    era = era_of(q["ID"])
    end = 255
    if era:
        stage, end = max(stage, era[0]), era[1]
    if end <= 8 and end <= stage:
        continue
    for it in rewards:
        chains = {}
        for side, mask in (("A", ALLIANCE), ("H", HORDE)):
            start, steps = chain_start(q["ID"], mask)
            givers, trainer = giver_info(start)
            chains[side] = (start, quests[start].get("LogTitle") or "", givers, 1 if trainer else 0, steps)
        need = max(quest_min_level(q), min(quest_min_level(quests[chains["A"][0]]), quest_min_level(quests[chains["H"][0]])))
        sources[it].append({"k": "Q", "q": q["ID"], "n": (q.get("LogTitle") or ""), "lvl": (q.get("QuestLevel") or 0), "i": via, "st": stage,
                            "need": need, "chains": chains, "tokens": sorted(quest_tokens(q["ID"])) if via in RAIDS else [],
                            "races": (q.get("AllowableRaces") or 0), "classes": a.get("AllowableClasses", 0) or 0, "end": end})

# ---------------------------------------------------------------- vendors (Eastern Kingdoms / Kalimdor only)
continent = collections.defaultdict(set)
for r in R("creature"):
    continent[r["id1"]].add(r["map"])
for r in R("npc_vendor"):
    it, e = r["item"], r["entry"]
    if not classic_gear(it) or r.get("ExtendedCost"):
        continue
    if not (continent.get(e, set()) & {0, 1}):
        continue
    x = items[it]
    if x["requiredhonorrank"]:
        continue
    c = ctpl.get(e, {})
    sources[it].append({"k": "V", "n": c.get("name", "?"), "sub": c.get("subname") or "", "price": x["BuyPrice"],
                        "rep": x["RequiredReputationFaction"], "rank": x["RequiredReputationRank"],
                        "st": FACTION_STAGE.get(x["RequiredReputationFaction"], 0)})

pickle.dump({"sources": dict(sources), "instances": INSTANCES}, open(os.path.join(BUILD, "sources.pkl"), "wb"))
print("items with sources:", len(sources))
cnt = collections.Counter(s["k"] for v in sources.values() for s in v)
print(cnt)
