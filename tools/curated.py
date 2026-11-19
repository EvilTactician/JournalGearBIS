"""Hand-picked Classic BiS and key upgrades, by item name (resolved against the realm's item_template).

Each entry: "Item name" or ("Item name", value) (an item id in place of the name picks one of several items sharing
a name) where value is the item's worth in the profile's score units
(attack power for melee, spell power for casters and healers) for items whose strength is a proc or use effect
the stat weights can't see. Where an item drops or is earned is looked up from the realm; crafted items carry
a 'craft' note since the world DB doesn't list recipes."""

ROGUE_COMMON = [
    # head
    "Mask of the Unforgiven", "Eye of Rend", "Nightslayer Cover", "Bloodfang Hood", "Deathdealer's Helm", "Bonescythe Helmet",
    # neck
    "Mark of Fordring", "Onyxia Tooth Pendant", "Prestor's Talisman of Connivery", "Barbed Choker",
    "Stormrage's Talisman of Seething",
    # shoulders
    "Truestrike Shoulders", "Nightslayer Shoulder Pads", "Bloodfang Spaulders", "Deathdealer's Spaulders", "Bonescythe Pauldrons",
    # back
    "Cape of the Black Baron", "Cloak of Firemaw", "Cloak of the Fallen God", "Cloak of the Shrouded Mists", "Shroud of Dominion",
    # chest
    "Cadaverous Armor", "Nightslayer Chestpiece", "Bloodfang Chestpiece", "Deathdealer's Vest", "Bonescythe Breastplate",
    # wrist (Nightslayer Bracelets have no source on the realm: a rare Molten Core trash drop)
    "Shadowcraft Bracers", "Wristguards of Stability", "Bloodfang Bracers", "Bonescythe Bracers",
    # hands
    "Devilsaur Gauntlets", "Nightslayer Gloves", "Bloodfang Gloves", "Gloves of Enforcement", "Bonescythe Gauntlets",
    # waist
    "Cloudrunner Girdle", "Nightslayer Belt", "Bloodfang Belt", "Bonescythe Waistguard",
    # legs
    "Devilsaur Leggings", "Nightslayer Pants", "Bloodfang Pants", "Deathdealer's Leggings", "Bonescythe Legplates",
    # feet
    "Swiftwalker Boots", "Nightslayer Boots", "Bloodfang Boots", "Deathdealer's Boots", "Bonescythe Sabatons",
    # rings
    "Blackstone Ring", "Painweaver Band", "Quick Strike Ring", "Band of Accuria", "Master Dragonslayer's Ring",
    "Circle of Applied Force",
    # trinkets
    ("Hand of Justice", 45), "Blackhand's Breadth", "Drake Fang Talisman", ("Kiss of the Spider", 75),
    (23206, 60),  # Mark of the Champion, the melee one (attack power against undead and demons)
    # ranged
    "Satyr's Bow", "Blackcrow", "Striker's Mark", "Dragonbreath Hand Cannon", "Nerubian Slavemaker",
]

WARLOCK_COMMON = [
    # pre-raid
    "Crimson Felt Hat", "Spellweaver's Turban", "Diana's Pearl Necklace", "Felcloth Shoulders", "Burial Shawl",
    "Spritecaster Cape", "Amplifying Cloak", "Robe of the Void", "Robe of Winter Night", "Shadowy Bracers",
    "Sublime Wristguards", "Hands of Power", "Felcloth Gloves", "Ban'thok Sash", "Thuzadin Sash",
    "Skyshroud Leggings", "Maleki's Footwraps", "Omnicast Boots", "Eye of Orgrimmar", "Songstone of Ironforge",
    "Cyclopean Band", ("Briarwood Reed", 25), "Eye of the Beast", "Witchblade", "Spirit of Aquementas",
    "Skul's Ghastly Touch", "Bonecreeper Stylus",
    # raids
    "Mish'undare, Circlet of the Mind Flayer", "Felheart Horns", "Nemesis Skullcap", "Plagueheart Circlet",
    "Choker of the Fire Lord", "Gem of Trapped Innocents", "Mantle of the Blackwing Cabal", "Nemesis Spaulders",
    "Plagueheart Shoulderpads", "Sapphiron Drape", "Cloak of the Necropolis", "Nemesis Robes", "Plagueheart Robe",
    "Rockfury Bracers", "Plagueheart Bindings", "Dark Storm Gauntlets", "Plagueheart Gloves", "Eyestalk Waist Cord",
    "Plagueheart Belt", "Leggings of Polarity", "Plagueheart Leggings", "Boots of Epiphany", "Plagueheart Sandals",
    "Ring of Spell Power", "Band of the Inevitable", "Ring of the Fallen God", "Plagueheart Ring",
    ("Talisman of Ephemeral Power", 30), "Neltharion's Tear", ("Zandalarian Hero Charm", 35),
    "The Restrained Essence of Sapphiron", (23207, 40),  # Mark of the Champion, the caster one
    "Staff of Dominance", "Wraith Blade", "Sapphiron's Left Eye", "Doomfinger",
    (22630, None),  # Atiesh, Greatstaff of the Guardian: the warlock one of the four sharing the name
]

