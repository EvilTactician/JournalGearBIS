"""What makes an item or puts on an enchant: the profession, the skill it needs and the recipe it's learnt from.

From the client's Spell.dbc (spells that create an item or enchant one), SkillLineAbility.dbc (the profession a
spell belongs to) and SkillLine.dbc (its name), and the realm's trainers, recipe items and discoveries (the skill
a recipe needs)."""
import collections
import os
from dbc import load, i32

PROFESSIONS = {164: "Blacksmithing", 165: "Leatherworking", 171: "Alchemy", 182: "Herbalism", 185: "Cooking",
               186: "Mining", 197: "Tailoring", 202: "Engineering", 333: "Enchanting", 356: "Fishing",
               393: "Skinning", 129: "First Aid", 755: "Jewelcrafting", 773: "Inscription"}

# The highest skill a profession reaches before The Burning Crusade (mod-individual-progression's
# ProfessionTierCap: Artisan until stage 8).
CLASSIC_CAP = 300


class Crafts:
    def __init__(self, build, rows, items, spells=None):
        self.spells = spells or load(os.path.join(build, "dbc", "Spell.dbc"))[0]
        sla = load(os.path.join(build, "dbc", "SkillLineAbility.dbc"))[0]
        self.skill_of = {}
        for r in sla.values():
            if r[1] in PROFESSIONS:
                self.skill_of.setdefault(r[2], r[1])
        self.trainer = collections.defaultdict(int)
        for r in rows("trainer_spell"):
            if r.get("SpellId"):
                self.trainer[r["SpellId"]] = max(self.trainer[r["SpellId"]], r.get("ReqSkillRank") or 0)
        self.recipe = {}
        for it in items.values():
            if it["class"] == 9 and it.get("spellid_2"):
                self.recipe[it["spellid_2"]] = it["entry"]
        self.recipe_rank = {s: items[i]["RequiredSkillRank"] or 0 for s, i in self.recipe.items()}
        self.discovery = {}
        for r in rows("skill_discovery_template"):
            if r.get("spellId"):
                self.discovery[r["spellId"]] = max(self.discovery.get(r["spellId"], 0), r.get("reqSkillValue") or 0)
        self.creates = collections.defaultdict(list)   # item -> [spell]
        self.enchants = collections.defaultdict(list)  # enchant id -> [spell]
        for sid, r in self.spells.items():
            for k in range(3):
                if r[71 + k] == 24 and r[107 + k]:
                    self.creates[r[107 + k]].append(sid)
                elif r[71 + k] == 53 and r[110 + k]:
                    self.enchants[r[110 + k]].append(sid)

    def rank(self, sid):
        """The skill a profession spell needs, or None when nothing says."""
        for src in (self.trainer, self.recipe_rank, self.discovery):
            if src.get(sid):
                return src[sid]
        return None

    def ways(self, spells):
        """[(profession, skill, spell, recipe item or 0)] for those of these spells a profession has."""
        out = []
        for sid in spells:
            skill = self.skill_of.get(sid)
            rank = self.rank(sid) if skill else None
            if skill and rank is not None:
                out.append((skill, rank, sid, self.recipe.get(sid, 0)))
        return sorted(out, key=lambda w: w[1])

    def made_by(self, item):
        return self.ways(self.creates.get(item, []))

    def enchanted_by(self, enchant):
        return self.ways(self.enchants.get(enchant, []))
