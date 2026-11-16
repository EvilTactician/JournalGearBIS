"""Hand-picked Classic BiS and key upgrades, by item name (resolved against the realm's item_template).

Each entry: "Item name" or ("Item name", value) where value is the item's worth in the profile's score units
(attack power for melee, spell power for casters and healers) for items whose strength is a proc or use effect
the stat weights can't see. Where an item drops or is earned is looked up from the realm; crafted items carry
a 'craft' note since the world DB doesn't list recipes."""

ROGUE_COMMON = [
    # head
    "Mask of the Unforgiven", "Eye of Rend", "Nightslayer Cover", "Bloodfang Hood", "Deathdealer's Helm", "Bonescythe Helmet",
    # neck
    "Mark of Fordring", "Onyxia Tooth Pendant", "Prestor's Talisman of Connivery", "Barbed Choker",
    # shoulders
    "Truestrike Shoulders", "Nightslayer Shoulder Pads", "Bloodfang Spaulders", "Deathdealer's Spaulders", "Bonescythe Pauldrons",
    # back
    "Cape of the Black Baron", "Cloak of Firemaw", "Cloak of the Fallen God", "Cloak of the Shrouded Mists",
    # chest
    "Cadaverous Armor", "Nightslayer Chestpiece", "Bloodfang Chestpiece", "Deathdealer's Vest", "Bonescythe Breastplate",
    # wrist
    "Nightslayer Bracelets", "Bloodfang Bracers", "Bonescythe Bracers",
    # hands
    "Devilsaur Gauntlets", "Nightslayer Gloves", "Bloodfang Gloves", "Bonescythe Gauntlets",
    # waist
    "Nightslayer Belt", "Bloodfang Belt", "Bonescythe Waistguard",
    # legs
    "Devilsaur Leggings", "Nightslayer Pants", "Bloodfang Pants", "Deathdealer's Leggings", "Bonescythe Legplates",
    # feet
    "Nightslayer Boots", "Bloodfang Boots", "Deathdealer's Boots", "Bonescythe Sabatons",
    # rings
    "Blackstone Ring", "Painweaver Band", "Quick Strike Ring", "Master Dragonslayer's Ring",
    "Circle of Applied Force",
    # trinkets
    ("Hand of Justice", 45), "Blackhand's Breadth", "Drake Fang Talisman", ("Kiss of the Spider", 75),
    # ranged
    "Satyr's Bow", "Striker's Mark", "Dragonbreath Hand Cannon",
]

CURATED = {
    "ROGUE_SWORDS": ROGUE_COMMON + [
        "Dal'Rend's Sacred Charge", "Dal'Rend's Tribal Guardian", "Brutality Blade", "Vis'kag the Bloodletter",
        "Chromatically Tempered Sword", "Maladath, Runed Blade of the Black Flight",
    ],
    "ROGUE_DAGGERS": ROGUE_COMMON + [
        "Felstriker", "Perdition's Blade", "Core Hound Tooth", "Distracting Dagger",
    ],
    "PRIEST_HEAL": [
        # head
        "Devout Crown", "Circlet of Prophecy", "Halo of Transcendence", "Tiara of the Oracle", "Circlet of Faith",
        # neck
        "Animated Chain Necklace", "Choker of Enlightenment",
        # shoulders
        "Devout Mantle", "Mantle of Prophecy", "Pauldrons of Transcendence", "Shoulderpads of Faith",
        # back
        "Hide of the Wild",
        # chest
        "Truefaith Vestments", "Robes of Prophecy", "Robes of Transcendence", "Robe of Faith",
        # wrist
        "Vambraces of Prophecy", "Bindings of Transcendence", "Bindings of Faith",
        # hands
        "Gloves of Prophecy", "Handguards of Transcendence", "Gloves of Faith",
        # waist
        "Girdle of Prophecy", "Belt of Transcendence", "Belt of Faith",
        # legs
        "Pants of Prophecy", "Leggings of Transcendence", "Leggings of Faith",
        # feet
        "Boots of Prophecy", "Boots of Transcendence", "Sandals of Faith",
        # rings
        "Cauterizing Band", "Pure Elementium Band",
        # trinkets
        ("Second Wind", 20), "Rejuvenating Gem", ("Royal Seal of Eldre'Thalas", 15),
        # weapons
        "Aurastone Hammer", "Lok'amir il Romathis",
    ],
    "PRIEST_SHADOW": [
        "Mantle of the Blackwing Cabal", "Ring of Spell Power", ("Talisman of Ephemeral Power", 30),
        ("Briarwood Reed", 25), "Neltharion's Tear", "Staff of Dominance", "Robe of the Void",
    ],
}