CURATED = {
    "WARLOCK_SHADOW": WARLOCK_COMMON,
    "WARLOCK_FIRE": WARLOCK_COMMON,
    "ROGUE_SWORDS": ROGUE_COMMON + [
        "Dal'Rend's Sacred Charge", "Dal'Rend's Tribal Guardian", "Brutality Blade", "Vis'kag the Bloodletter",
        "Chromatically Tempered Sword", "Maladath, Runed Blade of the Black Flight", "The Hungering Cold",
    ],
    "ROGUE_DAGGERS": ROGUE_COMMON + [
        "Felstriker", "Perdition's Blade", "Core Hound Tooth", "Distracting Dagger", "Death's Sting",
        "Aged Core Leather Gloves",
    ],
    "PRIEST_HEAL": [
        # head
        "Devout Crown", "Circlet of Prophecy", "Halo of Transcendence", "Tiara of the Oracle", "Circlet of Faith",
        # neck
        "Animated Chain Necklace", "Choker of Enlightenment", "Necklace of Necropsy",
        # shoulders
        "Burial Shawl", "Devout Mantle", "Mantle of Prophecy", "Pauldrons of Transcendence", "Shoulderpads of Faith",
        # back
        "Hide of the Wild",
        # chest
        "Truefaith Vestments", "Robes of Prophecy", "Robes of Transcendence", "Robe of Faith",
        # wrist
        "Vambraces of Prophecy", "Bindings of Transcendence", "Bindings of Faith",
        # hands
        "Gloves of Prophecy", "Handguards of Transcendence", "Gloves of Faith",
        # waist
        "Whipvine Cord", "Girdle of Prophecy", "Belt of Transcendence", "Belt of Faith",
        # legs
        "Senior Designer's Pantaloons", "Pants of Prophecy", "Leggings of Transcendence", "Leggings of Faith",
        # feet
        "Boots of the Full Moon", "Boots of Prophecy", "Boots of Transcendence", "Sandals of Faith",
        # rings
        "Fordring's Seal", "Band of Rumination", "Cauterizing Band", "Pure Elementium Band",
        # trinkets
        ("Second Wind", 20), "Mindtap Talisman", ("Draconic Infused Emblem", 20), "Rejuvenating Gem",
        ("Royal Seal of Eldre'Thalas", 15),
        # weapons
        "The Hammer of Grace", "Thaurissan's Royal Scepter", "Stormrager", "Aurastone Hammer", "Lok'amir il Romathis",
        "Hammer of the Twisting Nether",
    ],
    "PRIEST_SHADOW": [
        # pre-raid
        "Crimson Felt Hat", "Dark Advisor's Pendant", "Felcloth Shoulders", "Robe of Winter Night", "Hands of Power",
        "Felcloth Gloves", "Skyshroud Leggings", "Maleki's Footwraps", "Songstone of Ironforge", "Eye of Orgrimmar",
        ("Briarwood Reed", 25), "Eye of the Beast", "Scepter of the Unholy", "Spirit of Aquementas", "Skul's Ghastly Touch",
        # raids
        "Mish'undare, Circlet of the Mind Flayer", "Mantle of the Blackwing Cabal", "Robe of the Void", "Ring of Spell Power",
        ("Talisman of Ephemeral Power", 30), "Neltharion's Tear", "Staff of Dominance",
        (23207, 40),  # Mark of the Champion, the caster one (spell power against undead and demons)
    ],
    "DRUID_CAT": [
        # pre-raid
        ("Wolfshead Helm", 40), "Mark of Fordring", "Truestrike Shoulders", "Cape of the Black Baron", "Cadaverous Armor",
        "Blackmist Armguards", "Devilsaur Gauntlets", "Cloudrunner Girdle", "Devilsaur Leggings", "Swiftwalker Boots",
        "Blackstone Ring", "Magma Forged Band", "Blackhand's Breadth", ("Hand of Justice", 45), ("Idol of Ferocity", 20),
        ("Manual Crowd Pummeler", 60),
        # raids
        "Onyxia Tooth Pendant", "Prestor's Talisman of Connivery", "Barbed Choker", "Cloak of Firemaw",
        "Cloak of the Shrouded Mists", "Wristguards of Stability", "Gloves of Enforcement", "Quick Strike Ring",
        "Band of Accuria", "Master Dragonslayer's Ring", "Circle of Applied Force", "Drake Fang Talisman",
        ("Kiss of the Spider", 75), (23206, 60),
    ],
    "DRUID_BEAR": [
        # pre-raid
        "Mask of the Unforgiven", "Mark of Fordring", "Truestrike Shoulders", "Phantasmal Cloak", "Breastplate of Bloodthirst",
        "Blackmist Armguards", "Devilsaur Gauntlets", "Cloudrunner Girdle", "Devilsaur Leggings", "Pads of the Dread Wolf",
        "Thrall's Resolve", "Blackstone Ring", "Blackhand's Breadth", "Mark of the Chosen",
        ("Idol of Brutality", 15),
        # raids
        "Onyxia Tooth Pendant", "Wristguards of Stability", "Gloves of Enforcement", "Band of Accuria",
        "Master Dragonslayer's Ring", "Drake Fang Talisman",
    ],
    "DRUID_BALANCE": [
        # pre-raid
        "Crimson Felt Hat", "Diana's Pearl Necklace", "Burial Shawl", "Spritecaster Cape", "Robes of the Royal Crown",
        "Manacle Cuffs", "Hands of Power", "Ban'thok Sash", "Skyshroud Leggings", "Omnicast Boots", "Eye of Orgrimmar",
        "Songstone of Ironforge", "Cyclopean Band", "Eye of the Beast", ("Briarwood Reed", 25), "Witchblade",
        "Spirit of Aquementas",
        # raids
        "Ring of Spell Power", ("Talisman of Ephemeral Power", 30), "Staff of Dominance", "Neltharion's Tear",
        "Gem of Trapped Innocents", "Rime Covered Mantle", "Cloak of the Necropolis", "Band of the Inevitable",
        "The Restrained Essence of Sapphiron", "Brimstone Staff", ("Idol of the Moon", 15),
        (23207, 40),  # Mark of the Champion, the caster one
    ],
    "DRUID_RESTO": [
        # pre-raid
        "Tribal War Feathers", "Animated Chain Necklace", "Living Shoulders", "Spritecaster Cape", "Robes of the Exalted",
        "Bleak Howler Armguards", "Hands of the Exalted Herald", "Thuzadin Sash", "Senior Designer's Pantaloons",
        "Verdant Footpads", "Rosewine Circle", "Fordring's Seal", ("Second Wind", 20), ("Briarwood Reed", 20),
        "The Hammer of Grace", "Thaurissan's Royal Scepter",
        # raids
        "Hide of the Wild", "Cauterizing Band", "Pure Elementium Band", "Rejuvenating Gem", "Aurastone Hammer",
        "Hammer of the Twisting Nether", "Amulet of the Fallen God", ("Idol of Rejuvenation", 20),
    ],
}

