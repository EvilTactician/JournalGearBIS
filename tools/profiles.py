"""Spec profiles: stat weights and weapon rules. Shared by the data build (prefilter) and Profiles.lua (runtime)."""

# Stat keys:
# agi str int spi sta ap rap fap hit mhit shit crit mcrit scrit haste mhaste shaste sp heal dmg mp5
# def dodge parry block bv exp arp spen armor   + weapon: dps (main hand) / odps (off hand) / rdps (ranged)
MELEE = dict(ap=1.0, wskill=0.5, hit=1.6, mhit=1.6, crit=1.3, mcrit=1.3, haste=0.8, mhaste=0.8, arp=0.3, exp=1.0, sta=0.1)
CASTER = dict(sp=1.0, dmg=1.0, hit=1.2, shit=1.2, crit=0.6, scrit=0.6, haste=0.6, shaste=0.6, sta=0.1, spen=0.1)
HEALER = dict(sp=1.0, heal=1.0, mp5=1.5, crit=0.4, scrit=0.4, haste=0.4, shaste=0.4, sta=0.05)
TANK = dict(sta=1.0, armor=0.06, **{"def": 1.2}, dodge=1.0, parry=0.9, block=0.5, bv=0.3, hit=0.3, mhit=0.3, exp=0.4)


def w(base, **extra):
    d = dict(base)
    d.update(extra)
    return d


# weapons: "dw" dual wield, "2h" two-hander only, "caster" one-hand + held/shield or a staff, "tank" one-hand + shield,
# "hunter" melee stat stick + ranged.  mh/oh = weapon subclasses allowed there (None = any the class can use).
# ranged: "ranged" bows/guns/crossbows/thrown, "wand", "relic".
PROFILES = {
    "ROGUE_SWORDS": dict(cls="ROGUE", name="Swords & maces", role="Melee damage", weapons="dw",
                         mh={4, 7, 13}, oh={4, 7, 13, 15}, ranged="ranged",
                         w=w(MELEE, agi=1.6, str=1.0, dps=9, odps=4, rdps=0.5)),
    "ROGUE_DAGGERS": dict(cls="ROGUE", name="Daggers", role="Melee damage", weapons="dw",
                          mh={15}, oh={15, 4, 7, 13}, ranged="ranged",
                          w=w(MELEE, agi=1.6, str=1.0, dps=9, odps=4, rdps=0.5)),
    "WARRIOR_ARMS": dict(cls="WARRIOR", name="Arms", role="Melee damage", weapons="2h", ranged="ranged",
                         w=w(MELEE, str=2.0, agi=1.0, dps=12, rdps=0.3)),
    "WARRIOR_FURY": dict(cls="WARRIOR", name="Fury", role="Melee damage", weapons="dw", ranged="ranged",
                         w=w(MELEE, str=2.0, agi=1.0, dps=10, odps=5, rdps=0.3)),
    "WARRIOR_PROT": dict(cls="WARRIOR", name="Protection", role="Tank", weapons="tank", ranged="ranged",
                         w=w(TANK, str=0.4, agi=0.6, ap=0.1, dps=2, rdps=0.1)),
    "PALADIN_HOLY": dict(cls="PALADIN", name="Holy", role="Healer", weapons="caster", ranged="relic",
                         w=w(HEALER, int=0.9, spi=0.15)),
    "PALADIN_PROT": dict(cls="PALADIN", name="Protection", role="Tank", weapons="tank", ranged="relic",
                         w=w(TANK, sp=0.4, dmg=0.4, str=0.3, agi=0.4, int=0.1, dps=2)),
    "PALADIN_RET": dict(cls="PALADIN", name="Retribution", role="Melee damage", weapons="2h", ranged="relic",
                        w=w(MELEE, str=2.0, agi=1.0, int=0.2, sp=0.2, dps=12)),
    "HUNTER": dict(cls="HUNTER", name="Hunter", role="Ranged damage", weapons="hunter", ranged="ranged",
                   w=dict(agi=1.6, rap=1.0, wskill=0.2, ap=0.3, hit=1.4, mhit=1.4, crit=0.9, mcrit=0.9, haste=0.6, mhaste=0.6,
                          arp=0.3, int=0.3, sta=0.1, mp5=0.5, rdps=12, dps=0.3, odps=0.2)),
    "PRIEST_HEAL": dict(cls="PRIEST", name="Holy & Discipline", role="Healer", weapons="caster", ranged="wand",
                        w=w(HEALER, spi=0.6, int=0.5)),
    "PRIEST_SHADOW": dict(cls="PRIEST", name="Shadow", role="Spell damage", weapons="caster", ranged="wand",
                          w=w(CASTER, int=0.3, spi=0.15, mp5=0.3, sta=0.15, shadow=1.0)),
    "SHAMAN_ELE": dict(cls="SHAMAN", name="Elemental", role="Spell damage", weapons="caster", ranged="relic",
                       w=w(CASTER, int=0.4, mp5=0.6, crit=0.8, scrit=0.8, nature=1.0, fire=0.3, frost=0.3)),
    "SHAMAN_ENH": dict(cls="SHAMAN", name="Enhancement", role="Melee damage", weapons="2h", ranged="relic",
                       w=w(MELEE, str=2.0, agi=1.3, int=0.2, dps=12)),
    "SHAMAN_RESTO": dict(cls="SHAMAN", name="Restoration", role="Healer", weapons="caster", ranged="relic",
                         w=w(HEALER, int=0.7, spi=0.2, mp5=1.6)),
    "MAGE": dict(cls="MAGE", name="Mage", role="Spell damage", weapons="caster", ranged="wand",
                 w=w(CASTER, int=0.4, spi=0.1, crit=0.8, scrit=0.8, fire=0.5, frost=0.5, arcane=0.3)),
    "WARLOCK": dict(cls="WARLOCK", name="Warlock", role="Spell damage", weapons="caster", ranged="wand",
                    w=w(CASTER, int=0.3, sta=0.3, crit=0.4, scrit=0.4, spi=0.05, shadow=1.0, fire=0.3)),
    "DRUID_BALANCE": dict(cls="DRUID", name="Balance", role="Spell damage", weapons="caster", ranged="relic",
                          w=w(CASTER, int=0.4, spi=0.1, mp5=0.4, nature=0.6, arcane=0.6)),
    "DRUID_CAT": dict(cls="DRUID", name="Feral (cat)", role="Melee damage", weapons="caster", ranged="relic",
                      w=w(MELEE, str=2.0, agi=1.6, fap=1.0)),
    "DRUID_BEAR": dict(cls="DRUID", name="Feral (bear)", role="Tank", weapons="caster", ranged="relic",
                       w=w(TANK, agi=1.0, str=0.5, ap=0.2, fap=0.2, armor=0.12)),
    "DRUID_RESTO": dict(cls="DRUID", name="Restoration", role="Healer", weapons="caster", ranged="relic",
                        w=w(HEALER, spi=0.7, int=0.5)),
}

