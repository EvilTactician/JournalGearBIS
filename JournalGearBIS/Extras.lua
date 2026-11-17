-- Enchants, glyphs and consumables for JournalGearBIS, generated from the realm's world database and the
-- client's DBC files (tools/gen.py). Don't edit by hand: tools/curated.py has the hand-picked lists.
--
--   enchants[slot] = { { e = enchant, spell = enchanting spell or item = the item that puts it on,
--                        level = level needed, classes = bit mask (0 = all), ways = { source, ... } } }
--                    slots: armor slots, SHIELD, WEAPON (any weapon), TWOHAND (two-handers) and RANGED (bows, guns)
--   enchantStats[enchant] = { stats } (wdmg = weapon damage), with proc = value by profile for procs
--   extraItems[id] = { name, quality, required level, sources } (sources as in Data.lua)
--   enchantNames[enchant] = "what it gives"
--   glyphs[profile] = { major = { { item, glyph spell, Inscription skill, stage, level, "talent", "name" } },
--                       minor = { ... } }, best first
--   consumables[profile] = { { item, "note" } }
--   professionConsumables[profession] = { { item, skill needed to use it, "what it's for" } }

local G = JournalGearBIS

G.enchants = {
	BACK = {
		{ e = 65, spell = 7454, level = 0, ways = { { "X", "Enchanting", 333, 45, 0, "from a trainer", 0 } } },
		{ e = 256, spell = 7861, level = 0, ways = { { "X", "Enchanting", 333, 125, 0, "from a trainer", 0 } } },
		{ e = 744, spell = 13421, level = 0, ways = { { "X", "Enchanting", 333, 115, 0, "from a trainer", 0 } } },
		{ e = 783, spell = 7771, level = 0, ways = { { "X", "Enchanting", 333, 70, 0, "from a trainer", 0 } } },
		{ e = 804, spell = 13522, level = 0, ways = { { "X", "Enchanting", 333, 135, 0, "from a recipe", 0 } } },
		{ e = 884, spell = 13746, level = 0, ways = { { "X", "Enchanting", 333, 205, 0, "from a trainer", 0 } } },
		{ e = 903, spell = 13794, level = 0, ways = { { "X", "Enchanting", 333, 205, 0, "from a trainer", 0 } } },
		{ e = 1888, spell = 20014, level = 0, ways = { { "X", "Enchanting", 333, 265, 0, "recipe drops in Sunken Temple", 109 } } },
		{ e = 1889, spell = 20015, level = 0, ways = { { "X", "Enchanting", 333, 285, 0, "recipe sold by Lorelae Wintersong", 0 } } },
		{ e = 2463, spell = 13657, level = 0, ways = { { "X", "Enchanting", 333, 175, 0, "from a trainer", 0 } } },
		{ e = 2619, spell = 25081, level = 0, ways = { { "X", "Enchanting", 333, 300, 4, "recipe sold by Kania (Friendly)", 0 } } },
		{ e = 2620, spell = 25082, level = 0, ways = { { "X", "Enchanting", 333, 300, 4, "recipe sold by Kania (Honored)", 0 } } },
	},
	CHEST = {
		{ e = 24, spell = 7443, level = 0, ways = { { "X", "Enchanting", 333, 20, 0, "recipe sold by Jessara Cordell", 0 } } },
		{ e = 41, spell = 7420, level = 0, ways = { { "X", "Enchanting", 333, 15, 0, "from a trainer", 0 } } },
		{ e = 44, spell = 7426, level = 0, ways = { { "X", "Enchanting", 333, 40, 0, "from a trainer", 0 } } },
		{ e = 63, spell = 13538, level = 0, ways = { { "X", "Enchanting", 333, 140, 0, "from a trainer", 0 } } },
		{ e = 242, spell = 7748, level = 0, ways = { { "X", "Enchanting", 333, 60, 0, "from a trainer", 0 } } },
		{ e = 246, spell = 7776, level = 0, ways = { { "X", "Enchanting", 333, 80, 0, "recipe sold by Kithas", 0 } } },
		{ e = 254, spell = 7857, level = 0, ways = { { "X", "Enchanting", 333, 120, 0, "from a trainer", 0 } } },
		{ e = 843, spell = 13607, level = 0, ways = { { "X", "Enchanting", 333, 145, 0, "from a trainer", 0 } } },
		{ e = 847, spell = 13626, level = 0, ways = { { "X", "Enchanting", 333, 150, 0, "from a trainer", 0 } } },
		{ e = 850, spell = 13640, level = 0, ways = { { "X", "Enchanting", 333, 160, 0, "from a trainer", 0 } } },
		{ e = 857, spell = 13663, level = 0, ways = { { "X", "Enchanting", 333, 185, 0, "from a trainer", 0 } } },
		{ e = 866, spell = 13700, level = 0, ways = { { "X", "Enchanting", 333, 200, 0, "from a trainer", 0 } } },
		{ e = 908, spell = 13858, level = 0, ways = { { "X", "Enchanting", 333, 220, 0, "from a trainer", 0 } } },
		{ e = 913, spell = 13917, level = 0, ways = { { "X", "Enchanting", 333, 230, 0, "from a trainer", 0 } } },
		{ e = 928, spell = 13941, level = 0, ways = { { "X", "Enchanting", 333, 245, 0, "from a trainer", 0 } } },
		{ e = 1891, spell = 20025, level = 0, ways = { { "X", "Enchanting", 333, 300, 1, "recipe drops in Onyxia's Lair", 249 } } },
		{ e = 1892, spell = 20026, level = 0, ways = { { "X", "Enchanting", 333, 275, 0, "recipe sold by Qia", 0 } } },
		{ e = 1893, spell = 20028, level = 0, ways = { { "X", "Enchanting", 333, 290, 0, "from a recipe", 0 } } },
		{ e = 15, item = 2304, level = 1, classes = 0 },
		{ e = 16, item = 2313, level = 5, classes = 0 },
		{ e = 17, item = 4265, level = 20, classes = 0 },
		{ e = 18, item = 8173, level = 30, classes = 0 },
		{ e = 1843, item = 15564, level = 40, classes = 0 },
		{ e = 2503, item = 18251, level = 50, classes = 0 },
	},
	FEET = {
		{ e = 849, spell = 13637, level = 0, ways = { { "X", "Enchanting", 333, 160, 0, "from a trainer", 0 } } },
		{ e = 911, spell = 13890, level = 0, ways = { { "X", "Enchanting", 333, 225, 0, "from a trainer", 0 } } },
		{ e = 15, item = 2304, level = 1, classes = 0 },
		{ e = 16, item = 2313, level = 5, classes = 0 },
		{ e = 17, item = 4265, level = 20, classes = 0 },
		{ e = 464, item = 7969, level = 0, classes = 0 },
		{ e = 18, item = 8173, level = 30, classes = 0 },
		{ e = 1843, item = 15564, level = 40, classes = 0 },
		{ e = 2503, item = 18251, level = 50, classes = 0 },
	},
	HANDS = {
		{ e = 844, spell = 13612, level = 0, ways = { { "X", "Enchanting", 333, 145, 0, "from a recipe", 0 } } },
		{ e = 845, spell = 13617, level = 0, ways = { { "X", "Enchanting", 333, 145, 0, "from a recipe", 0 } } },
		{ e = 865, spell = 13698, level = 0, ways = { { "X", "Enchanting", 333, 200, 0, "from a recipe", 0 } } },
		{ e = 904, spell = 13815, level = 0, ways = { { "X", "Enchanting", 333, 210, 0, "from a trainer", 0 } } },
		{ e = 906, spell = 13841, level = 0, ways = { { "X", "Enchanting", 333, 215, 0, "from a recipe", 0 } } },
		{ e = 909, spell = 13868, level = 0, ways = { { "X", "Enchanting", 333, 225, 0, "from a recipe", 0 } } },
		{ e = 930, spell = 13947, level = 0, ways = { { "X", "Enchanting", 333, 250, 1, "recipe drops in Onyxia's Lair", 249 } } },
		{ e = 931, spell = 13948, level = 0, ways = { { "X", "Enchanting", 333, 250, 0, "from a trainer", 0 } } },
		{ e = 1887, spell = 20012, level = 0, ways = { { "X", "Enchanting", 333, 270, 0, "from a recipe", 0 } } },
		{ e = 2603, spell = 13620, level = 0, ways = { { "X", "Enchanting", 333, 145, 0, "from a recipe", 0 } } },
		{ e = 2614, spell = 25073, level = 0, ways = { { "X", "Enchanting", 333, 300, 4, "recipe drops in Temple of Ahn'Qiraj", 531 } } },
		{ e = 2615, spell = 25074, level = 0, ways = { { "X", "Enchanting", 333, 300, 4, "recipe drops in Temple of Ahn'Qiraj", 531 } } },
		{ e = 2616, spell = 25078, level = 0, ways = { { "X", "Enchanting", 333, 300, 4, "recipe drops in Temple of Ahn'Qiraj", 531 } } },
		{ e = 2617, spell = 25079, level = 0, ways = { { "X", "Enchanting", 333, 300, 4, "recipe drops in Temple of Ahn'Qiraj", 531 } } },
		{ e = 15, item = 2304, level = 1, classes = 0 },
		{ e = 16, item = 2313, level = 5, classes = 0 },
		{ e = 17, item = 4265, level = 20, classes = 0 },
		{ e = 18, item = 8173, level = 30, classes = 0 },
		{ e = 1843, item = 15564, level = 40, classes = 0 },
		{ e = 2503, item = 18251, level = 50, classes = 0 },
	},
	HEAD = {
		{ e = 1483, item = 11622, level = 50, classes = 0 },
		{ e = 1503, item = 11642, level = 50, classes = 0 },
		{ e = 1504, item = 11643, level = 50, classes = 0 },
		{ e = 1505, item = 11644, level = 50, classes = 0 },
		{ e = 1506, item = 11645, level = 50, classes = 0 },
		{ e = 1507, item = 11646, level = 50, classes = 0 },
		{ e = 1508, item = 11647, level = 50, classes = 0 },
		{ e = 1509, item = 11648, level = 50, classes = 0 },
		{ e = 1510, item = 11649, level = 50, classes = 0 },
		{ e = 2543, item = 18329, level = 50, classes = 0 },
		{ e = 2544, item = 18330, level = 50, classes = 0 },
		{ e = 2545, item = 18331, level = 50, classes = 0 },
		{ e = 2583, item = 19782, level = 60, classes = 1 },
		{ e = 2584, item = 19783, level = 60, classes = 2 },
		{ e = 3755, item = 19784, level = 60, classes = 8 },
		{ e = 3754, item = 19785, level = 60, classes = 4 },
		{ e = 2587, item = 19786, level = 60, classes = 64 },
		{ e = 2588, item = 19787, level = 60, classes = 128 },
		{ e = 2589, item = 19788, level = 60, classes = 256 },
		{ e = 2590, item = 19789, level = 60, classes = 16 },
		{ e = 2591, item = 19790, level = 60, classes = 1024 },
		{ e = 2681, item = 22635, level = 55, classes = 0 },
		{ e = 2682, item = 22636, level = 55, classes = 0 },
		{ e = 2683, item = 22638, level = 55, classes = 0 },
	},
	LEGS = {
		{ e = 15, item = 2304, level = 1, classes = 0 },
		{ e = 16, item = 2313, level = 5, classes = 0 },
		{ e = 17, item = 4265, level = 20, classes = 0 },
		{ e = 18, item = 8173, level = 30, classes = 0 },
		{ e = 1483, item = 11622, level = 50, classes = 0 },
		{ e = 1503, item = 11642, level = 50, classes = 0 },
		{ e = 1504, item = 11643, level = 50, classes = 0 },
		{ e = 1505, item = 11644, level = 50, classes = 0 },
		{ e = 1506, item = 11645, level = 50, classes = 0 },
		{ e = 1507, item = 11646, level = 50, classes = 0 },
		{ e = 1508, item = 11647, level = 50, classes = 0 },
		{ e = 1509, item = 11648, level = 50, classes = 0 },
		{ e = 1510, item = 11649, level = 50, classes = 0 },
		{ e = 1843, item = 15564, level = 40, classes = 0 },
		{ e = 2503, item = 18251, level = 50, classes = 0 },
		{ e = 2543, item = 18329, level = 50, classes = 0 },
		{ e = 2544, item = 18330, level = 50, classes = 0 },
		{ e = 2545, item = 18331, level = 50, classes = 0 },
		{ e = 2583, item = 19782, level = 60, classes = 1 },
		{ e = 2584, item = 19783, level = 60, classes = 2 },
		{ e = 3755, item = 19784, level = 60, classes = 8 },
		{ e = 3754, item = 19785, level = 60, classes = 4 },
		{ e = 2587, item = 19786, level = 60, classes = 64 },
		{ e = 2588, item = 19787, level = 60, classes = 128 },
		{ e = 2589, item = 19788, level = 60, classes = 256 },
		{ e = 2590, item = 19789, level = 60, classes = 16 },
		{ e = 2591, item = 19790, level = 60, classes = 1024 },
		{ e = 2681, item = 22635, level = 55, classes = 0 },
		{ e = 2682, item = 22636, level = 55, classes = 0 },
		{ e = 2683, item = 22638, level = 55, classes = 0 },
	},
	RANGED = {
		{ e = 30, item = 4405, level = 5, classes = 0 },
		{ e = 32, item = 4406, level = 10, classes = 0 },
		{ e = 33, item = 4407, level = 20, classes = 0 },
		{ e = 663, item = 10546, level = 30, classes = 0 },
		{ e = 664, item = 10548, level = 40, classes = 0 },
		{ e = 2523, item = 18283, level = 50, classes = 0 },
	},
	SHIELD = {
		{ e = 848, spell = 13464, level = 0, ways = { { "X", "Enchanting", 333, 115, 0, "from a recipe", 0 } } },
		{ e = 863, spell = 13689, level = 0, ways = { { "X", "Enchanting", 333, 195, 0, "from a recipe", 0 } } },
		{ e = 926, spell = 13933, level = 0, ways = { { "X", "Enchanting", 333, 235, 1, "recipe drops in Onyxia's Lair", 249 } } },
		{ e = 1890, spell = 20016, level = 0, ways = { { "X", "Enchanting", 333, 280, 0, "from a recipe", 0 } } },
		{ e = 43, item = 6042, level = 0, classes = 0 },
		{ e = 463, item = 7967, level = 0, classes = 0 },
		{ e = 1704, item = 12645, level = 0, classes = 0 },
	},
	SHOULDER = {
		{ e = 2483, item = 18169, level = 50, classes = 0 },
		{ e = 2484, item = 18170, level = 50, classes = 0 },
		{ e = 2485, item = 18171, level = 50, classes = 0 },
		{ e = 2486, item = 18172, level = 50, classes = 0 },
		{ e = 2487, item = 18173, level = 50, classes = 0 },
		{ e = 2488, item = 18182, level = 50, classes = 0 },
		{ e = 2605, item = 20076, level = 55, classes = 0 },
		{ e = 2606, item = 20077, level = 55, classes = 0 },
		{ e = 2604, item = 20078, level = 55, classes = 0 },
		{ e = 2721, item = 23545, level = 60, classes = 0 },
		{ e = 2715, item = 23547, level = 60, classes = 0 },
		{ e = 2717, item = 23548, level = 60, classes = 0 },
		{ e = 2716, item = 23549, level = 60, classes = 0 },
	},
	TWOHAND = {
		{ e = 241, spell = 7745, level = 0, ways = { { "X", "Enchanting", 333, 100, 0, "from a trainer", 0 } } },
		{ e = 255, spell = 13380, level = 0, ways = { { "X", "Enchanting", 333, 110, 0, "from a recipe", 0 } } },
		{ e = 723, spell = 7793, level = 0, ways = { { "X", "Enchanting", 333, 100, 0, "recipe sold by Nata Dawnstrider", 0 } } },
		{ e = 943, spell = 13529, level = 0, ways = { { "X", "Enchanting", 333, 145, 0, "from a trainer", 0 } } },
		{ e = 963, spell = 13937, level = 0, ways = { { "X", "Enchanting", 333, 240, 0, "from a trainer", 0 } } },
		{ e = 1896, spell = 20030, level = 0, ways = { { "X", "Enchanting", 333, 295, 0, "recipe drops in Lower Blackrock Spire", 229 } } },
		{ e = 1897, spell = 13695, level = 0, ways = { { "X", "Enchanting", 333, 200, 0, "from a trainer", 0 } } },
		{ e = 1903, spell = 20035, level = 0, ways = { { "X", "Enchanting", 333, 300, 0, "recipe drops in Scholomance", 289 } } },
		{ e = 1904, spell = 20036, level = 0, ways = { { "X", "Enchanting", 333, 300, 0, "recipe drops in Stratholme", 329 } } },
		{ e = 34, item = 6043, level = 0, classes = 0 },
	},
	WEAPON = {
		{ e = 249, spell = 7786, level = 0, ways = { { "X", "Enchanting", 333, 90, 0, "from a recipe", 0 } } },
		{ e = 250, spell = 7788, level = 0, ways = { { "X", "Enchanting", 333, 90, 0, "from a trainer", 0 } } },
		{ e = 803, spell = 13898, level = 0, ways = { { "X", "Enchanting", 333, 265, 0, "recipe drops in Blackrock Depths", 230 } } },
		{ e = 805, spell = 13943, level = 0, ways = { { "X", "Enchanting", 333, 245, 0, "from a trainer", 0 } } },
		{ e = 853, spell = 13653, level = 0, ways = { { "X", "Enchanting", 333, 175, 0, "from a recipe", 0 } } },
		{ e = 854, spell = 13655, level = 0, ways = { { "X", "Enchanting", 333, 175, 0, "from a recipe", 0 } } },
		{ e = 912, spell = 13915, level = 0, ways = { { "X", "Enchanting", 333, 230, 0, "recipe drops in Stratholme", 329 } } },
		{ e = 1894, spell = 20029, level = 0, ways = { { "X", "Enchanting", 333, 285, 0, "from a recipe", 0 } } },
		{ e = 1898, spell = 20032, level = 0, ways = { { "X", "Enchanting", 333, 300, 0, "recipe drops in Scholomance", 289 } } },
		{ e = 1899, spell = 20033, level = 0, ways = { { "X", "Enchanting", 333, 295, 0, "recipe drops in Stratholme", 329 } } },
		{ e = 1900, spell = 20034, level = 0, ways = { { "X", "Enchanting", 333, 300, 0, "from a recipe", 0 } } },
		{ e = 2443, spell = 21931, level = 0, ways = { { "X", "Enchanting", 333, 190, 0, "from a recipe", 0 } } },
		{ e = 2504, spell = 22749, level = 0, ways = { { "X", "Enchanting", 333, 300, 0, "recipe drops in Molten Core", 409 } } },
		{ e = 2505, spell = 22750, level = 0, ways = { { "X", "Enchanting", 333, 300, 0, "recipe drops in Molten Core", 409 } } },
		{ e = 2563, spell = 23799, level = 0, ways = { { "X", "Enchanting", 333, 290, 0, "from a recipe", 0 } } },
		{ e = 2564, spell = 23800, level = 0, ways = { { "X", "Enchanting", 333, 290, 0, "recipe sold by Meilosh (Honored)", 0 } } },
		{ e = 2567, spell = 23803, level = 0, ways = { { "X", "Enchanting", 333, 300, 0, "from a recipe", 0 } } },
		{ e = 2568, spell = 23804, level = 0, ways = { { "X", "Enchanting", 333, 300, 0, "from a recipe", 0 } } },
		{ e = 36, item = 5421, level = 0, classes = 0 },
		{ e = 37, item = 6041, level = 0, classes = 0 },
		{ e = 846, item = 19971, level = 0, classes = 0 },
	},
	WRIST = {
		{ e = 66, spell = 7457, level = 0, ways = { { "X", "Enchanting", 333, 50, 0, "from a trainer", 0 } } },
		{ e = 243, spell = 7766, level = 0, ways = { { "X", "Enchanting", 333, 60, 0, "from a recipe", 0 } } },
		{ e = 247, spell = 7779, level = 0, ways = { { "X", "Enchanting", 333, 80, 0, "from a trainer", 0 } } },
		{ e = 248, spell = 7782, level = 0, ways = { { "X", "Enchanting", 333, 80, 0, "from a recipe", 0 } } },
		{ e = 724, spell = 13501, level = 0, ways = { { "X", "Enchanting", 333, 130, 0, "from a trainer", 0 } } },
		{ e = 823, spell = 13536, level = 0, ways = { { "X", "Enchanting", 333, 140, 0, "recipe sold by Dalria", 0 } } },
		{ e = 851, spell = 13642, level = 0, ways = { { "X", "Enchanting", 333, 165, 0, "from a trainer", 0 } } },
		{ e = 852, spell = 13648, level = 0, ways = { { "X", "Enchanting", 333, 170, 0, "from a trainer", 0 } } },
		{ e = 856, spell = 13661, level = 0, ways = { { "X", "Enchanting", 333, 180, 0, "from a trainer", 0 } } },
		{ e = 905, spell = 13822, level = 0, ways = { { "X", "Enchanting", 333, 210, 0, "from a trainer", 0 } } },
		{ e = 907, spell = 13846, level = 0, ways = { { "X", "Enchanting", 333, 220, 0, "recipe drops in Uldaman", 70 } } },
		{ e = 923, spell = 13931, level = 0, ways = { { "X", "Enchanting", 333, 235, 0, "recipe sold by Banalash", 0 } } },
		{ e = 924, spell = 7428, level = 0, ways = { { "X", "Enchanting", 333, 20, 0, "from a trainer", 0 } } },
		{ e = 925, spell = 13646, level = 0, ways = { { "X", "Enchanting", 333, 170, 0, "recipe sold by Micha Yance", 0 } } },
		{ e = 927, spell = 13939, level = 0, ways = { { "X", "Enchanting", 333, 240, 0, "from a trainer", 0 } } },
		{ e = 929, spell = 13945, level = 0, ways = { { "X", "Enchanting", 333, 245, 0, "recipe drops in Stratholme", 329 } } },
		{ e = 1883, spell = 20008, level = 0, ways = { { "X", "Enchanting", 333, 255, 0, "from a recipe", 0 } } },
		{ e = 1884, spell = 20009, level = 0, ways = { { "X", "Enchanting", 333, 270, 0, "from a recipe", 0 } } },
		{ e = 1885, spell = 20010, level = 0, ways = { { "X", "Enchanting", 333, 295, 0, "from a recipe", 0 } } },
		{ e = 1886, spell = 20011, level = 0, ways = { { "X", "Enchanting", 333, 300, 0, "recipe drops in Blackrock Depths", 230 } } },
		{ e = 2565, spell = 23801, level = 0, ways = { { "X", "Enchanting", 333, 290, 0, "recipe sold by Argent Quartermaster Hasana (Honored)", 0 } } },
		{ e = 2650, spell = 23802, level = 0, ways = { { "X", "Enchanting", 333, 300, 0, "recipe sold by Argent Quartermaster Hasana (Revered)", 0 } } },
	},
}