# Not in the world DB's loot or quest tables.
CRAFTED = {
    "Devilsaur Gauntlets": "Crafted: Leatherworking (Devilsaur Leather)",
    "Devilsaur Leggings": "Crafted: Leatherworking (Devilsaur Leather)",
    "Truefaith Vestments": "Crafted: Tailoring",
    "Hide of the Wild": "Crafted: Leatherworking",
    "Robe of the Void": "Crafted: Tailoring",
}

# Glyphs, best first, by spec profile. "Glyph name" or ("Glyph name", "Talent it needs"). The tab shows the best
# three of each kind you can use (your level, your stage's Inscription, your talents); one that needs a talent you
# don't have gives way to the next, with a note under it.
ROGUE_MINOR = ["Glyph of Vanish", "Glyph of Safe Fall", "Glyph of Distract", "Glyph of Blurred Speed", "Glyph of Pick Pocket"]
PRIEST_MINOR = ["Glyph of Fortitude", "Glyph of Fading", "Glyph of Levitate", "Glyph of Shadow Protection"]
GLYPHS = {
    "ROGUE_SWORDS": {
        "major": ["Glyph of Slice and Dice", "Glyph of Sinister Strike",
                  "Glyph of Eviscerate", "Glyph of Expose Armor", "Glyph of Evasion"],
        "minor": ROGUE_MINOR,
    },
    "ROGUE_DAGGERS": {
        "major": [("Glyph of Mutilate", "Mutilate"), "Glyph of Slice and Dice", "Glyph of Eviscerate", "Glyph of Backstab",
                  "Glyph of Garrote", "Glyph of Evasion"],
        "minor": ROGUE_MINOR,
    },
    "PRIEST_HEAL": {
        "major": ["Glyph of Prayer of Healing", "Glyph of Power Word: Shield", "Glyph of Flash Heal", "Glyph of Renew",
                  "Glyph of Fear Ward", "Glyph of Inner Fire"],
        "minor": PRIEST_MINOR,
    },
    "PRIEST_SHADOW": {
        "major": [("Glyph of Shadow", "Shadowform"), "Glyph of Mind Flay", "Glyph of Shadow Word: Pain", "Glyph of Fade",
                  "Glyph of Inner Fire"],
        "minor": ["Glyph of Fortitude", "Glyph of Shadow Protection", "Glyph of Fading", "Glyph of Levitate"],
    },
}

# Recommended consumables, by spec profile: "Item name" or ("Item name", "a note for its tooltip").
ROGUE_CONSUMABLES = ["Elixir of the Mongoose", ("Juju Power", "A repeatable quest: 3 for every 3 Winterfall E'ko, which Winterfall furbolgs drop. Doesn't stack with Elixir of Giants."),
                     ("Winterfall Firewater", "Drops from Winterfall furbolgs in Winterspring."),
                     "Grilled Squid", "Thistle Tea", "Major Healing Potion"]
CONSUMABLES = {
    "ROGUE_SWORDS": [("Instant Poison VI", "Put it on your main hand."), ("Deadly Poison V", "Put it on your off hand.")]
    + ROGUE_CONSUMABLES,
    "ROGUE_DAGGERS": [("Deadly Poison V", "Put it on your main hand."), ("Instant Poison VI", "Put it on your off hand.")]
    + ROGUE_CONSUMABLES,
    "PRIEST_HEAL": ["Flask of Distilled Wisdom", ("Brilliant Mana Oil", "Put it on your weapon."), "Mageblood Elixir",
                    "Nightfin Soup", "Major Mana Potion", ("Demonic Rune", "Costs some health.")],
    "PRIEST_SHADOW": ["Flask of Supreme Power", "Greater Arcane Elixir", "Elixir of Shadow Power",
                      ("Brilliant Wizard Oil", "Put it on your weapon."), "Runn Tum Tuber Surprise", "Major Mana Potion",
                      ("Demonic Rune", "Costs some health.")],
}

# Enchants whose worth is a proc the stat weights can't see: name -> value in the profile's units, by profile.
ENCHANT_PROCS = {
    "Crusader": {"ROGUE_SWORDS": 35, "ROGUE_DAGGERS": 35},
    "Fiery Weapon": {"ROGUE_SWORDS": 12, "ROGUE_DAGGERS": 12},
}