# Not in the world DB's loot or quest tables.
CRAFTED = {
    "Devilsaur Gauntlets": "Crafted: Leatherworking (Devilsaur Leather)",
    "Devilsaur Leggings": "Crafted: Leatherworking (Devilsaur Leather)",
    "Truefaith Vestments": "Crafted: Tailoring",
    "Hide of the Wild": "Crafted: Leatherworking",
    "Robe of the Void": "Crafted: Tailoring",
    "Felcloth Shoulders": "Crafted: Tailoring",
    "Felcloth Gloves": "Crafted: Tailoring",
    "Robe of Winter Night": "Crafted: Tailoring",
    "Wolfshead Helm": "Crafted: Leatherworking",
    "Living Shoulders": "Crafted: Leatherworking",
}

# Glyphs, best first, by spec profile. "Glyph name" or ("Glyph name", "Talent it needs"). The tab shows the best
# three of each kind you can use (your level, your stage's Inscription, your talents); one that needs a talent you
# don't have gives way to the next, with a note under it.
ROGUE_MINOR = ["Glyph of Vanish", "Glyph of Safe Fall", "Glyph of Distract", "Glyph of Blurred Speed", "Glyph of Pick Pocket"]
PRIEST_MINOR = ["Glyph of Fortitude", "Glyph of Fading", "Glyph of Levitate", "Glyph of Shadow Protection"]
WARLOCK_MINOR = ["Glyph of Drain Soul", "Glyph of Souls", "Glyph of Unending Breath", "Glyph of Enslave Demon"]
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
    # Affliction: Life Tap, Haunt, Quick Decay; Demonology: Life Tap, Quick Decay, Felguard (Metamorphosis when the
    # Felguard can't fight). Each tree's talent glyph stays out of the other's list.
    "WARLOCK_SHADOW": {
        "major": ["Glyph of Life Tap", ("Glyph of Haunt", "Haunt"), "Glyph of Quick Decay",
                  ("Glyph of Felguard", "Summon Felguard"), ("Glyph of Metamorphosis", "Metamorphosis"),
                  "Glyph of Corruption", "Glyph of Shadow Bolt"],
        "minor": WARLOCK_MINOR,
    },
    "WARLOCK_FIRE": {
        "major": [("Glyph of Conflagrate", "Conflagrate"), "Glyph of Incinerate", "Glyph of Life Tap",
                  "Glyph of Immolate"],
        "minor": WARLOCK_MINOR,
    },
    "DRUID_BALANCE": {
        "major": ["Glyph of Starfire", "Glyph of Moonfire", ("Glyph of Insect Swarm", "Insect Swarm"),
                  ("Glyph of Starfall", "Starfall"), ("Glyph of Focus", "Starfall"), "Glyph of Wrath", "Glyph of Rebirth"],
        "minor": [("Glyph of Typhoon", "Typhoon"), "Glyph of Unburdened Rebirth", "Glyph of the Wild", "Glyph of Thorns",
                  "Glyph of Dash"],
    },
    "DRUID_CAT": {
        "major": ["Glyph of Shred", "Glyph of Rip", ("Glyph of Mangle", "Mangle"), "Glyph of Rake", "Glyph of Claw",
                  "Glyph of Rebirth"],
        "minor": ["Glyph of Dash", "Glyph of Unburdened Rebirth", "Glyph of the Wild", "Glyph of Aquatic Form",
                  "Glyph of Thorns"],
    },
    "DRUID_BEAR": {
        "major": ["Glyph of Maul", ("Glyph of Mangle", "Mangle"), "Glyph of Growl", "Glyph of Frenzied Regeneration",
                  "Glyph of Rebirth"],
        "minor": ["Glyph of Challenging Roar", "Glyph of Unburdened Rebirth", "Glyph of the Wild", "Glyph of Thorns",
                  "Glyph of Dash"],
    },
    "DRUID_RESTO": {
        "major": [("Glyph of Swiftmend", "Swiftmend"), "Glyph of Regrowth", "Glyph of Rejuvenation", "Glyph of Lifebloom",
                  "Glyph of Rapid Rejuvenation", "Glyph of Innervate", "Glyph of Healing Touch", "Glyph of Rebirth"],
        "minor": ["Glyph of Unburdened Rebirth", "Glyph of the Wild", "Glyph of Thorns", "Glyph of Dash",
                  "Glyph of Aquatic Form"],
    },
}