G.enchantStats = {
	[15] = { armor = 8 }, -- Reinforced (+8 Armor)
	[16] = { armor = 16 }, -- Reinforced (+16 Armor)
	[17] = { armor = 24 }, -- Reinforced (+24 Armor)
	[18] = { armor = 32 }, -- Reinforced (+32 Armor)
	[24] = {  }, -- +5 Mana
	[30] = { wdmg = 1 }, -- Scope (+1 Damage)
	[32] = { wdmg = 2 }, -- Scope (+2 Damage)
	[33] = { wdmg = 3 }, -- Scope (+3 Damage)
	[34] = { haste = 20 }, -- Counterweight (+20 Haste Rating)
	[36] = {  }, -- Enchant: Fiery Blaze
	[37] = {  }, -- Steel Weapon Chain
	[41] = {  }, -- +5 Health
	[43] = {  }, -- Iron Spike (8-12)
	[44] = {  }, -- Absorption (10)
	[63] = {  }, -- Absorption (25)
	[65] = {  }, -- +1 All Resistances
	[66] = { sta = 1 }, -- +1 Stamina
	[241] = { wdmg = 2 }, -- +2 Weapon Damage
	[242] = {  }, -- +15 Health
	[243] = { spi = 1 }, -- +1 Spirit
	[246] = {  }, -- +20 Mana
	[247] = { agi = 1 }, -- +1 Agility
	[248] = { str = 1 }, -- +1 Strength
	[249] = {  }, -- +2 Beastslaying
	[250] = { wdmg = 1 }, -- +1  Weapon Damage
	[254] = {  }, -- +25 Health
	[255] = { spi = 3 }, -- +3 Spirit
	[256] = {  }, -- +5 Fire Resistance
	[463] = {  }, -- Mithril Spike (16-20)
	[464] = {  }, -- +4% Mount Speed
	[663] = { wdmg = 5 }, -- Scope (+5 Damage)
	[664] = { wdmg = 7 }, -- Scope (+7 Damage)
	[723] = { int = 3 }, -- +3 Intellect
	[724] = { sta = 3 }, -- +3 Stamina
	[744] = { armor = 20 }, -- +20 Armor
	[783] = { armor = 10 }, -- +10 Armor
	[803] = { proc = 1 }, -- Fiery Weapon
	[804] = {  }, -- +10 Shadow Resistance
	[805] = { wdmg = 4 }, -- +4 Weapon Damage
	[823] = { str = 3 }, -- +3 Strength
	[843] = {  }, -- +30 Mana
	[844] = {  }, -- +2 Mining
	[845] = {  }, -- +2 Herbalism
	[846] = {  }, -- +5 Fishing
	[847] = { agi = 1, int = 1, spi = 1, sta = 1, str = 1 }, -- +1 All Stats
	[848] = { armor = 30 }, -- +30 Armor
	[849] = { agi = 3 }, -- +3 Agility
	[850] = {  }, -- +35 Health
	[851] = { spi = 5 }, -- +5 Spirit
	[852] = { sta = 5 }, -- +5 Stamina
	[853] = {  }, -- +6 Beastslaying
	[854] = {  }, -- +6 Elemental Slayer
	[856] = { str = 5 }, -- +5 Strength
	[857] = {  }, -- +50 Mana
	[863] = { block = 10 }, -- +10 Shield Block Rating
	[865] = {  }, -- +5 Skinning
	[866] = { agi = 2, int = 2, spi = 2, sta = 2, str = 2 }, -- +2 All Stats
	[884] = { armor = 50 }, -- +50 Armor
	[903] = {  }, -- +3 All Resistances
	[904] = { agi = 5 }, -- +5 Agility
	[905] = { int = 5 }, -- +5 Intellect
	[906] = {  }, -- +5 Mining
	[907] = { spi = 7 }, -- +7 Spirit
	[908] = {  }, -- +50 Health
	[909] = {  }, -- +5 Herbalism
	[911] = {  }, -- Minor Speed Increase
	[912] = {  }, -- Demonslaying
	[913] = {  }, -- +65 Mana
	[923] = { def = 5 }, -- +5 Defense Rating
	[924] = { def = 2 }, -- +2 Defense Rating
	[925] = { def = 3 }, -- +3 Defense Rating
	[926] = {  }, -- +8 Frost Resistance
	[927] = { str = 7 }, -- +7 Strength
	[928] = { agi = 3, int = 3, spi = 3, sta = 3, str = 3 }, -- +3 All Stats
	[929] = { sta = 7 }, -- +7 Stamina
	[930] = {  }, -- +2% Mount Speed
	[931] = { haste = 10 }, -- +10 Haste Rating
	[943] = { wdmg = 3 }, -- +3 Weapon Damage
	[963] = { wdmg = 7 }, -- +7 Weapon Damage
	[1483] = {  }, -- +150 Mana
	[1503] = {  }, -- +100 Health
	[1504] = { armor = 125 }, -- +125 Armor
	[1505] = {  }, -- +20 Fire Resistance
	[1506] = { str = 8 }, -- +8 Strength
	[1507] = { sta = 8 }, -- +8 Stamina
	[1508] = { agi = 8 }, -- +8 Agility
	[1509] = { int = 8 }, -- +8 Intellect
	[1510] = { spi = 8 }, -- +8 Spirit
	[1704] = {  }, -- Thorium Spike (20-30)
	[1843] = { armor = 40 }, -- Reinforced (+40 Armor)
	[1883] = { int = 7 }, -- +7 Intellect
	[1884] = { spi = 9 }, -- +9 Spirit
	[1885] = { str = 9 }, -- +9 Strength
	[1886] = { sta = 9 }, -- +9 Stamina
	[1887] = { agi = 7 }, -- +7 Agility
	[1888] = {  }, -- +5 All Resistances
	[1889] = { armor = 70 }, -- +70 Armor
	[1890] = { mp5 = 4 }, -- +4 Mana and Health every 5 sec
	[1891] = { agi = 4, int = 4, spi = 4, sta = 4, str = 4 }, -- +4 All Stats
	[1892] = { sta = 10 }, -- +100 Health
	[1893] = {  }, -- +100 Mana
	[1894] = {  }, -- Icy Weapon
	[1896] = { wdmg = 9 }, -- +9 Weapon Damage
	[1897] = { wdmg = 5 }, -- +5 Weapon Damage
	[1898] = {  }, -- Lifestealing
	[1899] = {  }, -- Unholy Weapon
	[1900] = { proc = 1 }, -- Crusader
	[1903] = { spi = 9 }, -- +9 Spirit
	[1904] = { int = 9 }, -- +9 Intellect
	[2443] = { frost = 7 }, -- +7 Frost Spell Damage
	[2463] = {  }, -- +7 Fire Resistance
	[2483] = {  }, -- +5 Fire Resistance
	[2484] = {  }, -- +5 Frost Resistance
	[2485] = {  }, -- +5 Arcane Resistance
	[2486] = {  }, -- +5 Nature Resistance
	[2487] = {  }, -- +5 Shadow Resistance
	[2488] = {  }, -- +5 All Resistances
	[2503] = { def = 5 }, -- +5 Defense Rating
	[2504] = { sp = 30 }, -- +30 Spell Power
	[2505] = { sp = 29 }, -- +29 Spell Power
	[2523] = { mhit = 30 }, -- +30 Ranged Hit Rating
	[2543] = { haste = 10 }, -- +10 Haste Rating
	[2544] = { sp = 8 }, -- +8 Spell Power
	[2545] = { dodge = 12 }, -- +12 Dodge Rating
	[2563] = { str = 15 }, -- +15 Strength
	[2564] = { agi = 15 }, -- +15 Agility
	[2565] = { mp5 = 5 }, -- Mana Regen 5 per 5 sec.
	[2567] = { spi = 20 }, -- +20 Spirit
	[2568] = { int = 22 }, -- +22 Intellect
	[2583] = { bv = 30, def = 10, sta = 10 }, -- +10 Defense Rating +10 Stamina +30 Block Value
	[2584] = { def = 10, sp = 12, sta = 10 }, -- +10 Defense +10 Stamina and +12 Spell Power
	[2587] = { int = 15, sp = 13 }, -- +13 Spell Power and +15 Intellect
	[2588] = { hit = 8, sp = 18 }, -- +18 Spell Power and +8 Hit Rating
	[2589] = { sp = 18, sta = 10 }, -- +18 Spell Power and +10 Stamina
	[2590] = { mp5 = 5, sp = 13, sta = 10 }, -- +13 Spell Power +10 Stamina and +5 Mana every 5 seconds
	[2591] = { int = 10, sp = 12, sta = 10 }, -- +10 Intellect +10 Stamina +12 Spell Power
	[2603] = {  }, -- +2 Fishing
	[2604] = { sp = 18 }, -- +18 Spell Power
	[2605] = { sp = 18 }, -- +18 Spell Power
	[2606] = { ap = 30 }, -- +30 Attack Power
	[2614] = { shadow = 20 }, -- +20 Shadow Spell Power
	[2615] = { frost = 20 }, -- +20 Frost Spell Power
	[2616] = { fire = 20 }, -- +20 Fire Spell Power
	[2617] = { sp = 16 }, -- +16 Spell Power
	[2619] = {  }, -- +15 Fire Resistance
	[2620] = {  }, -- +15 Nature Resistance
	[2650] = { sp = 15 }, -- +15 Spell Power
	[2681] = {  }, -- +10 Nature Resistance
	[2682] = {  }, -- +10 Frost Resistance
	[2683] = {  }, -- +10 Shadow Resistance
	[2715] = { mp5 = 6, sp = 16 }, -- +16 Spell Power and 6 Mana every 5 seconds
	[2716] = { armor = 100, sta = 16 }, -- +16 Stamina and +100 Armor
	[2717] = { ap = 26, crit = 14 }, -- +26 Attack Power and +14 Critical Strike Rating
	[2721] = { crit = 14, sp = 15 }, -- +15 Spell Power and +14 Critical Strike Rating
	[3754] = { ap = 24, hit = 10, sta = 10 }, -- +24 Attack Power +10 Stamina +10 Hit Rating
	[3755] = { ap = 28, dodge = 12 }, -- +28 Attack Power +12 Dodge Rating
}

