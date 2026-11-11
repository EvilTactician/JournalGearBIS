-- Spec profiles for JournalGearBIS: what each stat is worth, and which weapons a spec uses. Edit freely.
--
--   weights: per point of a stat, in the profile's own units (attack power for melee and hunters, spell power
--            for casters and healers, stamina for tanks). Ratings are per rating point.
--            dps / odps / rdps: per point of main hand / off hand / ranged weapon damage per second.
--   weapons: "dw" two one-handers, "2h" a two-hander, "caster" a one-hander and held item or shield, or a
--            staff, "tank" a one-hander and shield, "hunter" melee stat stick and a bow, gun or crossbow.
--   mh / oh: weapon subclasses allowed in that hand (4 mace, 7 sword, 13 fist, 15 dagger); none = any.
--   ranged:  "ranged" bows, guns, crossbows and thrown; "wand"; "relic" (libram, idol or totem).

local G = JournalGearBIS

G.profiles = {
	ROGUE_SWORDS = { class = "ROGUE", name = "Swords & maces", role = "Melee damage", weapons = "dw", ranged = "ranged", mh = { [4] = true, [7] = true, [13] = true }, oh = { [4] = true, [7] = true, [13] = true, [15] = true },
		weights = { agi = 1.6, ap = 1, arp = 0.3, crit = 1.3, dps = 9, exp = 1, haste = 0.8, hit = 1.6, mcrit = 1.3, mhaste = 0.8, mhit = 1.6, odps = 4, rdps = 0.5, sta = 0.1, str = 1, wskill = 0.5 } },
	ROGUE_DAGGERS = { class = "ROGUE", name = "Daggers", role = "Melee damage", weapons = "dw", ranged = "ranged", mh = { [15] = true }, oh = { [4] = true, [7] = true, [13] = true, [15] = true },
		weights = { agi = 1.6, ap = 1, arp = 0.3, crit = 1.3, dps = 9, exp = 1, haste = 0.8, hit = 1.6, mcrit = 1.3, mhaste = 0.8, mhit = 1.6, odps = 4, rdps = 0.5, sta = 0.1, str = 1, wskill = 0.5 } },
	WARRIOR_ARMS = { class = "WARRIOR", name = "Arms", role = "Melee damage", weapons = "2h", ranged = "ranged",
		weights = { agi = 1, ap = 1, arp = 0.3, crit = 1.3, dps = 12, exp = 1, haste = 0.8, hit = 1.6, mcrit = 1.3, mhaste = 0.8, mhit = 1.6, rdps = 0.3, sta = 0.1, str = 2, wskill = 0.5 } },
	WARRIOR_FURY = { class = "WARRIOR", name = "Fury", role = "Melee damage", weapons = "dw", ranged = "ranged",
		weights = { agi = 1, ap = 1, arp = 0.3, crit = 1.3, dps = 10, exp = 1, haste = 0.8, hit = 1.6, mcrit = 1.3, mhaste = 0.8, mhit = 1.6, odps = 5, rdps = 0.3, sta = 0.1, str = 2, wskill = 0.5 } },
	WARRIOR_PROT = { class = "WARRIOR", name = "Protection", role = "Tank", weapons = "tank", ranged = "ranged",
		weights = { agi = 0.6, ap = 0.1, armor = 0.06, block = 0.5, bv = 0.3, def = 1.2, dodge = 1, dps = 2, exp = 0.4, hit = 0.3, mhit = 0.3, parry = 0.9, rdps = 0.1, sta = 1, str = 0.4 } },
	PALADIN_HOLY = { class = "PALADIN", name = "Holy", role = "Healer", weapons = "caster", ranged = "relic",
		weights = { crit = 0.4, haste = 0.4, heal = 1, int = 0.9, mp5 = 1.5, scrit = 0.4, shaste = 0.4, sp = 1, spi = 0.15, sta = 0.05 } },
	PALADIN_PROT = { class = "PALADIN", name = "Protection", role = "Tank", weapons = "tank", ranged = "relic",
		weights = { agi = 0.4, armor = 0.06, block = 0.5, bv = 0.3, def = 1.2, dmg = 0.4, dodge = 1, dps = 2, exp = 0.4, hit = 0.3, int = 0.1, mhit = 0.3, parry = 0.9, sp = 0.4, sta = 1, str = 0.3 } },
	PALADIN_RET = { class = "PALADIN", name = "Retribution", role = "Melee damage", weapons = "2h", ranged = "relic",
		weights = { agi = 1, ap = 1, arp = 0.3, crit = 1.3, dps = 12, exp = 1, haste = 0.8, hit = 1.6, int = 0.2, mcrit = 1.3, mhaste = 0.8, mhit = 1.6, sp = 0.2, sta = 0.1, str = 2, wskill = 0.5 } },
	HUNTER = { class = "HUNTER", name = "Hunter", role = "Ranged damage", weapons = "hunter", ranged = "ranged",
		weights = { agi = 1.6, ap = 0.3, arp = 0.3, crit = 0.9, dps = 0.3, haste = 0.6, hit = 1.4, int = 0.3, mcrit = 0.9, mhaste = 0.6, mhit = 1.4, mp5 = 0.5, odps = 0.2, rap = 1, rdps = 12, sta = 0.1, wskill = 0.2 } },
	PRIEST_HEAL = { class = "PRIEST", name = "Holy & Discipline", role = "Healer", weapons = "caster", ranged = "wand",
		weights = { crit = 0.4, haste = 0.4, heal = 1, int = 0.5, mp5 = 1.5, scrit = 0.4, shaste = 0.4, sp = 1, spi = 0.6, sta = 0.05 } },
	PRIEST_SHADOW = { class = "PRIEST", name = "Shadow", role = "Spell damage", weapons = "caster", ranged = "wand",
		weights = { crit = 0.6, dmg = 1, haste = 0.6, hit = 1.2, int = 0.3, mp5 = 0.3, scrit = 0.6, shadow = 1, shaste = 0.6, shit = 1.2, sp = 1, spen = 0.1, spi = 0.15, sta = 0.15 } },
	SHAMAN_ELE = { class = "SHAMAN", name = "Elemental", role = "Spell damage", weapons = "caster", ranged = "relic",
		weights = { crit = 0.8, dmg = 1, fire = 0.3, frost = 0.3, haste = 0.6, hit = 1.2, int = 0.4, mp5 = 0.6, nature = 1, scrit = 0.8, shaste = 0.6, shit = 1.2, sp = 1, spen = 0.1, sta = 0.1 } },
	SHAMAN_ENH = { class = "SHAMAN", name = "Enhancement", role = "Melee damage", weapons = "2h", ranged = "relic",
		weights = { agi = 1.3, ap = 1, arp = 0.3, crit = 1.3, dps = 12, exp = 1, haste = 0.8, hit = 1.6, int = 0.2, mcrit = 1.3, mhaste = 0.8, mhit = 1.6, sta = 0.1, str = 2, wskill = 0.5 } },
	SHAMAN_RESTO = { class = "SHAMAN", name = "Restoration", role = "Healer", weapons = "caster", ranged = "relic",
		weights = { crit = 0.4, haste = 0.4, heal = 1, int = 0.7, mp5 = 1.6, scrit = 0.4, shaste = 0.4, sp = 1, spi = 0.2, sta = 0.05 } },
	MAGE = { class = "MAGE", name = "Mage", role = "Spell damage", weapons = "caster", ranged = "wand",
		weights = { arcane = 0.3, crit = 0.8, dmg = 1, fire = 0.5, frost = 0.5, haste = 0.6, hit = 1.2, int = 0.4, scrit = 0.8, shaste = 0.6, shit = 1.2, sp = 1, spen = 0.1, spi = 0.1, sta = 0.1 } },
	WARLOCK = { class = "WARLOCK", name = "Warlock", role = "Spell damage", weapons = "caster", ranged = "wand",
		weights = { crit = 0.4, dmg = 1, fire = 0.3, haste = 0.6, hit = 1.2, int = 0.3, scrit = 0.4, shadow = 1, shaste = 0.6, shit = 1.2, sp = 1, spen = 0.1, spi = 0.05, sta = 0.3 } },
	DRUID_BALANCE = { class = "DRUID", name = "Balance", role = "Spell damage", weapons = "caster", ranged = "relic",
		weights = { arcane = 0.6, crit = 0.6, dmg = 1, haste = 0.6, hit = 1.2, int = 0.4, mp5 = 0.4, nature = 0.6, scrit = 0.6, shaste = 0.6, shit = 1.2, sp = 1, spen = 0.1, spi = 0.1, sta = 0.1 } },
	DRUID_CAT = { class = "DRUID", name = "Feral (cat)", role = "Melee damage", weapons = "caster", ranged = "relic",
		weights = { agi = 1.6, ap = 1, arp = 0.3, crit = 1.3, exp = 1, fap = 1, haste = 0.8, hit = 1.6, mcrit = 1.3, mhaste = 0.8, mhit = 1.6, sta = 0.1, str = 2, wskill = 0.5 } },
	DRUID_BEAR = { class = "DRUID", name = "Feral (bear)", role = "Tank", weapons = "caster", ranged = "relic",
		weights = { agi = 1, ap = 0.2, armor = 0.12, block = 0.5, bv = 0.3, def = 1.2, dodge = 1, exp = 0.4, fap = 0.2, hit = 0.3, mhit = 0.3, parry = 0.9, sta = 1, str = 0.5 } },
	DRUID_RESTO = { class = "DRUID", name = "Restoration", role = "Healer", weapons = "caster", ranged = "relic",
		weights = { crit = 0.4, haste = 0.4, heal = 1, int = 0.5, mp5 = 1.5, scrit = 0.4, shaste = 0.4, sp = 1, spi = 0.7, sta = 0.05 } },
}

-- The profile for each talent tree (1, 2, 3), by class.
G.byTree = {
	WARRIOR = { "WARRIOR_ARMS", "WARRIOR_FURY", "WARRIOR_PROT" },
	PALADIN = { "PALADIN_HOLY", "PALADIN_PROT", "PALADIN_RET" },
	HUNTER = { "HUNTER", "HUNTER", "HUNTER" },
	ROGUE = { "ROGUE_DAGGERS", "ROGUE_SWORDS", "ROGUE_SWORDS" },
	PRIEST = { "PRIEST_HEAL", "PRIEST_HEAL", "PRIEST_SHADOW" },
	SHAMAN = { "SHAMAN_ELE", "SHAMAN_ENH", "SHAMAN_RESTO" },
	MAGE = { "MAGE", "MAGE", "MAGE" },
	WARLOCK = { "WARLOCK", "WARLOCK", "WARLOCK" },
	DRUID = { "DRUID_BALANCE", "DRUID_CAT", "DRUID_RESTO" },
}