# Bosses with something to know before you go: a short tag for the item's source line and a sentence for its
# tooltip. The Ring of Law is found from the data; these are the ones that need summoning or take turns.
BOSS_NOTES = {
    "Lord Valthalak": ("summoned", "Summoned with a Brazier of Beckoning, from Bodley's quest chain in Blackrock "
                                   "Mountain (the dungeon set upgrade quests)."),
    "Mor Grayhoof": ("summoned", "Summoned with a Brazier of Beckoning, from Bodley's quest chain in Blackrock "
                                 "Mountain (the dungeon set upgrade quests)."),
    "Isalien": ("summoned", "Summoned with a Brazier of Beckoning, from Bodley's quest chain in Blackrock "
                            "Mountain (the dungeon set upgrade quests)."),
    "Kormok": ("summoned", "Summoned with a Brazier of Beckoning, from Bodley's quest chain in Blackrock "
                           "Mountain (the dungeon set upgrade quests)."),
    "Sothos": ("summoned", "Summoned with a Brazier of Beckoning, from Bodley's quest chain in Blackrock "
                           "Mountain (the dungeon set upgrade quests)."),
    "Jarien": ("summoned", "Summoned with a Brazier of Beckoning, from Bodley's quest chain in Blackrock "
                           "Mountain (the dungeon set upgrade quests)."),
    "Postmaster Malown": ("summoned", "Appears once you've opened Stratholme's three postboxes with the Key to the "
                                      "City."),
    "Gri'lek": ("one of four", "One of the four bosses that take turns at Zul'Gurub's Edge of Madness: which one "
                               "is there changes from time to time."),
    "Renataki": ("one of four", "One of the four bosses that take turns at Zul'Gurub's Edge of Madness: which "
                                "one is there changes from time to time."),
    "Wushoolay": ("one of four", "One of the four bosses that take turns at Zul'Gurub's Edge of Madness: which "
                                 "one is there changes from time to time."),
    "Hazza'rah": ("one of four", "One of the four bosses that take turns at Zul'Gurub's Edge of Madness: which "
                                 "one is there changes from time to time."),
    "Urok Doomhowl": ("summoned", "Summoned through the quest Urok Doomhowl in Lower Blackrock Spire, which starts "
                                  "from Warosh's Scroll."),
    "Avatar of Hakkar": ("summoned", "Summoned with the Egg of Hakkar, from the quest chain The God Hakkar, in the "
                                     "Sunken Temple."),
    "Gahz'rilla": ("summoned", "Summoned by striking the gong in Zul'Farrak with the Mallet of Zul'Farrak, made "
                              "through a quest chain."),
    "Gahz'ranka": ("summoned", "Summoned by fishing in Zul'Gurub's Muddy Churning Waters with a Mudskunk Lure."),
}

