-- Hand-picked Classic best-in-slot items and key upgrades, by spec profile. These win their raid or dungeon
-- tier's step over the stat-weighted pick. { item, value } gives an item whose worth is a proc or use effect
-- (Hand of Justice, Kiss of the Spider) a value in the profile's units. Add specs or items freely:
-- the item must also be in Data.lua.

local G = JournalGearBIS

G.curated = {
	ROGUE_SWORDS = {
		{ 13404 }, -- Mask of the Unforgiven
		{ 12587 }, -- Eye of Rend
		{ 16821 }, -- Nightslayer Cover
		{ 16908 }, -- Bloodfang Hood
		{ 21360 }, -- Deathdealer's Helm
		{ 22478 }, -- Bonescythe Helmet
		{ 15411 }, -- Mark of Fordring
		{ 18404 }, -- Onyxia Tooth Pendant
		{ 19377 }, -- Prestor's Talisman of Connivery
		{ 21664 }, -- Barbed Choker
		{ 23053 }, -- Stormrage's Talisman of Seething
		{ 12927 }, -- Truestrike Shoulders
		{ 16823 }, -- Nightslayer Shoulder Pads
		{ 16832 }, -- Bloodfang Spaulders
		{ 21361 }, -- Deathdealer's Spaulders
		{ 22479 }, -- Bonescythe Pauldrons
		{ 13340 }, -- Cape of the Black Baron
		{ 19398 }, -- Cloak of Firemaw
		{ 21710 }, -- Cloak of the Fallen God
		{ 17102 }, -- Cloak of the Shrouded Mists
		{ 23045 }, -- Shroud of Dominion
		{ 14637 }, -- Cadaverous Armor
		{ 16820 }, -- Nightslayer Chestpiece
		{ 16905 }, -- Bloodfang Chestpiece
		{ 21364 }, -- Deathdealer's Vest
		{ 22476 }, -- Bonescythe Breastplate
		{ 16710 }, -- Shadowcraft Bracers
		{ 19146 }, -- Wristguards of Stability
		{ 16911 }, -- Bloodfang Bracers
		{ 22483 }, -- Bonescythe Bracers
		{ 15063 }, -- Devilsaur Gauntlets
		{ 16826 }, -- Nightslayer Gloves
		{ 16907 }, -- Bloodfang Gloves
		{ 21672 }, -- Gloves of Enforcement
		{ 22481 }, -- Bonescythe Gauntlets
		{ 13252 }, -- Cloudrunner Girdle
		{ 16827 }, -- Nightslayer Belt
		{ 16910 }, -- Bloodfang Belt
		{ 22482 }, -- Bonescythe Waistguard
		{ 15062 }, -- Devilsaur Leggings
		{ 16822 }, -- Nightslayer Pants
		{ 16909 }, -- Bloodfang Pants
		{ 21362 }, -- Deathdealer's Leggings
		{ 22477 }, -- Bonescythe Legplates
		{ 12553 }, -- Swiftwalker Boots
		{ 16824 }, -- Nightslayer Boots
		{ 16906 }, -- Bloodfang Boots
		{ 21359 }, -- Deathdealer's Boots
		{ 22480 }, -- Bonescythe Sabatons
		{ 17713 }, -- Blackstone Ring
		{ 13098 }, -- Painweaver Band
		{ 18821 }, -- Quick Strike Ring
		{ 17063 }, -- Band of Accuria
		{ 19384 }, -- Master Dragonslayer's Ring
		{ 19432 }, -- Circle of Applied Force
		{ 11815, 45 }, -- Hand of Justice
		{ 13965 }, -- Blackhand's Breadth
		{ 19406 }, -- Drake Fang Talisman
		{ 22954, 75 }, -- Kiss of the Spider
		{ 23206, 60 }, -- Mark of the Champion
		{ 18323 }, -- Satyr's Bow
		{ 12651 }, -- Blackcrow
		{ 17069 }, -- Striker's Mark
		{ 19368 }, -- Dragonbreath Hand Cannon
		{ 22812 }, -- Nerubian Slavemaker
		{ 12940 }, -- Dal'Rend's Sacred Charge
		{ 12939 }, -- Dal'Rend's Tribal Guardian
		{ 18832 }, -- Brutality Blade
		{ 17075 }, -- Vis'kag the Bloodletter
		{ 19352 }, -- Chromatically Tempered Sword
		{ 19351 }, -- Maladath, Runed Blade of the Black Flight
		{ 23577 }, -- The Hungering Cold
	},
	ROGUE_DAGGERS = {
		{ 13404 }, -- Mask of the Unforgiven
		{ 12587 }, -- Eye of Rend
		{ 16821 }, -- Nightslayer Cover
		{ 16908 }, -- Bloodfang Hood
		{ 21360 }, -- Deathdealer's Helm
		{ 22478 }, -- Bonescythe Helmet
		{ 15411 }, -- Mark of Fordring
		{ 18404 }, -- Onyxia Tooth Pendant
		{ 19377 }, -- Prestor's Talisman of Connivery
		{ 21664 }, -- Barbed Choker
		{ 23053 }, -- Stormrage's Talisman of Seething
		{ 12927 }, -- Truestrike Shoulders
		{ 16823 }, -- Nightslayer Shoulder Pads
		{ 16832 }, -- Bloodfang Spaulders
		{ 21361 }, -- Deathdealer's Spaulders
		{ 22479 }, -- Bonescythe Pauldrons
		{ 13340 }, -- Cape of the Black Baron
		{ 19398 }, -- Cloak of Firemaw
		{ 21710 }, -- Cloak of the Fallen God
		{ 17102 }, -- Cloak of the Shrouded Mists
		{ 23045 }, -- Shroud of Dominion
		{ 14637 }, -- Cadaverous Armor
		{ 16820 }, -- Nightslayer Chestpiece
		{ 16905 }, -- Bloodfang Chestpiece
		{ 21364 }, -- Deathdealer's Vest
		{ 22476 }, -- Bonescythe Breastplate
		{ 16710 }, -- Shadowcraft Bracers
		{ 19146 }, -- Wristguards of Stability
		{ 16911 }, -- Bloodfang Bracers
		{ 22483 }, -- Bonescythe Bracers
		{ 15063 }, -- Devilsaur Gauntlets
		{ 16826 }, -- Nightslayer Gloves
		{ 16907 }, -- Bloodfang Gloves
		{ 21672 }, -- Gloves of Enforcement
		{ 22481 }, -- Bonescythe Gauntlets
		{ 13252 }, -- Cloudrunner Girdle
		{ 16827 }, -- Nightslayer Belt
		{ 16910 }, -- Bloodfang Belt
		{ 22482 }, -- Bonescythe Waistguard
		{ 15062 }, -- Devilsaur Leggings
		{ 16822 }, -- Nightslayer Pants
		{ 16909 }, -- Bloodfang Pants
		{ 21362 }, -- Deathdealer's Leggings
		{ 22477 }, -- Bonescythe Legplates
		{ 12553 }, -- Swiftwalker Boots
		{ 16824 }, -- Nightslayer Boots
		{ 16906 }, -- Bloodfang Boots
		{ 21359 }, -- Deathdealer's Boots
		{ 22480 }, -- Bonescythe Sabatons
		{ 17713 }, -- Blackstone Ring
		{ 13098 }, -- Painweaver Band
		{ 18821 }, -- Quick Strike Ring
		{ 17063 }, -- Band of Accuria
		{ 19384 }, -- Master Dragonslayer's Ring
		{ 19432 }, -- Circle of Applied Force
		{ 11815, 45 }, -- Hand of Justice
		{ 13965 }, -- Blackhand's Breadth
		{ 19406 }, -- Drake Fang Talisman
		{ 22954, 75 }, -- Kiss of the Spider
		{ 23206, 60 }, -- Mark of the Champion
		{ 18323 }, -- Satyr's Bow
		{ 12651 }, -- Blackcrow
		{ 17069 }, -- Striker's Mark
		{ 19368 }, -- Dragonbreath Hand Cannon
		{ 22812 }, -- Nerubian Slavemaker
		{ 12590 }, -- Felstriker
		{ 18816 }, -- Perdition's Blade
		{ 18805 }, -- Core Hound Tooth
		{ 18392 }, -- Distracting Dagger
		{ 21126 }, -- Death's Sting
		{ 18823 }, -- Aged Core Leather Gloves
	},
	PRIEST_HEAL = {
		{ 16693 }, -- Devout Crown
		{ 16813 }, -- Circlet of Prophecy
		{ 16921 }, -- Halo of Transcendence
		{ 21348 }, -- Tiara of the Oracle
		{ 22514 }, -- Circlet of Faith
		{ 18723 }, -- Animated Chain Necklace
		{ 17109 }, -- Choker of Enlightenment
		{ 23036 }, -- Necklace of Necropsy
		{ 18681 }, -- Burial Shawl
		{ 16695 }, -- Devout Mantle
		{ 16816 }, -- Mantle of Prophecy
		{ 16924 }, -- Pauldrons of Transcendence
		{ 22515 }, -- Shoulderpads of Faith
		{ 18510 }, -- Hide of the Wild
		{ 14154 }, -- Truefaith Vestments
		{ 16815 }, -- Robes of Prophecy
		{ 16923 }, -- Robes of Transcendence
		{ 22512 }, -- Robe of Faith
		{ 16819 }, -- Vambraces of Prophecy
		{ 16926 }, -- Bindings of Transcendence
		{ 22519 }, -- Bindings of Faith
		{ 16812 }, -- Gloves of Prophecy
		{ 16920 }, -- Handguards of Transcendence
		{ 22517 }, -- Gloves of Faith
		{ 18327 }, -- Whipvine Cord
		{ 16817 }, -- Girdle of Prophecy
		{ 16925 }, -- Belt of Transcendence
		{ 22518 }, -- Belt of Faith
		{ 11841 }, -- Senior Designer's Pantaloons
		{ 16814 }, -- Pants of Prophecy
		{ 16922 }, -- Leggings of Transcendence
		{ 22513 }, -- Leggings of Faith
		{ 18507 }, -- Boots of the Full Moon
		{ 16811 }, -- Boots of Prophecy
		{ 16919 }, -- Boots of Transcendence
		{ 22516 }, -- Sandals of Faith
		{ 16058 }, -- Fordring's Seal
		{ 18103 }, -- Band of Rumination
		{ 19140 }, -- Cauterizing Band
		{ 19382 }, -- Pure Elementium Band
		{ 11819, 20 }, -- Second Wind
		{ 18371 }, -- Mindtap Talisman
		{ 22268, 20 }, -- Draconic Infused Emblem
		{ 19395 }, -- Rejuvenating Gem
		{ 18469, 15 }, -- Royal Seal of Eldre'Thalas
		{ 11923 }, -- The Hammer of Grace
		{ 11928 }, -- Thaurissan's Royal Scepter
		{ 16997 }, -- Stormrager
		{ 17105 }, -- Aurastone Hammer
		{ 19360 }, -- Lok'amir il Romathis
		{ 23056 }, -- Hammer of the Twisting Nether
	},
	PRIEST_SHADOW = {
		{ 18727 }, -- Crimson Felt Hat
		{ 18691 }, -- Dark Advisor's Pendant
		{ 14112 }, -- Felcloth Shoulders
		{ 14136 }, -- Robe of Winter Night
		{ 13253 }, -- Hands of Power
		{ 18407 }, -- Felcloth Gloves
		{ 13170 }, -- Skyshroud Leggings
		{ 18735 }, -- Maleki's Footwraps
		{ 12543 }, -- Songstone of Ironforge
		{ 12545 }, -- Eye of Orgrimmar
		{ 12930, 25 }, -- Briarwood Reed
		{ 13968 }, -- Eye of the Beast
		{ 13349 }, -- Scepter of the Unholy
		{ 11904 }, -- Spirit of Aquementas
		{ 13396 }, -- Skul's Ghastly Touch
		{ 19375 }, -- Mish'undare, Circlet of the Mind Flayer
		{ 19370 }, -- Mantle of the Blackwing Cabal
		{ 14153 }, -- Robe of the Void
		{ 19147 }, -- Ring of Spell Power
		{ 18820, 30 }, -- Talisman of Ephemeral Power
		{ 19379 }, -- Neltharion's Tear
		{ 18842 }, -- Staff of Dominance
		{ 23207, 40 }, -- Mark of the Champion
	},
}