# Talent tree (1, 2, 3) -> profile. Combat rogues use swords and maces; Assassination and Subtlety, daggers.
BY_TREE = {
    "WARRIOR": ["WARRIOR_ARMS", "WARRIOR_FURY", "WARRIOR_PROT"],
    "PALADIN": ["PALADIN_HOLY", "PALADIN_PROT", "PALADIN_RET"],
    "HUNTER": ["HUNTER", "HUNTER", "HUNTER"],
    "ROGUE": ["ROGUE_DAGGERS", "ROGUE_SWORDS", "ROGUE_DAGGERS"],
    "PRIEST": ["PRIEST_HEAL", "PRIEST_HEAL", "PRIEST_SHADOW"],
    "SHAMAN": ["SHAMAN_ELE", "SHAMAN_ENH", "SHAMAN_RESTO"],
    "MAGE": ["MAGE", "MAGE", "MAGE"],
    "WARLOCK": ["WARLOCK", "WARLOCK", "WARLOCK"],
    "DRUID": ["DRUID_BALANCE", "DRUID_CAT", "DRUID_RESTO"],
}

CLASS_BIT = {"WARRIOR": 1, "PALADIN": 2, "HUNTER": 4, "ROGUE": 8, "PRIEST": 16, "DEATHKNIGHT": 32, "SHAMAN": 64,
             "MAGE": 128, "WARLOCK": 256, "DRUID": 1024}
WEAPON_SKILL = {
    "WARRIOR": {0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 13, 15, 16, 18}, "PALADIN": {0, 1, 4, 5, 6, 7, 8},
    "HUNTER": {0, 1, 2, 3, 6, 7, 8, 10, 13, 15, 16, 18}, "ROGUE": {2, 3, 4, 7, 13, 15, 16, 18},
    "PRIEST": {4, 10, 15, 19}, "SHAMAN": {0, 1, 4, 5, 10, 13, 15}, "MAGE": {7, 10, 15, 19},
    "WARLOCK": {7, 10, 15, 19}, "DRUID": {4, 5, 6, 10, 13, 15},
}
ARMOR_SKILL = {
    "WARRIOR": {0, 1, 2, 3, 4, 6}, "PALADIN": {0, 1, 2, 3, 4, 6, 7}, "HUNTER": {0, 1, 2, 3},
    "ROGUE": {0, 1, 2}, "PRIEST": {0, 1}, "SHAMAN": {0, 1, 2, 3, 6, 9}, "MAGE": {0, 1},
    "WARLOCK": {0, 1}, "DRUID": {0, 1, 2, 8},
}