# Summoned bosses that simply turn up as you play through the instance: no note needed.
EVENT_BOSSES = {
    # dungeons: they appear as part of the run
    "Balnazzar", "Ramstein the Gorger", "Gizrul the Slavener", "Solakar Flamewreath", "Gyth", "Nekrum Gutchewer",
    "Shadowpriest Sezz'ziz",
    # raids: the encounter brings them (Bug Trio, Ragnaros, Nefarian, Ouro, Arlokk, Naxxramas)
    "Lord Kri", "Vem", "Princess Yauj", "Ragnaros", "Nefarian", "Ouro", "High Priestess Arlokk",
    "Anub'Rekhan", "Grand Widow Faerlina", "Maexxna", "Noth the Plaguebringer", "Heigan the Unclean", "Loatheb",
    "Instructor Razuvious", "Gothik the Harvester", "Patchwerk", "Grobbulus", "Gluth", "Thaddius", "Sapphiron",
    "Kel'Thuzad", "Bile Retcher", "Carrion Spinner", "Crypt Reaver", "Dread Creeper", "Living Monstrosity",
    "Mad Scientist", "Naxxramas Acolyte", "Naxxramas Cultist", "Patchwork Golem", "Stitched Spewer",
    "Surgical Assistant", "Tomb Horror", "Venom Stalker",
}

# A line under a hand-picked item's tooltip, for the ones worth a word: optional extras and odd ways to get them.
CURATED_NOTES = {
    "Rockfury Bracers": "The end of a long Cenarion Circle quest chain in Silithus, opened by Ahn'Qiraj: you need "
                        "Revered with the Cenarion Circle for it.",
    "Breastplate of Bloodthirst": "Skinning The Beast needs 310: 300 plus Finkle's Skinner (+10), a dagger The Beast "
                                  "itself drops. The hide comes about 1 skin in 50.",
    "Manual Crowd Pummeler": "Optional: 3 uses of its haste, then it's just a weapon. Only for squeezing out every bit "
                             "of damage; you'd need several.",
}