G.enchantNames = {
	[15] = "Reinforced (+8 Armor)",
	[16] = "Reinforced (+16 Armor)",
	[17] = "Reinforced (+24 Armor)",
	[18] = "Reinforced (+32 Armor)",
	[24] = "+5 Mana",
	[30] = "Scope (+1 Damage)",
	[32] = "Scope (+2 Damage)",
	[33] = "Scope (+3 Damage)",
	[34] = "Counterweight (+20 Haste Rating)",
	[36] = "Enchant: Fiery Blaze",
	[37] = "Steel Weapon Chain",
	[41] = "+5 Health",
	[43] = "Iron Spike (8-12)",
	[44] = "Absorption (10)",
	[63] = "Absorption (25)",
	[65] = "+1 All Resistances",
	[66] = "+1 Stamina",
	[241] = "+2 Weapon Damage",
	[242] = "+15 Health",
	[243] = "+1 Spirit",
	[246] = "+20 Mana",
	[247] = "+1 Agility",
	[248] = "+1 Strength",
	[249] = "+2 Beastslaying",
	[250] = "+1  Weapon Damage",
	[254] = "+25 Health",
	[255] = "+3 Spirit",
	[256] = "+5 Fire Resistance",
	[463] = "Mithril Spike (16-20)",
	[464] = "+4% Mount Speed",
	[663] = "Scope (+5 Damage)",
	[664] = "Scope (+7 Damage)",
	[723] = "+3 Intellect",
	[724] = "+3 Stamina",
	[744] = "+20 Armor",
	[783] = "+10 Armor",
	[803] = "Fiery Weapon",
	[804] = "+10 Shadow Resistance",
	[805] = "+4 Weapon Damage",
	[823] = "+3 Strength",
	[843] = "+30 Mana",
	[844] = "+2 Mining",
	[845] = "+2 Herbalism",
	[846] = "+5 Fishing",
	[847] = "+1 All Stats",
	[848] = "+30 Armor",
	[849] = "+3 Agility",
	[850] = "+35 Health",
	[851] = "+5 Spirit",
	[852] = "+5 Stamina",
	[853] = "+6 Beastslaying",
	[854] = "+6 Elemental Slayer",
	[856] = "+5 Strength",
	[857] = "+50 Mana",
	[863] = "+10 Shield Block Rating",
	[865] = "+5 Skinning",
	[866] = "+2 All Stats",
	[884] = "+50 Armor",
	[903] = "+3 All Resistances",
	[904] = "+5 Agility",
	[905] = "+5 Intellect",
	[906] = "+5 Mining",
	[907] = "+7 Spirit",
	[908] = "+50 Health",
	[909] = "+5 Herbalism",
	[911] = "Minor Speed Increase",
	[912] = "Demonslaying",
	[913] = "+65 Mana",
	[923] = "+5 Defense Rating",
	[924] = "+2 Defense Rating",
	[925] = "+3 Defense Rating",
	[926] = "+8 Frost Resistance",
	[927] = "+7 Strength",
	[928] = "+3 All Stats",
	[929] = "+7 Stamina",
	[930] = "+2% Mount Speed",
	[931] = "+10 Haste Rating",
	[943] = "+3 Weapon Damage",
	[963] = "+7 Weapon Damage",
	[1483] = "+150 Mana",
	[1503] = "+100 Health",
	[1504] = "+125 Armor",
	[1505] = "+20 Fire Resistance",
	[1506] = "+8 Strength",
	[1507] = "+8 Stamina",
	[1508] = "+8 Agility",
	[1509] = "+8 Intellect",
	[1510] = "+8 Spirit",
	[1704] = "Thorium Spike (20-30)",
	[1843] = "Reinforced (+40 Armor)",
	[1883] = "+7 Intellect",
	[1884] = "+9 Spirit",
	[1885] = "+9 Strength",
	[1886] = "+9 Stamina",
	[1887] = "+7 Agility",
	[1888] = "+5 All Resistances",
	[1889] = "+70 Armor",
	[1890] = "+4 Mana and Health every 5 sec",
	[1891] = "+4 All Stats",
	[1892] = "+100 Health",
	[1893] = "+100 Mana",
	[1894] = "Icy Weapon",
	[1896] = "+9 Weapon Damage",
	[1897] = "+5 Weapon Damage",
	[1898] = "Lifestealing",
	[1899] = "Unholy Weapon",
	[1900] = "Crusader",
	[1903] = "+9 Spirit",
	[1904] = "+9 Intellect",
	[2443] = "+7 Frost Spell Damage",
	[2463] = "+7 Fire Resistance",
	[2483] = "+5 Fire Resistance",
	[2484] = "+5 Frost Resistance",
	[2485] = "+5 Arcane Resistance",
	[2486] = "+5 Nature Resistance",
	[2487] = "+5 Shadow Resistance",
	[2488] = "+5 All Resistances",
	[2503] = "+5 Defense Rating",
	[2504] = "+30 Spell Power",
	[2505] = "+29 Spell Power",
	[2523] = "+30 Ranged Hit Rating",
	[2543] = "+10 Haste Rating",
	[2544] = "+8 Spell Power",
	[2545] = "+12 Dodge Rating",
	[2563] = "+15 Strength",
	[2564] = "+15 Agility",
	[2565] = "Mana Regen 5 per 5 sec.",
	[2567] = "+20 Spirit",
	[2568] = "+22 Intellect",
	[2583] = "+10 Defense Rating +10 Stamina +30 Block Value",
	[2584] = "+10 Defense +10 Stamina and +12 Spell Power",
	[2587] = "+13 Spell Power and +15 Intellect",
	[2588] = "+18 Spell Power and +8 Hit Rating",
	[2589] = "+18 Spell Power and +10 Stamina",
	[2590] = "+13 Spell Power +10 Stamina and +5 Mana every 5 seconds",
	[2591] = "+10 Intellect +10 Stamina +12 Spell Power",
	[2603] = "+2 Fishing",
	[2604] = "+18 Spell Power",
	[2605] = "+18 Spell Power",
	[2606] = "+30 Attack Power",
	[2614] = "+20 Shadow Spell Power",
	[2615] = "+20 Frost Spell Power",
	[2616] = "+20 Fire Spell Power",
	[2617] = "+16 Spell Power",
	[2619] = "+15 Fire Resistance",
	[2620] = "+15 Nature Resistance",
	[2650] = "+15 Spell Power",
	[2681] = "+10 Nature Resistance",
	[2682] = "+10 Frost Resistance",
	[2683] = "+10 Shadow Resistance",
	[2715] = "+16 Spell Power and 6 Mana every 5 seconds",
	[2716] = "+16 Stamina and +100 Armor",
	[2717] = "+26 Attack Power and +14 Critical Strike Rating",
	[2721] = "+15 Spell Power and +14 Critical Strike Rating",
	[3754] = "+24 Attack Power +10 Stamina +10 Hit Rating",
	[3755] = "+28 Attack Power +12 Dodge Rating",
}

