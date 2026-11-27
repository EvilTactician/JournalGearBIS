-- Hand-picked Classic best-in-slot items and key upgrades, by spec profile. These win their raid or dungeon
-- tier's step over the stat-weighted pick. { item, value } gives an item whose worth is a proc or use effect
-- (Hand of Justice, Kiss of the Spider) a value in the profile's units. Add specs or items freely:
-- the item must also be in Data.lua.

local G = JournalGearBIS

G.curated = {
	MAGE_ARCANE = {
		{ 18727 }, -- Crimson Felt Hat
		{ 22267 }, -- Spellweaver's Turban
		{ 22403 }, -- Diana's Pearl Necklace
		{ 11782 }, -- Boreal Mantle
		{ 14112 }, -- Felcloth Shoulders
		{ 11623 }, -- Spritecaster Cape
		{ 18350 }, -- Amplifying Cloak
		{ 14152 }, -- Robe of the Archmage
		{ 14136 }, -- Robe of Winter Night
		{ 11962 }, -- Manacle Cuffs
		{ 18497 }, -- Sublime Wristguards
		{ 13253 }, -- Hands of Power
		{ 11662 }, -- Ban'thok Sash
		{ 13170 }, -- Skyshroud Leggings
		{ 11822 }, -- Omnicast Boots
		{ 18735 }, -- Maleki's Footwraps
		{ 12545 }, -- Eye of Orgrimmar
		{ 12543 }, -- Songstone of Ironforge
		{ 11824 }, -- Cyclopean Band
		{ 12930, 25 }, -- Briarwood Reed
		{ 13968 }, -- Eye of the Beast
		{ 13964 }, -- Witchblade
		{ 11904 }, -- Spirit of Aquementas
		{ 13396 }, -- Skul's Ghastly Touch
		{ 13938 }, -- Bonecreeper Stylus
		{ 19375 }, -- Mish'undare, Circlet of the Mind Flayer
		{ 16795 }, -- Arcanist Crown
		{ 16914 }, -- Netherwind Crown
		{ 21347 }, -- Enigma Circlet
		{ 22498 }, -- Frostfire Circlet
		{ 17109 }, -- Choker of Enlightenment
		{ 18814 }, -- Choker of the Fire Lord
		{ 23057 }, -- Gem of Trapped Innocents
		{ 21608 }, -- Amulet of Vek'nilash
		{ 16797 }, -- Arcanist Mantle
		{ 16917 }, -- Netherwind Mantle
		{ 19370 }, -- Mantle of the Blackwing Cabal
		{ 21345 }, -- Enigma Shoulderpads
		{ 22499 }, -- Frostfire Shoulderpads
		{ 19857 }, -- Cloak of Consumption
		{ 17078 }, -- Sapphiron Drape
		{ 23050 }, -- Cloak of the Necropolis
		{ 16798 }, -- Arcanist Robes
		{ 16916 }, -- Netherwind Robes
		{ 21343 }, -- Enigma Robes
		{ 22496 }, -- Frostfire Robe
		{ 19374 }, -- Bracers of Arcane Accuracy
		{ 16918 }, -- Netherwind Bindings
		{ 21186 }, -- Rockfury Bracers
		{ 22503 }, -- Frostfire Bindings
		{ 18808 }, -- Gloves of the Hypnotic Flame
		{ 16913 }, -- Netherwind Gloves
		{ 21585 }, -- Dark Storm Gauntlets
		{ 22501 }, -- Frostfire Gloves
		{ 19136 }, -- Mana Igniting Cord
		{ 16818 }, -- Netherwind Belt
		{ 22730 }, -- Eyestalk Waist Cord
		{ 22502 }, -- Frostfire Belt
		{ 16796 }, -- Arcanist Leggings
		{ 16915 }, -- Netherwind Pants
		{ 21346 }, -- Enigma Leggings
		{ 23070 }, -- Leggings of Polarity
		{ 22497 }, -- Frostfire Leggings
		{ 16912 }, -- Netherwind Boots
		{ 21600 }, -- Boots of Epiphany
		{ 21344 }, -- Enigma Boots
		{ 21648 }, -- Recomposed Boots
		{ 22500 }, -- Frostfire Sandals
		{ 19147 }, -- Ring of Spell Power
		{ 19403 }, -- Band of Forced Concentration
		{ 21709 }, -- Ring of the Fallen God
		{ 23031 }, -- Band of the Inevitable
		{ 23237 }, -- Ring of the Eternal Flame
		{ 23062 }, -- Frostfire Ring
		{ 18820, 30 }, -- Talisman of Ephemeral Power
		{ 19339, 30 }, -- Mind Quickening Gem
		{ 19379 }, -- Neltharion's Tear
		{ 19950, 35 }, -- Zandalarian Hero Charm
		{ 23046 }, -- The Restrained Essence of Sapphiron
		{ 23207, 40 }, -- Mark of the Champion
		{ 17103 }, -- Azuresong Mageblade
		{ 19142 }, -- Fire Runed Grimoire
		{ 18842 }, -- Staff of Dominance
		{ 19356 }, -- Staff of the Shadow Flame
		{ 22807 }, -- Wraith Blade
		{ 23049 }, -- Sapphiron's Left Eye
		{ 17077 }, -- Crimson Shocker
		{ 21603 }, -- Wand of Qiraji Nobility
		{ 22821 }, -- Doomfinger
		{ 22589 }, -- Atiesh, Greatstaff of the Guardian
	},
	MAGE_FIRE = {
		{ 18727 }, -- Crimson Felt Hat
		{ 22267 }, -- Spellweaver's Turban
		{ 22403 }, -- Diana's Pearl Necklace
		{ 11782 }, -- Boreal Mantle
		{ 14112 }, -- Felcloth Shoulders
		{ 11623 }, -- Spritecaster Cape
		{ 18350 }, -- Amplifying Cloak
		{ 14152 }, -- Robe of the Archmage
		{ 14136 }, -- Robe of Winter Night
		{ 11962 }, -- Manacle Cuffs
		{ 18497 }, -- Sublime Wristguards
		{ 13253 }, -- Hands of Power
		{ 11662 }, -- Ban'thok Sash
		{ 13170 }, -- Skyshroud Leggings
		{ 11822 }, -- Omnicast Boots
		{ 18735 }, -- Maleki's Footwraps
		{ 12545 }, -- Eye of Orgrimmar
		{ 12543 }, -- Songstone of Ironforge
		{ 11824 }, -- Cyclopean Band
		{ 12930, 25 }, -- Briarwood Reed
		{ 13968 }, -- Eye of the Beast
		{ 13964 }, -- Witchblade
		{ 11904 }, -- Spirit of Aquementas
		{ 13396 }, -- Skul's Ghastly Touch
		{ 13938 }, -- Bonecreeper Stylus
		{ 19375 }, -- Mish'undare, Circlet of the Mind Flayer
		{ 16795 }, -- Arcanist Crown
		{ 16914 }, -- Netherwind Crown
		{ 21347 }, -- Enigma Circlet
		{ 22498 }, -- Frostfire Circlet
		{ 17109 }, -- Choker of Enlightenment
		{ 18814 }, -- Choker of the Fire Lord
		{ 23057 }, -- Gem of Trapped Innocents
		{ 21608 }, -- Amulet of Vek'nilash
		{ 16797 }, -- Arcanist Mantle
		{ 16917 }, -- Netherwind Mantle
		{ 19370 }, -- Mantle of the Blackwing Cabal
		{ 21345 }, -- Enigma Shoulderpads
		{ 22499 }, -- Frostfire Shoulderpads
		{ 19857 }, -- Cloak of Consumption
		{ 17078 }, -- Sapphiron Drape
		{ 23050 }, -- Cloak of the Necropolis
		{ 16798 }, -- Arcanist Robes
		{ 16916 }, -- Netherwind Robes
		{ 21343 }, -- Enigma Robes
		{ 22496 }, -- Frostfire Robe
		{ 19374 }, -- Bracers of Arcane Accuracy
		{ 16918 }, -- Netherwind Bindings
		{ 21186 }, -- Rockfury Bracers
		{ 22503 }, -- Frostfire Bindings
		{ 18808 }, -- Gloves of the Hypnotic Flame
		{ 16913 }, -- Netherwind Gloves
		{ 21585 }, -- Dark Storm Gauntlets
		{ 22501 }, -- Frostfire Gloves
		{ 19136 }, -- Mana Igniting Cord
		{ 16818 }, -- Netherwind Belt
		{ 22730 }, -- Eyestalk Waist Cord
		{ 22502 }, -- Frostfire Belt
		{ 16796 }, -- Arcanist Leggings
		{ 16915 }, -- Netherwind Pants
		{ 21346 }, -- Enigma Leggings
		{ 23070 }, -- Leggings of Polarity
		{ 22497 }, -- Frostfire Leggings
		{ 16912 }, -- Netherwind Boots
		{ 21600 }, -- Boots of Epiphany
		{ 21344 }, -- Enigma Boots
		{ 21648 }, -- Recomposed Boots
		{ 22500 }, -- Frostfire Sandals
		{ 19147 }, -- Ring of Spell Power
		{ 19403 }, -- Band of Forced Concentration
		{ 21709 }, -- Ring of the Fallen God
		{ 23031 }, -- Band of the Inevitable
		{ 23237 }, -- Ring of the Eternal Flame
		{ 23062 }, -- Frostfire Ring
		{ 18820, 30 }, -- Talisman of Ephemeral Power
		{ 19339, 30 }, -- Mind Quickening Gem
		{ 19379 }, -- Neltharion's Tear
		{ 19950, 35 }, -- Zandalarian Hero Charm
		{ 23046 }, -- The Restrained Essence of Sapphiron
		{ 23207, 40 }, -- Mark of the Champion
		{ 17103 }, -- Azuresong Mageblade
		{ 19142 }, -- Fire Runed Grimoire
		{ 18842 }, -- Staff of Dominance
		{ 19356 }, -- Staff of the Shadow Flame
		{ 22807 }, -- Wraith Blade
		{ 23049 }, -- Sapphiron's Left Eye
		{ 17077 }, -- Crimson Shocker
		{ 21603 }, -- Wand of Qiraji Nobility
		{ 22821 }, -- Doomfinger
		{ 22589 }, -- Atiesh, Greatstaff of the Guardian
	},
	MAGE_FROST = {
		{ 18727 }, -- Crimson Felt Hat
		{ 22267 }, -- Spellweaver's Turban
		{ 22403 }, -- Diana's Pearl Necklace
		{ 11782 }, -- Boreal Mantle
		{ 14112 }, -- Felcloth Shoulders
		{ 11623 }, -- Spritecaster Cape
		{ 18350 }, -- Amplifying Cloak
		{ 14152 }, -- Robe of the Archmage
		{ 14136 }, -- Robe of Winter Night
		{ 11962 }, -- Manacle Cuffs
		{ 18497 }, -- Sublime Wristguards
		{ 13253 }, -- Hands of Power
		{ 11662 }, -- Ban'thok Sash
		{ 13170 }, -- Skyshroud Leggings
		{ 11822 }, -- Omnicast Boots
		{ 18735 }, -- Maleki's Footwraps
		{ 12545 }, -- Eye of Orgrimmar
		{ 12543 }, -- Songstone of Ironforge
		{ 11824 }, -- Cyclopean Band
		{ 12930, 25 }, -- Briarwood Reed
		{ 13968 }, -- Eye of the Beast
		{ 13964 }, -- Witchblade
		{ 11904 }, -- Spirit of Aquementas
		{ 13396 }, -- Skul's Ghastly Touch
		{ 13938 }, -- Bonecreeper Stylus
		{ 19375 }, -- Mish'undare, Circlet of the Mind Flayer
		{ 16795 }, -- Arcanist Crown
		{ 16914 }, -- Netherwind Crown
		{ 21347 }, -- Enigma Circlet
		{ 22498 }, -- Frostfire Circlet
		{ 17109 }, -- Choker of Enlightenment
		{ 18814 }, -- Choker of the Fire Lord
		{ 23057 }, -- Gem of Trapped Innocents
		{ 21608 }, -- Amulet of Vek'nilash
		{ 16797 }, -- Arcanist Mantle
		{ 16917 }, -- Netherwind Mantle
		{ 19370 }, -- Mantle of the Blackwing Cabal
		{ 21345 }, -- Enigma Shoulderpads
		{ 22499 }, -- Frostfire Shoulderpads
		{ 19857 }, -- Cloak of Consumption
		{ 17078 }, -- Sapphiron Drape
		{ 23050 }, -- Cloak of the Necropolis
		{ 16798 }, -- Arcanist Robes
		{ 16916 }, -- Netherwind Robes
		{ 21343 }, -- Enigma Robes
		{ 22496 }, -- Frostfire Robe
		{ 19374 }, -- Bracers of Arcane Accuracy
		{ 16918 }, -- Netherwind Bindings
		{ 21186 }, -- Rockfury Bracers
		{ 22503 }, -- Frostfire Bindings
		{ 18808 }, -- Gloves of the Hypnotic Flame
		{ 16913 }, -- Netherwind Gloves
		{ 21585 }, -- Dark Storm Gauntlets
		{ 22501 }, -- Frostfire Gloves
		{ 19136 }, -- Mana Igniting Cord
		{ 16818 }, -- Netherwind Belt
		{ 22730 }, -- Eyestalk Waist Cord
		{ 22502 }, -- Frostfire Belt
		{ 16796 }, -- Arcanist Leggings
		{ 16915 }, -- Netherwind Pants
		{ 21346 }, -- Enigma Leggings
		{ 23070 }, -- Leggings of Polarity
		{ 22497 }, -- Frostfire Leggings
		{ 16912 }, -- Netherwind Boots
		{ 21600 }, -- Boots of Epiphany
		{ 21344 }, -- Enigma Boots
		{ 21648 }, -- Recomposed Boots
		{ 22500 }, -- Frostfire Sandals
		{ 19147 }, -- Ring of Spell Power
		{ 19403 }, -- Band of Forced Concentration
		{ 21709 }, -- Ring of the Fallen God
		{ 23031 }, -- Band of the Inevitable
		{ 23237 }, -- Ring of the Eternal Flame
		{ 23062 }, -- Frostfire Ring
		{ 18820, 30 }, -- Talisman of Ephemeral Power
		{ 19339, 30 }, -- Mind Quickening Gem
		{ 19379 }, -- Neltharion's Tear
		{ 19950, 35 }, -- Zandalarian Hero Charm
		{ 23046 }, -- The Restrained Essence of Sapphiron
		{ 23207, 40 }, -- Mark of the Champion
		{ 17103 }, -- Azuresong Mageblade
		{ 19142 }, -- Fire Runed Grimoire
		{ 18842 }, -- Staff of Dominance
		{ 19356 }, -- Staff of the Shadow Flame
		{ 22807 }, -- Wraith Blade
		{ 23049 }, -- Sapphiron's Left Eye
		{ 17077 }, -- Crimson Shocker
		{ 21603 }, -- Wand of Qiraji Nobility
		{ 22821 }, -- Doomfinger
		{ 22589 }, -- Atiesh, Greatstaff of the Guardian
	},
	WARLOCK_SHADOW = {
		{ 18727 }, -- Crimson Felt Hat
		{ 22267 }, -- Spellweaver's Turban
		{ 22403 }, -- Diana's Pearl Necklace
		{ 14112 }, -- Felcloth Shoulders
		{ 18681 }, -- Burial Shawl
		{ 11623 }, -- Spritecaster Cape
		{ 18350 }, -- Amplifying Cloak
		{ 14153 }, -- Robe of the Void
		{ 14136 }, -- Robe of Winter Night
		{ 10461 }, -- Shadowy Bracers
		{ 18497 }, -- Sublime Wristguards
		{ 13253 }, -- Hands of Power
		{ 18407 }, -- Felcloth Gloves
		{ 11662 }, -- Ban'thok Sash
		{ 18740 }, -- Thuzadin Sash
		{ 13170 }, -- Skyshroud Leggings
		{ 18735 }, -- Maleki's Footwraps
		{ 11822 }, -- Omnicast Boots
		{ 12545 }, -- Eye of Orgrimmar
		{ 12543 }, -- Songstone of Ironforge
		{ 11824 }, -- Cyclopean Band
		{ 12930, 25 }, -- Briarwood Reed
		{ 13968 }, -- Eye of the Beast
		{ 13964 }, -- Witchblade
		{ 11904 }, -- Spirit of Aquementas
		{ 13396 }, -- Skul's Ghastly Touch
		{ 13938 }, -- Bonecreeper Stylus
		{ 19375 }, -- Mish'undare, Circlet of the Mind Flayer
		{ 16808 }, -- Felheart Horns
		{ 16929 }, -- Nemesis Skullcap
		{ 22506 }, -- Plagueheart Circlet
		{ 18814 }, -- Choker of the Fire Lord
		{ 23057 }, -- Gem of Trapped Innocents
		{ 19370 }, -- Mantle of the Blackwing Cabal
		{ 16932 }, -- Nemesis Spaulders
		{ 22507 }, -- Plagueheart Shoulderpads
		{ 17078 }, -- Sapphiron Drape
		{ 23050 }, -- Cloak of the Necropolis
		{ 16931 }, -- Nemesis Robes
		{ 22504 }, -- Plagueheart Robe
		{ 21186 }, -- Rockfury Bracers
		{ 22511 }, -- Plagueheart Bindings
		{ 21585 }, -- Dark Storm Gauntlets
		{ 22509 }, -- Plagueheart Gloves
		{ 22730 }, -- Eyestalk Waist Cord
		{ 22510 }, -- Plagueheart Belt
		{ 23070 }, -- Leggings of Polarity
		{ 22505 }, -- Plagueheart Leggings
		{ 21600 }, -- Boots of Epiphany
		{ 22508 }, -- Plagueheart Sandals
		{ 19147 }, -- Ring of Spell Power
		{ 23031 }, -- Band of the Inevitable
		{ 21709 }, -- Ring of the Fallen God
		{ 23063 }, -- Plagueheart Ring
		{ 18820, 30 }, -- Talisman of Ephemeral Power
		{ 19379 }, -- Neltharion's Tear
		{ 19950, 35 }, -- Zandalarian Hero Charm
		{ 23046 }, -- The Restrained Essence of Sapphiron
		{ 23207, 40 }, -- Mark of the Champion
		{ 18842 }, -- Staff of Dominance
		{ 22807 }, -- Wraith Blade
		{ 23049 }, -- Sapphiron's Left Eye
		{ 22821 }, -- Doomfinger
		{ 22630 }, -- Atiesh, Greatstaff of the Guardian
	},
	WARLOCK_FIRE = {
		{ 18727 }, -- Crimson Felt Hat
		{ 22267 }, -- Spellweaver's Turban
		{ 22403 }, -- Diana's Pearl Necklace
		{ 14112 }, -- Felcloth Shoulders
		{ 18681 }, -- Burial Shawl
		{ 11623 }, -- Spritecaster Cape
		{ 18350 }, -- Amplifying Cloak
		{ 14153 }, -- Robe of the Void
		{ 14136 }, -- Robe of Winter Night
		{ 10461 }, -- Shadowy Bracers
		{ 18497 }, -- Sublime Wristguards
		{ 13253 }, -- Hands of Power
		{ 18407 }, -- Felcloth Gloves
		{ 11662 }, -- Ban'thok Sash
		{ 18740 }, -- Thuzadin Sash
		{ 13170 }, -- Skyshroud Leggings
		{ 18735 }, -- Maleki's Footwraps
		{ 11822 }, -- Omnicast Boots
		{ 12545 }, -- Eye of Orgrimmar
		{ 12543 }, -- Songstone of Ironforge
		{ 11824 }, -- Cyclopean Band
		{ 12930, 25 }, -- Briarwood Reed
		{ 13968 }, -- Eye of the Beast
		{ 13964 }, -- Witchblade
		{ 11904 }, -- Spirit of Aquementas
		{ 13396 }, -- Skul's Ghastly Touch
		{ 13938 }, -- Bonecreeper Stylus
		{ 19375 }, -- Mish'undare, Circlet of the Mind Flayer
		{ 16808 }, -- Felheart Horns
		{ 16929 }, -- Nemesis Skullcap
		{ 22506 }, -- Plagueheart Circlet
		{ 18814 }, -- Choker of the Fire Lord
		{ 23057 }, -- Gem of Trapped Innocents
		{ 19370 }, -- Mantle of the Blackwing Cabal
		{ 16932 }, -- Nemesis Spaulders
		{ 22507 }, -- Plagueheart Shoulderpads
		{ 17078 }, -- Sapphiron Drape
		{ 23050 }, -- Cloak of the Necropolis
		{ 16931 }, -- Nemesis Robes
		{ 22504 }, -- Plagueheart Robe
		{ 21186 }, -- Rockfury Bracers
		{ 22511 }, -- Plagueheart Bindings
		{ 21585 }, -- Dark Storm Gauntlets
		{ 22509 }, -- Plagueheart Gloves
		{ 22730 }, -- Eyestalk Waist Cord
		{ 22510 }, -- Plagueheart Belt
		{ 23070 }, -- Leggings of Polarity
		{ 22505 }, -- Plagueheart Leggings
		{ 21600 }, -- Boots of Epiphany
		{ 22508 }, -- Plagueheart Sandals
		{ 19147 }, -- Ring of Spell Power
		{ 23031 }, -- Band of the Inevitable
		{ 21709 }, -- Ring of the Fallen God
		{ 23063 }, -- Plagueheart Ring
		{ 18820, 30 }, -- Talisman of Ephemeral Power
		{ 19379 }, -- Neltharion's Tear
		{ 19950, 35 }, -- Zandalarian Hero Charm
		{ 23046 }, -- The Restrained Essence of Sapphiron
		{ 23207, 40 }, -- Mark of the Champion
		{ 18842 }, -- Staff of Dominance
		{ 22807 }, -- Wraith Blade
		{ 23049 }, -- Sapphiron's Left Eye
		{ 22821 }, -- Doomfinger
		{ 22630 }, -- Atiesh, Greatstaff of the Guardian
	},
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
	DRUID_CAT = {
		{ 8345, 40 }, -- Wolfshead Helm
		{ 15411 }, -- Mark of Fordring
		{ 12927 }, -- Truestrike Shoulders
		{ 13340 }, -- Cape of the Black Baron
		{ 14637 }, -- Cadaverous Armor
		{ 12966 }, -- Blackmist Armguards
		{ 15063 }, -- Devilsaur Gauntlets
		{ 13252 }, -- Cloudrunner Girdle
		{ 15062 }, -- Devilsaur Leggings
		{ 12553 }, -- Swiftwalker Boots
		{ 17713 }, -- Blackstone Ring
		{ 22255 }, -- Magma Forged Band
		{ 13965 }, -- Blackhand's Breadth
		{ 11815, 45 }, -- Hand of Justice
		{ 22397, 20 }, -- Idol of Ferocity
		{ 9449, 60 }, -- Manual Crowd Pummeler
		{ 18404 }, -- Onyxia Tooth Pendant
		{ 19377 }, -- Prestor's Talisman of Connivery
		{ 21664 }, -- Barbed Choker
		{ 19398 }, -- Cloak of Firemaw
		{ 17102 }, -- Cloak of the Shrouded Mists
		{ 19146 }, -- Wristguards of Stability
		{ 21672 }, -- Gloves of Enforcement
		{ 18821 }, -- Quick Strike Ring
		{ 17063 }, -- Band of Accuria
		{ 19384 }, -- Master Dragonslayer's Ring
		{ 19432 }, -- Circle of Applied Force
		{ 19406 }, -- Drake Fang Talisman
		{ 22954, 75 }, -- Kiss of the Spider
		{ 23206, 60 }, -- Mark of the Champion
	},
	DRUID_BEAR = {
		{ 13404 }, -- Mask of the Unforgiven
		{ 15411 }, -- Mark of Fordring
		{ 12927 }, -- Truestrike Shoulders
		{ 18689 }, -- Phantasmal Cloak
		{ 12757 }, -- Breastplate of Bloodthirst
		{ 12966 }, -- Blackmist Armguards
		{ 15063 }, -- Devilsaur Gauntlets
		{ 13252 }, -- Cloudrunner Girdle
		{ 15062 }, -- Devilsaur Leggings
		{ 13210 }, -- Pads of the Dread Wolf
		{ 12544 }, -- Thrall's Resolve
		{ 17713 }, -- Blackstone Ring
		{ 13965 }, -- Blackhand's Breadth
		{ 17774 }, -- Mark of the Chosen
		{ 23198, 15 }, -- Idol of Brutality
		{ 18404 }, -- Onyxia Tooth Pendant
		{ 19146 }, -- Wristguards of Stability
		{ 21672 }, -- Gloves of Enforcement
		{ 17063 }, -- Band of Accuria
		{ 19384 }, -- Master Dragonslayer's Ring
		{ 19406 }, -- Drake Fang Talisman
	},
	DRUID_BALANCE = {
		{ 18727 }, -- Crimson Felt Hat
		{ 22403 }, -- Diana's Pearl Necklace
		{ 18681 }, -- Burial Shawl
		{ 11623 }, -- Spritecaster Cape
		{ 11924 }, -- Robes of the Royal Crown
		{ 11962 }, -- Manacle Cuffs
		{ 13253 }, -- Hands of Power
		{ 11662 }, -- Ban'thok Sash
		{ 13170 }, -- Skyshroud Leggings
		{ 11822 }, -- Omnicast Boots
		{ 12545 }, -- Eye of Orgrimmar
		{ 12543 }, -- Songstone of Ironforge
		{ 11824 }, -- Cyclopean Band
		{ 13968 }, -- Eye of the Beast
		{ 12930, 25 }, -- Briarwood Reed
		{ 13964 }, -- Witchblade
		{ 11904 }, -- Spirit of Aquementas
		{ 19147 }, -- Ring of Spell Power
		{ 18820, 30 }, -- Talisman of Ephemeral Power
		{ 18842 }, -- Staff of Dominance
		{ 19379 }, -- Neltharion's Tear
		{ 23057 }, -- Gem of Trapped Innocents
		{ 22983 }, -- Rime Covered Mantle
		{ 23050 }, -- Cloak of the Necropolis
		{ 23031 }, -- Band of the Inevitable
		{ 23046 }, -- The Restrained Essence of Sapphiron
		{ 22800 }, -- Brimstone Staff
		{ 23197, 15 }, -- Idol of the Moon
		{ 23207, 40 }, -- Mark of the Champion
	},
	DRUID_RESTO = {
		{ 12960 }, -- Tribal War Feathers
		{ 18723 }, -- Animated Chain Necklace
		{ 15061 }, -- Living Shoulders
		{ 11623 }, -- Spritecaster Cape
		{ 13346 }, -- Robes of the Exalted
		{ 13208 }, -- Bleak Howler Armguards
		{ 12554 }, -- Hands of the Exalted Herald
		{ 18740 }, -- Thuzadin Sash
		{ 11841 }, -- Senior Designer's Pantaloons
		{ 13954 }, -- Verdant Footpads
		{ 13178 }, -- Rosewine Circle
		{ 16058 }, -- Fordring's Seal
		{ 11819, 20 }, -- Second Wind
		{ 12930, 20 }, -- Briarwood Reed
		{ 11923 }, -- The Hammer of Grace
		{ 11928 }, -- Thaurissan's Royal Scepter
		{ 18510 }, -- Hide of the Wild
		{ 19140 }, -- Cauterizing Band
		{ 19382 }, -- Pure Elementium Band
		{ 19395 }, -- Rejuvenating Gem
		{ 17105 }, -- Aurastone Hammer
		{ 23056 }, -- Hammer of the Twisting Nether
		{ 21712 }, -- Amulet of the Fallen God
		{ 22398, 20 }, -- Idol of Rejuvenation
	},
}

-- A line for a hand-picked item's tooltip: optional extras and odd ways to get them.
G.curatedNotes = {
	[21186] = "The end of a long Cenarion Circle quest chain in Silithus, opened by Ahn'Qiraj: you need Revered with the Cenarion Circle for it.", -- Rockfury Bracers
	[12757] = "Skinning The Beast needs 310: 300 plus Finkle's Skinner (+10), a dagger The Beast itself drops. The hide comes about 1 skin in 50.", -- Breastplate of Bloodthirst
	[14152] = "Tailoring 300 sews it, from a pattern that Firebrand Pyromancers drop in Lower Blackrock Spire. It binds when made, so you have to be the tailor.", -- Robe of the Archmage
	[9449] = "Optional: 3 uses of its haste, then it's just a weapon. Only for squeezing out every bit of damage; you'd need several.", -- Manual Crowd Pummeler
}
