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