# Recommended consumables, by spec profile: "Item name" or ("Item name", "a note for its tooltip").
# Only what a player should actually use: no item that a better one on the same list makes pointless (two
# battle elixirs that don't stack, say). Flasks and elixirs are shown first, grouped; list them best first, as
# a later one that doesn't stack with an earlier one is its cheaper stand-in.
ROGUE_CONSUMABLES = ["Elixir of the Mongoose", ("Winterfall Firewater", "Drops from Winterfall furbolgs in Winterspring."),
                     "Grilled Squid", "Thistle Tea", "Major Healing Potion"]
WARLOCK_CONSUMABLES = [("Brilliant Wizard Oil", "Put it on your weapon."), "Runn Tum Tuber Surprise", "Major Mana Potion"]
CONSUMABLES = {
    "ROGUE_SWORDS": [("Instant Poison VI", "Put it on your main hand."), ("Deadly Poison V", "Put it on your off hand, the faster weapon.")]
    + ROGUE_CONSUMABLES,
    "ROGUE_DAGGERS": [("Instant Poison VI", "Put it on your main hand."), ("Deadly Poison V", "Put it on your off hand, the faster dagger.")]
    + ROGUE_CONSUMABLES,
    "PRIEST_HEAL": ["Flask of Distilled Wisdom", ("Brilliant Mana Oil", "Put it on your weapon."), "Mageblood Elixir",
                    "Nightfin Soup", "Major Mana Potion", ("Demonic Rune", "Costs some health.")],
    "PRIEST_SHADOW": ["Flask of Supreme Power", "Elixir of Shadow Power",
                      ("Brilliant Wizard Oil", "Put it on your weapon."), "Runn Tum Tuber Surprise", "Major Mana Potion",
                      ("Demonic Rune", "Costs some health.")],
    # no Demonic Rune: Life Tap gives warlocks mana for health already
    "WARLOCK_SHADOW": ["Flask of Supreme Power", "Elixir of Shadow Power"] + WARLOCK_CONSUMABLES,
    "WARLOCK_FIRE": ["Flask of Supreme Power", "Elixir of Greater Firepower"] + WARLOCK_CONSUMABLES,
    "DRUID_BALANCE": ["Flask of Supreme Power", "Greater Arcane Elixir", ("Brilliant Wizard Oil", "Put it on your weapon."),
                      "Runn Tum Tuber Surprise", "Major Mana Potion", ("Demonic Rune", "Costs some health.")],
    "DRUID_CAT": ["Elixir of the Mongoose", ("Winterfall Firewater", "Drops from Winterfall furbolgs in Winterspring."),
                  "Grilled Squid", "Major Healing Potion"],
    "DRUID_BEAR": ["Flask of the Titans", "Elixir of the Mongoose", "Elixir of Superior Defense",
                   "Dirge's Kickin' Chimaerok Chops", "Major Healing Potion"],
    "DRUID_RESTO": ["Flask of Distilled Wisdom", "Mageblood Elixir", ("Brilliant Mana Oil", "Put it on your weapon."),
                    "Nightfin Soup", "Major Mana Potion", ("Demonic Rune", "Costs some health.")],
}

# Enchants whose worth is a proc the stat weights can't see: name -> value in the profile's units, by profile.
ENCHANT_PROCS = {
    "Crusader": {"ROGUE_SWORDS": 35, "ROGUE_DAGGERS": 35, "DRUID_CAT": 50, "DRUID_BEAR": 25},
    "Fiery Weapon": {"ROGUE_SWORDS": 12, "ROGUE_DAGGERS": 12},
}

# Consumables only a profession can use, by profession: shown as the profession's icon at the end of the
# consumables row, with these in its tooltip, only when you have the profession. ("Item name", "what it's for")
PROFESSION_CONSUMABLES = {
    "Engineering": [("Goblin Sapper Charge", "A big burst of fire damage around you; it hurts you too."),
                    ("Dense Dynamite", "Thrown fire damage in an area."),
                    ("Thorium Grenade", "Thrown damage in an area that stuns for 3 seconds.")],
}