G.enchantProcs = {
	[803] = { ROGUE_DAGGERS = 12, ROGUE_SWORDS = 12 }, -- Fiery Weapon
	[1900] = { ROGUE_DAGGERS = 35, ROGUE_SWORDS = 35 }, -- Crusader
}

G.glyphs = {
	ROGUE_SWORDS = {
		major = {
			{ 42973, 56810, 235, 0, 15, "", "Glyph of Slice and Dice" },
			{ 42972, 56821, 210, 0, 15, "", "Glyph of Sinister Strike" },
			{ 42961, 56802, 105, 0, 15, "", "Glyph of Eviscerate" },
			{ 42962, 56803, 120, 0, 15, "", "Glyph of Expose Armor" },
			{ 42960, 56799, 95, 0, 15, "", "Glyph of Evasion" },
		},
		minor = {
			{ 43380, 58038, 125, 0, 22, "", "Glyph of Vanish" },
			{ 43378, 58033, 200, 0, 40, "", "Glyph of Safe Fall" },
			{ 43376, 58032, 125, 0, 22, "", "Glyph of Distract" },
			{ 43379, 58039, 75, 0, 15, "", "Glyph of Blurred Speed" },
			{ 43343, 58017, 75, 0, 15, "", "Glyph of Pick Pocket" },
		},
	},
	ROGUE_DAGGERS = {
		major = {
			{ 45768, 63268, 255, 0, 50, "Mutilate", "Glyph of Mutilate" },
			{ 42973, 56810, 235, 0, 15, "", "Glyph of Slice and Dice" },
			{ 42961, 56802, 105, 0, 15, "", "Glyph of Eviscerate" },
			{ 42956, 56800, 80, 0, 15, "", "Glyph of Backstab" },
			{ 42964, 56812, 135, 0, 15, "", "Glyph of Garrote" },
			{ 42960, 56799, 95, 0, 15, "", "Glyph of Evasion" },
		},
		minor = {
			{ 43380, 58038, 125, 0, 22, "", "Glyph of Vanish" },
			{ 43378, 58033, 200, 0, 40, "", "Glyph of Safe Fall" },
			{ 43376, 58032, 125, 0, 22, "", "Glyph of Distract" },
			{ 43379, 58039, 75, 0, 15, "", "Glyph of Blurred Speed" },
			{ 43343, 58017, 75, 0, 15, "", "Glyph of Pick Pocket" },
		},
	},
	PRIEST_HEAL = {
		major = {
			{ 42409, 55680, 385, 13, 30, "", "Glyph of Prayer of Healing" },
			{ 42408, 55672, 80, 0, 15, "", "Glyph of Power Word: Shield" },
			{ 42400, 55679, 120, 0, 20, "", "Glyph of Flash Heal" },
			{ 42411, 55674, 160, 0, 15, "", "Glyph of Renew" },
			{ 42399, 55678, 270, 0, 20, "", "Glyph of Fear Ward" },
			{ 42402, 55686, 135, 0, 15, "", "Glyph of Inner Fire" },
		},
		minor = {
			{ 43371, 58009, 75, 0, 15, "", "Glyph of Fortitude" },
			{ 43342, 57985, 75, 0, 15, "", "Glyph of Fading" },
			{ 43370, 57987, 175, 0, 34, "", "Glyph of Levitate" },
			{ 43372, 58015, 150, 0, 30, "", "Glyph of Shadow Protection" },
		},
	},
	PRIEST_SHADOW = {
		major = {
			{ 42407, 55689, 385, 13, 20, "Shadowform", "Glyph of Shadow" },
			{ 42415, 55687, 180, 0, 20, "", "Glyph of Mind Flay" },
			{ 42406, 55681, 350, 8, 15, "", "Glyph of Shadow Word: Pain" },
			{ 42398, 55684, 105, 0, 15, "", "Glyph of Fade" },
			{ 42402, 55686, 135, 0, 15, "", "Glyph of Inner Fire" },
		},
		minor = {
			{ 43371, 58009, 75, 0, 15, "", "Glyph of Fortitude" },
			{ 43372, 58015, 150, 0, 30, "", "Glyph of Shadow Protection" },
			{ 43342, 57985, 75, 0, 15, "", "Glyph of Fading" },
			{ 43370, 57987, 175, 0, 34, "", "Glyph of Levitate" },
		},
	},
}

