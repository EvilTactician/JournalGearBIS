"""Level 80 talent builds, one per spec, saved to DragonUI's talent builds from the Gear tab.

Each build is the first one a spec's Warcraft Tavern guide lists (their Wrath guides are written for 3.3.5a),
read from the guide's talent calculator link and checked against the realm's own talent trees (Talent.dbc):
every rank within the talent's maximum, five points per tier above it, the talents they need first, 71 points.
Stored by tier and column, not name, so a non-English client matches them too.

Formats:
  tavern   Warcraft Tavern's ?t= string: A, B and C pick the tree, each character after is a point in the talent
           at tier * 4 + column (0-9, a-z, then D-Z)
  wowhead  wowhead.com/wotlk/talent# (and wotlkdb.com/?talent#) strings: a class character, then two talents
           a character (rank * 6 + rank), Z ending a tree early
"""
import os
from dbc import load

HERE = os.path.dirname(os.path.abspath(__file__))
BUILD = os.environ.get("GEARBIS_BUILD", os.path.join(HERE, "build"))

BUILDS = {
    # key: a profile, or CLASS:tree for classes whose profiles don't follow the trees one to one
    "DRUID_CAT": ("DRUID", "GearBIS: Feral (Cat)", "tavern",
                  "B1111155444aaa88ccdddeeffimmmlllllpqquuussswwwxEEEEEFIC222220044444666aa9",
                  "warcrafttavern.com/wotlk/guides/pve-feral-druid-dps-talents-builds"),
    "DRUID_BEAR": ("DRUID", "GearBIS: Feral (Bear)", "wowhead", "0ZxGGsfrzceRcczAkbA0z",
                   "warcrafttavern.com/wotlk/guides/pve-feral-druid-tank-talents-builds-glyphs"),
    "DRUID_RESTO": ("DRUID", "GearBIS: Restoration", "tavern",
                    "A2222255444aC00111555666aa9888eeehhhhhgmmmmmqqpoootttttuuuxyyywwwFFFFFIkk",
                    "warcrafttavern.com/wotlk/guides/pve-restoration-druid-talents-builds-glyphs"),
    "ROGUE:1": ("ROGUE", "GearBIS: Assassination", "tavern",
                "A22222444777aaaaaeeeeedddhjjlllllmmpuuussswwwxEEEEEIB2222277777aaaC2200000",
                "warcrafttavern.com/wotlk/guides/pve-assassination-rogue-talents-builds-glyphs"),
    "ROGUE:2": ("ROGUE", "GearBIS: Combat", "tavern",
                "A2222255444aaaaaeedddB112222277777448eeefffffhiiiiillmmpooouuuuuyyxEEEEEI",
                "chosen by the user from Warcraft Tavern's talent calculator"),
    "DRUID_BALANCE": ("DRUID", "GearBIS: Balance", "tavern",
                      "A1111144455999abbeeedddddggghiiilllmmpqqqrrruuuuuwwwxyzEEEIC2222200666aa9",
                      "chosen by the user from Warcraft Tavern's talent calculator"),
    "PRIEST:1": ("PRIEST", "GearBIS: Discipline", "tavern",
                 "A22222555668889aaadddhhhhhikkmmmpqqqsstttuuwwwxyyEEEEEIB002222255555bbbdd",
                 "warcrafttavern.com/wotlk/guides/pve-discipline-priest-healer-talents-builds-glyphs"),
    "PRIEST:2": ("PRIEST", "GearBIS: Holy", "wowhead", "bVcbhZfxtccMqih0euVo",
                 "warcrafttavern.com/wotlk/guides/pve-holy-priest-healer-talents-builds-glyphs"),
    "PRIEST:3": ("PRIEST", "GearBIS: Shadow", "tavern",
                 "C22222A2222255566888C666559999aeefffhjjddmmmkkpqqqqqssuuuxyyyFFFFFI9C00011A9",
                 "warcrafttavern.com/wotlk/guides/pve-shadow-priest-talents-builds-glyphs"),
}

CLASS = {1: "WARRIOR", 2: "PALADIN", 4: "HUNTER", 8: "ROGUE", 16: "PRIEST", 32: "DEATHKNIGHT", 64: "SHAMAN",
         128: "MAGE", 256: "WARLOCK", 1024: "DRUID"}
WT = "0123456789abcdefghijklmnopqrstuvwxyzDEFGHIJKLMNOPQRSTUVWXYZ"
WH = "0zMcmVokRsaqbdrfwihuGINALpTjnyxtgevElBCDFHJKOPQSUWXYZ123456789"


def class_trees(cls):
    T, _, _ = load(os.path.join(BUILD, "dbc", "Talent.dbc"))
    TT, _, _ = load(os.path.join(BUILD, "dbc", "TalentTab.dbc"))
    tabs = sorted((t[22], tid) for tid, t in TT.items() if CLASS.get(t[20]) == cls and t[21] == 0)
    out = []
    for _, tab in tabs:
        rows = [{"id": t[0], "tier": t[2], "col": t[3], "max": len([r for r in t[4:13] if r]), "prereq": t[13],
                 "prereqRank": t[16]} for t in T.values() if t[1] == tab]
        rows.sort(key=lambda r: (r["tier"], r["col"]))
        out.append(rows)
    return out


def decode(cls, fmt, text):
    tl = class_trees(cls)
    ranks = [[0] * len(t) for t in tl]
    if fmt == "tavern":
        pos = [{x["tier"] * 4 + x["col"]: j for j, x in enumerate(t)} for t in tl]
        tree = 0
        for ch in text:
            if ch in "ABC":
                tree = "ABC".index(ch)
            else:
                ranks[tree][pos[tree][WT.index(ch)]] += 1
    else:
        tree, i = 0, 0
        for ch in text[1:]:
            if tree >= 3:
                break
            if ch == "Z":
                tree, i = tree + 1, 0
                continue
            v = WH.index(ch)
            for r in (v // 6, v % 6):
                if i < len(tl[tree]):
                    ranks[tree][i] = r
                    i += 1
            if i >= len(tl[tree]):
                tree, i = tree + 1, 0
    return tl, ranks


def check(tl, ranks):
    errs, total = [], 0
    for t, rk in zip(tl, ranks):
        byid = {x["id"]: j for j, x in enumerate(t)}
        for j, x in enumerate(t):
            r = rk[j]
            if r > x["max"]:
                errs.append("rank over max")
            if r:
                if sum(rk[q] for q, y in enumerate(t) if y["tier"] < x["tier"]) < 5 * x["tier"]:
                    errs.append("tier not open")
                if x["prereq"] in byid and rk[byid[x["prereq"]]] < x["prereqRank"] + 1:
                    errs.append("needs another talent first")
        total += sum(rk)
    if total != 71:
        errs.append("%d points, not 71" % total)
    return errs


def all_builds():
    """key -> (class, name, [per tree: [(tier, column, rank)]]), each checked; raises on a bad one."""
    out = {}
    for key, (cls, name, fmt, text, _) in BUILDS.items():
        tl, ranks = decode(cls, fmt, text)
        errs = check(tl, ranks)
        if errs:
            raise SystemExit("talent build %s: %s" % (key, ", ".join(sorted(set(errs)))))
        out[key] = (cls, name, [[(x["tier"] + 1, x["col"] + 1, r) for x, r in zip(t, rk) if r] for t, rk in zip(tl, ranks)])
    return out
