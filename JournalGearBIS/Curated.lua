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
		{ 12927 }, -- Truestrike Shoulders
		{ 16823 }, -- Nightslayer Shoulder Pads
		{ 16832 }, -- Bloodfang Spaulders
		{ 21361 }, -- Deathdealer's Spaulders
		{ 22479 }, -- Bonescythe Pauldrons
		{ 13340 }, -- Cape of the Black Baron
		{ 19398 }, -- Cloak of Firemaw
		{ 21710 }, -- Cloak of the Fallen God
		{ 17102 }, -- Cloak of the Shrouded Mists
		{ 14637 }, -- Cadaverous Armor
		{ 16820 }, -- Nightslayer Chestpiece
		{ 16905 }, -- Bloodfang Chestpiece
		{ 21364 }, -- Deathdealer's Vest
		{ 22476 }, -- Bonescythe Breastplate
		{ 16911 }, -- Bloodfang Bracers
		{ 22483 }, -- Bonescythe Bracers
		{ 15063 }, -- Devilsaur Gauntlets
		{ 16826 }, -- Nightslayer Gloves
		{ 16907 }, -- Bloodfang Gloves
		{ 22481 }, -- Bonescythe Gauntlets
		{ 16827 }, -- Nightslayer Belt
		{ 16910 }, -- Bloodfang Belt
		{ 22482 }, -- Bonescythe Waistguard
		{ 15062 }, -- Devilsaur Leggings
		{ 16822 }, -- Nightslayer Pants
		{ 16909 }, -- Bloodfang Pants
		{ 21362 }, -- Deathdealer's Leggings
		{ 22477 }, -- Bonescythe Legplates
		{ 16824 }, -- Nightslayer Boots
		{ 16906 }, -- Bloodfang Boots
		{ 21359 }, -- Deathdealer's Boots
		{ 22480 }, -- Bonescythe Sabatons
		{ 17713 }, -- Blackstone Ring
		{ 13098 }, -- Painweaver Band
		{ 18821 }, -- Quick Strike Ring
		{ 19384 }, -- Master Dragonslayer's Ring
		{ 19432 }, -- Circle of Applied Force
		{ 11815, 45 }, -- Hand of Justice
		{ 13965 }, -- Blackhand's Breadth
		{ 19406 }, -- Drake Fang Talisman
		{ 22954, 75 }, -- Kiss of the Spider
		{ 18323 }, -- Satyr's Bow
		{ 17069 }, -- Striker's Mark
		{ 19368 }, -- Dragonbreath Hand Cannon
		{ 12940 }, -- Dal'Rend's Sacred Charge
		{ 12939 }, -- Dal'Rend's Tribal Guardian
		{ 18832 }, -- Brutality Blade
		{ 17075 }, -- Vis'kag the Bloodletter
		{ 19352 }, -- Chromatically Tempered Sword
		{ 19351 }, -- Maladath, Runed Blade of the Black Flight
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
		{ 12927 }, -- Truestrike Shoulders
		{ 16823 }, -- Nightslayer Shoulder Pads
		{ 16832 }, -- Bloodfang Spaulders
		{ 21361 }, -- Deathdealer's Spaulders
		{ 22479 }, -- Bonescythe Pauldrons
		{ 13340 }, -- Cape of the Black Baron
		{ 19398 }, -- Cloak of Firemaw
		{ 21710 }, -- Cloak of the Fallen God
		{ 17102 }, -- Cloak of the Shrouded Mists
		{ 14637 }, -- Cadaverous Armor
		{ 16820 }, -- Nightslayer Chestpiece
		{ 16905 }, -- Bloodfang Chestpiece
		{ 21364 }, -- Deathdealer's Vest
		{ 22476 }, -- Bonescythe Breastplate
		{ 16911 }, -- Bloodfang Bracers
		{ 22483 }, -- Bonescythe Bracers
		{ 15063 }, -- Devilsaur Gauntlets
		{ 16826 }, -- Nightslayer Gloves
		{ 16907 }, -- Bloodfang Gloves
		{ 22481 }, -- Bonescythe Gauntlets
		{ 16827 }, -- Nightslayer Belt
		{ 16910 }, -- Bloodfang Belt
		{ 22482 }, -- Bonescythe Waistguard
		{ 15062 }, -- Devilsaur Leggings
		{ 16822 }, -- Nightslayer Pants
		{ 16909 }, -- Bloodfang Pants
		{ 21362 }, -- Deathdealer's Leggings
		{ 22477 }, -- Bonescythe Legplates
		{ 16824 }, -- Nightslayer Boots
		{ 16906 }, -- Bloodfang Boots
		{ 21359 }, -- Deathdealer's Boots
		{ 22480 }, -- Bonescythe Sabatons
		{ 17713 }, -- Blackstone Ring
		{ 13098 }, -- Painweaver Band
		{ 18821 }, -- Quick Strike Ring
		{ 19384 }, -- Master Dragonslayer's Ring
		{ 19432 }, -- Circle of Applied Force
		{ 11815, 45 }, -- Hand of Justice
		{ 13965 }, -- Blackhand's Breadth
		{ 19406 }, -- Drake Fang Talisman
		{ 22954, 75 }, -- Kiss of the Spider
		{ 18323 }, -- Satyr's Bow
		{ 17069 }, -- Striker's Mark
		{ 19368 }, -- Dragonbreath Hand Cannon
		{ 12590 }, -- Felstriker
		{ 18816 }, -- Perdition's Blade
		{ 18805 }, -- Core Hound Tooth
		{ 18392 }, -- Distracting Dagger
	},
	PRIEST_HEAL = {
		{ 16693 }, -- Devout Crown
		{ 16813 }, -- Circlet of Prophecy
		{ 16921 }, -- Halo of Transcendence
		{ 21348 }, -- Tiara of the Oracle
		{ 22514 }, -- Circlet of Faith
		{ 18723 }, -- Animated Chain Necklace
		{ 17109 }, -- Choker of Enlightenment
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
		{ 16817 }, -- Girdle of Prophecy
		{ 16925 }, -- Belt of Transcendence
		{ 22518 }, -- Belt of Faith
		{ 16814 }, -- Pants of Prophecy
		{ 16922 }, -- Leggings of Transcendence
		{ 22513 }, -- Leggings of Faith
		{ 16811 }, -- Boots of Prophecy
		{ 16919 }, -- Boots of Transcendence
		{ 22516 }, -- Sandals of Faith
		{ 19140 }, -- Cauterizing Band
		{ 19382 }, -- Pure Elementium Band
		{ 11819, 20 }, -- Second Wind
		{ 19395 }, -- Rejuvenating Gem
		{ 18469, 15 }, -- Royal Seal of Eldre'Thalas
		{ 17105 }, -- Aurastone Hammer
		{ 19360 }, -- Lok'amir il Romathis
	},
	PRIEST_SHADOW = {
		{ 19370 }, -- Mantle of the Blackwing Cabal
		{ 19147 }, -- Ring of Spell Power
		{ 18820, 30 }, -- Talisman of Ephemeral Power
		{ 12930, 25 }, -- Briarwood Reed
		{ 19379 }, -- Neltharion's Tear
		{ 18842 }, -- Staff of Dominance
		{ 14153 }, -- Robe of the Void
	},
}