G.consumables = {
	ROGUE_SWORDS = {
		{ 8928, "Put it on your main hand." }, -- Instant Poison VI
		{ 20844, "Put it on your off hand." }, -- Deadly Poison V
		{ 13452, "" }, -- Elixir of the Mongoose
		{ 12451, "A repeatable quest: 3 for every 3 Winterfall E'ko, which Winterfall furbolgs drop. Doesn't stack with Elixir of Giants." }, -- Juju Power
		{ 12820, "Drops from Winterfall furbolgs in Winterspring." }, -- Winterfall Firewater
		{ 13928, "" }, -- Grilled Squid
		{ 7676, "" }, -- Thistle Tea
		{ 13446, "" }, -- Major Healing Potion
	},
	ROGUE_DAGGERS = {
		{ 20844, "Put it on your main hand." }, -- Deadly Poison V
		{ 8928, "Put it on your off hand." }, -- Instant Poison VI
		{ 13452, "" }, -- Elixir of the Mongoose
		{ 12451, "A repeatable quest: 3 for every 3 Winterfall E'ko, which Winterfall furbolgs drop. Doesn't stack with Elixir of Giants." }, -- Juju Power
		{ 12820, "Drops from Winterfall furbolgs in Winterspring." }, -- Winterfall Firewater
		{ 13928, "" }, -- Grilled Squid
		{ 7676, "" }, -- Thistle Tea
		{ 13446, "" }, -- Major Healing Potion
	},
	PRIEST_HEAL = {
		{ 13511, "" }, -- Flask of Distilled Wisdom
		{ 20748, "Put it on your weapon." }, -- Brilliant Mana Oil
		{ 20007, "" }, -- Mageblood Elixir
		{ 13931, "" }, -- Nightfin Soup
		{ 13444, "" }, -- Major Mana Potion
		{ 12662, "Costs some health." }, -- Demonic Rune
	},
	PRIEST_SHADOW = {
		{ 13512, "" }, -- Flask of Supreme Power
		{ 13454, "" }, -- Greater Arcane Elixir
		{ 9264, "" }, -- Elixir of Shadow Power
		{ 20749, "Put it on your weapon." }, -- Brilliant Wizard Oil
		{ 18254, "" }, -- Runn Tum Tuber Surprise
		{ 13444, "" }, -- Major Mana Potion
		{ 12662, "Costs some health." }, -- Demonic Rune
	},
}

G.professionConsumables = {
	[202] = { -- Engineering
		{ 10646, 205, "A big burst of fire damage around you; it hurts you too." }, -- Goblin Sapper Charge
		{ 18641, 250, "Thrown fire damage in an area." }, -- Dense Dynamite
		{ 15993, 260, "Thrown damage in an area that stuns for 3 seconds." }, -- Thorium Grenade
	},
}

G.extraItems = {
	[2304] = { "Light Armor Kit", 1, 1, { { "D", 70, 0.25, "Olaf" } } },
	[2313] = { "Medium Armor Kit", 1, 5, { { "D", 70, 0.25, "Olaf" }, { "Q", 125, "The Lost Tools", 0, 0, 1101, 16, 15, { 125, "The Lost Tools", 1, 0, 1 }, { 125, "The Lost Tools", 1, 0, 1 }, 0 }, { "Q", 448, "Report to Hadrec", 0, 0, 0, 16, 10, { 437, "The Dead Fields", 1, 0, 6 }, { 437, "The Dead Fields", 1, 0, 6 }, 0 }, { "X", "Crafted: Leatherworking", 165, 100, 0, "from a trainer", 0 } } },
	[4265] = { "Heavy Armor Kit", 1, 20, { { "D", 70, 0.25, "Olaf" }, { "Q", 4767, "Wind Rider", 0, 0, 690, 29, 25, { 4767, "Wind Rider", 1, 0, 1 }, { 4767, "Wind Rider", 1, 0, 1 }, 0 }, { "X", "Crafted: Leatherworking", 165, 150, 0, "from a trainer", 0 } } },
	[4405] = { "Crude Scope", 1, 5, { { "X", "Crafted: Engineering", 202, 60, 0, "from a trainer", 0 } } },
	[4406] = { "Standard Scope", 1, 10, { { "X", "Crafted: Engineering", 202, 110, 0, "from a trainer", 0 } } },
	[4407] = { "Accurate Scope", 1, 20, { { "X", "Crafted: Engineering", 202, 180, 0, "recipe sold by Mazk Snipeshot", 0 } } },
	[5421] = { "Fiery Blaze Enchantment", 1, 0, { { "Q", 706, "Fiery Blaze Enchantments", 0, 0, 1101, 45, 40, { 706, "Fiery Blaze Enchantments", 1, 0, 1 }, { 706, "Fiery Blaze Enchantments", 1, 0, 1 }, 0 } } },
	[6041] = { "Steel Weapon Chain", 1, 0, { { "X", "Crafted: Blacksmithing", 164, 190, 0, "from a recipe", 0 } } },
	[6042] = { "Iron Shield Spike", 1, 0, { { "X", "Crafted: Blacksmithing", 164, 150, 0, "from a recipe", 0 } } },
	[6043] = { "Iron Counterweight", 1, 0, { { "X", "Crafted: Blacksmithing", 164, 165, 0, "from a recipe", 0 } } },
	[7676] = { "Thistle Tea", 1, 5, { { "Q", 2358, "Horns of Nez'ra", 0, 0, 0, 22, 16, { 2358, "Horns of Nez'ra", 1, 0, 1 }, { 2358, "Horns of Nez'ra", 1, 0, 1 }, 8 }, { "Q", 2381, "Plundering the Plunderers", 0, 0, 690, 18, 16, { 2381, "Plundering the Plunderers", 1, 0, 1 }, { 2378, "Find the Shattered Hand", 1, 0, 4 }, 8 }, { "X", "Crafted: Cooking", 185, 60, 0, "recipe from the quest Klaven's Tower", 0 } } },
	[7967] = { "Mithril Shield Spike", 2, 0, { { "X", "Crafted: Blacksmithing", 164, 215, 1, "recipe drops in Onyxia's Lair", 249 } } },
	[7969] = { "Mithril Spurs", 2, 0, { { "X", "Crafted: Blacksmithing", 164, 235, 0, "recipe drops in Uldaman", 70 } } },
	[8173] = { "Thick Armor Kit", 1, 30, { { "D", 70, 0.25, "Olaf" }, { "Q", 338, "The Green Hills of Stranglethorn", 0, 0, 0, 40, 30, { 583, "Welcome to the Jungle", 1, 0, 2 }, { 583, "Welcome to the Jungle", 1, 0, 2 }, 0 }, { "X", "Crafted: Leatherworking", 165, 200, 0, "from a trainer", 0 } } },
	[8928] = { "Instant Poison VI", 1, 60, { { "V", "Jasper Fel <Shady Dealer>", 500, 0, 0, 0 }, { "V", "Sloan McCoy <Poison Supplier>", 500, 0, 0, 0 }, { "V", "Samor Festivus <Shady Dealer>", 500, 0, 0, 0 }, { "V", "Sly Garrett <Shady Goods>", 500, 0, 0, 0 }, { "V", "Gerald Crawley <Poison Supplier>", 500, 0, 0, 0 }, { "V", "Malissa <Poison Supplier>", 500, 0, 0, 0 }, { "V", "Rekkul <Poison Vendor>", 500, 0, 0, 0 }, { "V", "Hula'mahi <Reagents and Herbs>", 500, 0, 0, 0 }, { "V", "Jaysin Lanyda <Poisons & Reagents>", 500, 0, 0, 0 }, { "V", "Patrice Dwyer <Poison Supplies>", 500, 0, 0, 0 }, { "V", "Kyrai <Poison Vendor>", 500, 0, 0, 0 }, { "V", "Fahran Silentblade <Tools & Supplies>", 500, 0, 0, 0 }, { "V", "Ezekiel Graves <Poison Vendor>", 500, 0, 0, 0 }, { "V", "Tynnus Venomsprout <Shady Dealer>", 500, 0, 0, 0 }, { "V", "Smudge Thunderwood <Poison Vendor>", 500, 0, 0, 0 }, { "V", "Khur Hornstriker <Reagent Vendor>", 500, 0, 0, 0 }, { "V", "Bortega <Reagents & Poison Supplies>", 500, 0, 0, 0 }, { "V", "Miles Sidney <Poison Supplies>", 500, 0, 0, 0 } } },
	[9264] = { "Elixir of Shadow Power", 1, 40, { { "X", "Crafted: Alchemy", 171, 250, 0, "recipe sold by Maria Lumere", 0 } } },
	[10546] = { "Deadly Scope", 1, 30, { { "X", "Crafted: Engineering", 202, 210, 0, "recipe sold by Knaz Blunderflame", 0 } } },
	[10548] = { "Sniper Scope", 1, 40, { { "X", "Crafted: Engineering", 202, 240, 1, "recipe drops in Onyxia's Lair", 249 } } },
	[10646] = { "Goblin Sapper Charge", 1, 0, { { "X", "Crafted: Engineering", 202, 205, 0, "from a trainer", 0 } } },
	[11622] = { "Lesser Arcanum of Rumination", 2, 0, { { "Q", 4463, "Libram of Rumination", 0, 0, 0, 55, 50, { 4463, "Libram of Rumination", 1, 0, 1 }, { 4463, "Libram of Rumination", 1, 0, 1 }, 0 } } },
	[11642] = { "Lesser Arcanum of Constitution", 2, 0, { { "Q", 4481, "Libram of Constitution", 0, 0, 0, 55, 50, { 4481, "Libram of Constitution", 1, 0, 1 }, { 4481, "Libram of Constitution", 1, 0, 1 }, 0 } } },
	[11643] = { "Lesser Arcanum of Tenacity", 2, 0, { { "Q", 4482, "Libram of Tenacity", 0, 0, 0, 55, 50, { 4482, "Libram of Tenacity", 1, 0, 1 }, { 4482, "Libram of Tenacity", 1, 0, 1 }, 0 } } },
	[11644] = { "Lesser Arcanum of Resilience", 2, 0, { { "Q", 4483, "Libram of Resilience", 0, 0, 0, 55, 50, { 4483, "Libram of Resilience", 1, 0, 1 }, { 4483, "Libram of Resilience", 1, 0, 1 }, 0 } } },
	[11645] = { "Lesser Arcanum of Voracity", 2, 0, { { "Q", 4484, "Libram of Voracity", 0, 0, 0, 55, 50, { 4484, "Libram of Voracity", 1, 0, 1 }, { 4484, "Libram of Voracity", 1, 0, 1 }, 0 } } },
	[11646] = { "Lesser Arcanum of Voracity", 2, 0, { { "Q", 4484, "Libram of Voracity", 0, 0, 0, 55, 50, { 4484, "Libram of Voracity", 1, 0, 1 }, { 4484, "Libram of Voracity", 1, 0, 1 }, 0 } } },
	[11647] = { "Lesser Arcanum of Voracity", 2, 0, { { "Q", 4484, "Libram of Voracity", 0, 0, 0, 55, 50, { 4484, "Libram of Voracity", 1, 0, 1 }, { 4484, "Libram of Voracity", 1, 0, 1 }, 0 } } },
	[11648] = { "Lesser Arcanum of Voracity", 2, 0, { { "Q", 4484, "Libram of Voracity", 0, 0, 0, 55, 50, { 4484, "Libram of Voracity", 1, 0, 1 }, { 4484, "Libram of Voracity", 1, 0, 1 }, 0 } } },
	[11649] = { "Lesser Arcanum of Voracity", 2, 0, { { "Q", 4484, "Libram of Voracity", 0, 0, 0, 55, 50, { 4484, "Libram of Voracity", 1, 0, 1 }, { 4484, "Libram of Voracity", 1, 0, 1 }, 0 } } },
	[12451] = { "Juju Power", 1, 0, { { "Q", 4802, "Winterfall E'ko", 0, 0, 0, 60, 55, { 969, "Luck Be With You", 1, 0, 3 }, { 969, "Luck Be With You", 1, 0, 3 }, 0 } } },
	[12645] = { "Thorium Shield Spike", 2, 0, { { "X", "Crafted: Blacksmithing", 164, 275, 0, "from a recipe", 0 } } },
	[12662] = { "Demonic Rune", 2, 0, { { "D", 229, 0.1, "Burning Felguard" }, { "D", 309, 0.163, "Mad Servant" }, { "D", 429, 0.52, "Wildspawn Trickster, Wildspawn Rogue, Wildspawn Shadowstalker and others" }, { "D", 329, 0.08, "Balnazzar" } } },
	[12820] = { "Winterfall Firewater", 1, 45, {  } },
	[13444] = { "Major Mana Potion", 1, 49, { { "D", 229, 1, "Quartermaster Zigris, Chromatic Dragonspawn, Spirestone Warlord and others" }, { "D", 309, 0.172, "Hakkari Witch Doctor, Gurubashi Headhunter, Hakkari Blood Priest and others" }, { "D", 289, 0.197, "Unstable Corpse, Reanimated Corpse, Scholomance Student and others" }, { "D", 329, 0.263, "Malor the Zealous, Crimson Monk, Stonespine and others" }, { "D", 409, 0.029, "Flamewaker Protector, Flamewaker Priest, Flamewaker" }, { "D", 429, 0.22, "Tsu'zee, Gordok Brute, Gordok Mage-Lord and others" }, { "D", 469, 0.123, "Death Talon Wyrmguard, Blackwing Technician, Death Talon Captain and others" }, { "D", 2291, 0.02, "Goraluk Anvilcrack, Jed Runewatcher" }, { "D", 249, 0.012, "Onyxian Warder" }, { "Q", 8278, "Noggle's Last Hope", 0, 4, 0, 57, 54, { 8277, "Deadly Desert Venom", 1, 0, 2 }, { 8277, "Deadly Desert Venom", 1, 0, 2 }, 0 }, { "Q", 8470, "Deadwood Ritual Totem", 0, 0, 0, 55, 45, { 8470, "Deadwood Ritual Totem", 0, 0, 1 }, { 8470, "Deadwood Ritual Totem", 0, 0, 1 }, 0 }, { "Q", 8471, "Winterfall Ritual Totem", 0, 0, 0, 56, 50, { 8471, "Winterfall Ritual Totem", 0, 0, 1 }, { 8471, "Winterfall Ritual Totem", 0, 0, 1 }, 0 }, { "Q", 9419, "Scouring the Desert", 0, 5, 1101, 60, 1, { 9415, "Report to Marshal Bluewall", 1, 0, 2 }, { 9419, "Scouring the Desert", 1, 0, 1 }, 0 }, { "Q", 9422, "Scouring the Desert", 0, 5, 0, 60, 55, { 9422, "Scouring the Desert", 1, 0, 1 }, { 9416, "Report to General Kirika", 1, 0, 2 }, 0 }, { "X", "Crafted: Alchemy", 171, 295, 0, "recipe drops in Scholomance", 289 } } },
	[13446] = { "Major Healing Potion", 1, 45, { { "D", 229, 1, "Quartermaster Zigris, Chromatic Dragonspawn, Spirestone Warlord and others" }, { "D", 309, 0.32, "Hakkari Witch Doctor, Gurubashi Headhunter, Hakkari Blood Priest and others" }, { "D", 230, 0.426, "Ograbisi, Jaz, Shill Dinger and others" }, { "D", 289, 0.36, "Unstable Corpse, Reanimated Corpse, Scholomance Student and others" }, { "D", 329, 0.467, "Crimson Monk, Stonespine, Hearthsinger Forresten and others" }, { "D", 409, 0.059, "Flamewaker Protector, Flamewaker Priest, Flamewaker" }, { "D", 429, 0.434, "Tsu'zee, Gordok Brute, Gordok Mage-Lord and others" }, { "D", 469, 0.224, "Death Talon Wyrmguard, Blackwing Technician, Death Talon Captain and others" }, { "D", 2291, 0.04, "Goraluk Anvilcrack, Jed Runewatcher" }, { "D", 249, 0.017, "Onyxian Warder" }, { "Q", 8278, "Noggle's Last Hope", 0, 4, 0, 57, 54, { 8277, "Deadly Desert Venom", 1, 0, 2 }, { 8277, "Deadly Desert Venom", 1, 0, 2 }, 0 }, { "Q", 8470, "Deadwood Ritual Totem", 0, 0, 0, 55, 45, { 8470, "Deadwood Ritual Totem", 0, 0, 1 }, { 8470, "Deadwood Ritual Totem", 0, 0, 1 }, 0 }, { "Q", 8471, "Winterfall Ritual Totem", 0, 0, 0, 56, 50, { 8471, "Winterfall Ritual Totem", 0, 0, 1 }, { 8471, "Winterfall Ritual Totem", 0, 0, 1 }, 0 }, { "Q", 9052, "Bloodpetal Poison", 0, 0, 0, 52, 50, { 9063, "Torwa Pathfinder", 9, 1, 2 }, { 9063, "Torwa Pathfinder", 9, 1, 2 }, 1024 }, { "Q", 9419, "Scouring the Desert", 0, 5, 1101, 60, 1, { 9415, "Report to Marshal Bluewall", 1, 0, 2 }, { 9419, "Scouring the Desert", 1, 0, 1 }, 0 }, { "Q", 9422, "Scouring the Desert", 0, 5, 0, 60, 55, { 9422, "Scouring the Desert", 1, 0, 1 }, { 9416, "Report to General Kirika", 1, 0, 2 }, 0 }, { "X", "Crafted: Alchemy", 171, 275, 0, "recipe sold by Evie Whirlbrew", 0 } } },
	[13452] = { "Elixir of the Mongoose", 1, 46, { { "Q", 8282, "Noggle's Lost Satchel", 0, 4, 0, 58, 54, { 8277, "Deadly Desert Venom", 1, 0, 3 }, { 8277, "Deadly Desert Venom", 1, 0, 3 }, 0 }, { "X", "Crafted: Alchemy", 171, 280, 0, "from a recipe", 0 } } },
	[13454] = { "Greater Arcane Elixir", 1, 47, { { "X", "Crafted: Alchemy", 171, 285, 0, "from a recipe", 0 } } },
	[13511] = { "Flask of Distilled Wisdom", 1, 50, { { "X", "Crafted: Alchemy", 171, 300, 0, "from a recipe", 0 } } },
	[13512] = { "Flask of Supreme Power", 1, 50, { { "X", "Crafted: Alchemy", 171, 300, 0, "recipe sold by Alurmi (Exalted)", 0 } } },
	[13928] = { "Grilled Squid", 1, 35, { { "X", "Crafted: Cooking", 185, 240, 0, "recipe sold by Gikkix", 0 } } },
	[13931] = { "Nightfin Soup", 1, 35, { { "X", "Crafted: Cooking", 185, 250, 0, "recipe sold by Gikkix", 0 } } },
	[15564] = { "Rugged Armor Kit", 1, 40, { { "X", "Crafted: Leatherworking", 165, 250, 0, "from a trainer", 0 } } },
	[15993] = { "Thorium Grenade", 1, 0, { { "X", "Crafted: Engineering", 202, 260, 0, "recipe sold by Sovik", 0 } } },
	[18169] = { "Flame Mantle of the Dawn", 2, 0, { { "V", "Argent Quartermaster Hasana <The Argent Dawn>", 100000, 529, 6, 0 }, { "V", "Argent Quartermaster Lightspark <The Argent Dawn>", 100000, 529, 6, 0 }, { "V", "Quartermaster Miranda Breechlock <The Argent Dawn>", 100000, 529, 6, 0 } } },
	[18170] = { "Frost Mantle of the Dawn", 2, 0, { { "V", "Argent Quartermaster Hasana <The Argent Dawn>", 100000, 529, 6, 0 }, { "V", "Argent Quartermaster Lightspark <The Argent Dawn>", 100000, 529, 6, 0 }, { "V", "Quartermaster Miranda Breechlock <The Argent Dawn>", 100000, 529, 6, 0 } } },
	[18171] = { "Arcane Mantle of the Dawn", 2, 0, { { "V", "Argent Quartermaster Hasana <The Argent Dawn>", 100000, 529, 6, 0 }, { "V", "Argent Quartermaster Lightspark <The Argent Dawn>", 100000, 529, 6, 0 }, { "V", "Quartermaster Miranda Breechlock <The Argent Dawn>", 100000, 529, 6, 0 } } },
	[18172] = { "Nature Mantle of the Dawn", 2, 0, { { "V", "Argent Quartermaster Hasana <The Argent Dawn>", 100000, 529, 6, 0 }, { "V", "Argent Quartermaster Lightspark <The Argent Dawn>", 100000, 529, 6, 0 }, { "V", "Quartermaster Miranda Breechlock <The Argent Dawn>", 100000, 529, 6, 0 } } },
	[18173] = { "Shadow Mantle of the Dawn", 2, 0, { { "V", "Argent Quartermaster Hasana <The Argent Dawn>", 100000, 529, 6, 0 }, { "V", "Argent Quartermaster Lightspark <The Argent Dawn>", 100000, 529, 6, 0 }, { "V", "Quartermaster Miranda Breechlock <The Argent Dawn>", 100000, 529, 6, 0 } } },
	[18182] = { "Chromatic Mantle of the Dawn", 2, 0, { { "Q", 5517, "Chromatic Mantle of the Dawn", 0, 0, 0, 60, 55, { 5517, "Chromatic Mantle of the Dawn", 1, 0, 1 }, { 5517, "Chromatic Mantle of the Dawn", 1, 0, 1 }, 0 }, { "Q", 5521, "Chromatic Mantle of the Dawn", 0, 0, 0, 60, 55, { 5521, "Chromatic Mantle of the Dawn", 1, 0, 1 }, { 5521, "Chromatic Mantle of the Dawn", 1, 0, 1 }, 0 }, { "Q", 5524, "Chromatic Mantle of the Dawn", 0, 0, 0, 60, 55, { 5524, "Chromatic Mantle of the Dawn", 1, 0, 1 }, { 5524, "Chromatic Mantle of the Dawn", 1, 0, 1 }, 0 }, { "V", "Argent Quartermaster Hasana <The Argent Dawn>", 400000, 529, 7, 0 }, { "V", "Argent Quartermaster Lightspark <The Argent Dawn>", 400000, 529, 7, 0 }, { "V", "Quartermaster Miranda Breechlock <The Argent Dawn>", 400000, 529, 7, 0 } } },
	[18251] = { "Core Armor Kit", 3, 50, { { "X", "Crafted: Leatherworking", 165, 300, 0, "recipe drops in Molten Core", 409 } } },
	[18254] = { "Runn Tum Tuber Surprise", 1, 45, { { "X", "Crafted: Cooking", 185, 275, 0, "recipe drops in Dire Maul", 429 } } },
	[18283] = { "Biznicks 247x128 Accurascope", 3, 50, { { "X", "Crafted: Engineering", 202, 300, 0, "recipe drops in Molten Core", 409 } } },
	[18329] = { "Arcanum of Rapidity", 2, 0, { { "Q", 7483, "Libram of Rapidity", 429, 0, 0, 60, 57, { 7483, "Libram of Rapidity", 1, 0, 1 }, { 7483, "Libram of Rapidity", 1, 0, 1 }, 0 } } },
	[18330] = { "Arcanum of Focus", 2, 0, { { "Q", 7484, "Libram of Focus", 429, 0, 0, 60, 57, { 7484, "Libram of Focus", 1, 0, 1 }, { 7484, "Libram of Focus", 1, 0, 1 }, 0 } } },
	[18331] = { "Arcanum of Protection", 2, 0, { { "Q", 7485, "Libram of Protection", 429, 0, 0, 60, 57, { 7485, "Libram of Protection", 1, 0, 1 }, { 7485, "Libram of Protection", 1, 0, 1 }, 0 } } },
	[18641] = { "Dense Dynamite", 1, 0, { { "X", "Crafted: Engineering", 202, 250, 0, "from a trainer", 0 } } },
	[19782] = { "Presence of Might", 3, 60, { { "Q", 8184, "Presence of Might", 309, 3, 0, 60, 58, { 8184, "Presence of Might", 1, 0, 1 }, { 8184, "Presence of Might", 1, 0, 1 }, 1 } } },
	[19783] = { "Syncretist's Sigil", 3, 60, { { "Q", 8185, "Syncretist's Sigil", 309, 3, 0, 60, 58, { 8185, "Syncretist's Sigil", 1, 0, 1 }, { 8185, "Syncretist's Sigil", 1, 0, 1 }, 2 } } },
	[19784] = { "Death's Embrace", 3, 60, { { "Q", 8186, "Death's Embrace", 309, 3, 0, 60, 58, { 8186, "Death's Embrace", 1, 0, 1 }, { 8186, "Death's Embrace", 1, 0, 1 }, 8 } } },
	[19785] = { "Falcon's Call", 3, 60, { { "Q", 8187, "Falcon's Call", 309, 3, 0, 60, 58, { 8187, "Falcon's Call", 1, 0, 1 }, { 8187, "Falcon's Call", 1, 0, 1 }, 4 } } },
	[19786] = { "Vodouisant's Vigilant Embrace", 3, 60, { { "Q", 8188, "Vodouisant's Vigilant Embrace", 309, 3, 0, 60, 58, { 8188, "Vodouisant's Vigilant Embrace", 1, 0, 1 }, { 8188, "Vodouisant's Vigilant Embrace", 1, 0, 1 }, 64 } } },
	[19787] = { "Presence of Sight", 3, 60, { { "Q", 8189, "Presence of Sight", 309, 3, 0, 60, 58, { 8189, "Presence of Sight", 1, 0, 1 }, { 8189, "Presence of Sight", 1, 0, 1 }, 128 } } },
	[19788] = { "Hoodoo Hex", 3, 60, { { "Q", 8190, "Hoodoo Hex", 309, 3, 0, 60, 58, { 8190, "Hoodoo Hex", 1, 0, 1 }, { 8190, "Hoodoo Hex", 1, 0, 1 }, 256 } } },
	[19789] = { "Prophetic Aura", 3, 60, { { "Q", 8191, "Prophetic Aura", 309, 3, 0, 60, 58, { 8191, "Prophetic Aura", 1, 0, 1 }, { 8191, "Prophetic Aura", 1, 0, 1 }, 16 } } },
	[19790] = { "Animist's Caress", 3, 60, { { "Q", 8192, "Animist's Caress", 309, 3, 0, 60, 58, { 8192, "Animist's Caress", 1, 0, 1 }, { 8192, "Animist's Caress", 1, 0, 1 }, 1024 } } },
	[19971] = { "High Test Eternium Fishing Line", 2, 0, { { "Q", 8224, "Rare Fish - Dezian Queenfish", 0, 0, 0, -1, 1, { 8224, "Rare Fish - Dezian Queenfish", 1, 0, 1 }, { 8224, "Rare Fish - Dezian Queenfish", 1, 0, 1 }, 0 } } },
	[20007] = { "Mageblood Elixir", 1, 40, { { "X", "Crafted: Alchemy", 171, 275, 3, "recipe sold by Rin'wosho the Trader (Revered)", 0 } } },
	[20076] = { "Zandalar Signet of Mojo", 3, 0, { { "Q", 8246, "Signets of the Zandalar", 309, 3, 0, 60, 58, { 8246, "Signets of the Zandalar", 1, 0, 1 }, { 8246, "Signets of the Zandalar", 1, 0, 1 }, 0 } } },
	[20077] = { "Zandalar Signet of Might", 3, 0, { { "Q", 8246, "Signets of the Zandalar", 309, 3, 0, 60, 58, { 8246, "Signets of the Zandalar", 1, 0, 1 }, { 8246, "Signets of the Zandalar", 1, 0, 1 }, 0 } } },
	[20078] = { "Zandalar Signet of Serenity", 3, 0, { { "Q", 8246, "Signets of the Zandalar", 309, 3, 0, 60, 58, { 8246, "Signets of the Zandalar", 1, 0, 1 }, { 8246, "Signets of the Zandalar", 1, 0, 1 }, 0 } } },
	[20748] = { "Brilliant Mana Oil", 1, 45, { { "X", "Crafted: Enchanting", 333, 300, 3, "recipe sold by Rin'wosho the Trader (Friendly)", 0 } } },
	[20749] = { "Brilliant Wizard Oil", 1, 45, { { "X", "Crafted: Enchanting", 333, 300, 3, "recipe sold by Rin'wosho the Trader (Honored)", 0 } } },
	[20844] = { "Deadly Poison V", 1, 60, { { "V", "Jasper Fel <Shady Dealer>", 600, 0, 0, 0 }, { "V", "Sloan McCoy <Poison Supplier>", 600, 0, 0, 0 }, { "V", "Samor Festivus <Shady Dealer>", 600, 0, 0, 0 }, { "V", "Sly Garrett <Shady Goods>", 600, 0, 0, 0 }, { "V", "Gerald Crawley <Poison Supplier>", 600, 0, 0, 0 }, { "V", "Malissa <Poison Supplier>", 600, 0, 0, 0 }, { "V", "Rekkul <Poison Vendor>", 600, 0, 0, 0 }, { "V", "Hula'mahi <Reagents and Herbs>", 600, 0, 0, 0 }, { "V", "Jaysin Lanyda <Poisons & Reagents>", 600, 0, 0, 0 }, { "V", "Patrice Dwyer <Poison Supplies>", 600, 0, 0, 0 }, { "V", "Kyrai <Poison Vendor>", 600, 0, 0, 0 }, { "V", "Fahran Silentblade <Tools & Supplies>", 600, 0, 0, 0 }, { "V", "Ezekiel Graves <Poison Vendor>", 600, 0, 0, 0 }, { "V", "Tynnus Venomsprout <Shady Dealer>", 600, 0, 0, 0 }, { "V", "Smudge Thunderwood <Poison Vendor>", 600, 0, 0, 0 }, { "V", "Khur Hornstriker <Reagent Vendor>", 600, 0, 0, 0 }, { "V", "Bortega <Reagents & Poison Supplies>", 600, 0, 0, 0 }, { "V", "Miles Sidney <Poison Supplies>", 600, 0, 0, 0 } } },
	[22635] = { "Savage Guard", 3, 55, { { "Q", 9208, "The Savage Guard - Arcanum of Protection", 0, 3, 0, 60, 60, { 9208, "The Savage Guard - Arcanum of Protection", 1, 0, 1 }, { 9208, "The Savage Guard - Arcanum of Protection", 1, 0, 1 }, 0 }, { "Q", 9209, "The Savage Guard - Arcanum of Rapidity", 0, 3, 0, 60, 60, { 9209, "The Savage Guard - Arcanum of Rapidity", 1, 0, 1 }, { 9209, "The Savage Guard - Arcanum of Rapidity", 1, 0, 1 }, 0 }, { "Q", 9210, "The Savage Guard - Arcanum of Focus", 0, 3, 0, 60, 60, { 9210, "The Savage Guard - Arcanum of Focus", 1, 0, 1 }, { 9210, "The Savage Guard - Arcanum of Focus", 1, 0, 1 }, 0 } } },
	[22636] = { "Ice Guard", 3, 55, { { "Q", 9211, "The Ice Guard", 0, 6, 0, 60, 60, { 9211, "The Ice Guard", 1, 0, 1 }, { 9211, "The Ice Guard", 1, 0, 1 }, 0 } } },
	[22638] = { "Shadow Guard", 3, 55, { { "Q", 9213, "The Shadow Guard", 0, 6, 0, 60, 60, { 9213, "The Shadow Guard", 1, 0, 1 }, { 9213, "The Shadow Guard", 1, 0, 1 }, 0 } } },
	[23545] = { "Power of the Scourge", 4, 60, { { "D", 533, 0.5, "Sapphiron" } } },
	[23547] = { "Resilience of the Scourge", 4, 60, { { "D", 533, 0.5, "Sapphiron" } } },
	[23548] = { "Might of the Scourge", 4, 60, { { "D", 533, 0.5, "Sapphiron" } } },
	[23549] = { "Fortitude of the Scourge", 4, 60, { { "D", 533, 0.5, "Sapphiron" } } },
}
