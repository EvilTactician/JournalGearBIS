-- JournalGearBIS's logic: which spec list to show, what each item is worth to it, what you own, and for every
-- slot up to three steps from what you wear: what to get now (an easy item first where there is one, then the
-- best you can get), what opens next, and the slot's best in slot. Below the level gearing starts, the list is
-- a preview of your goals at the level cap.
--
-- Profiles.lua has the stat weights, Curated.lua the hand-picked items and Data.lua the items and where they
-- come from. Nothing here draws anything: Gear.lua is the tab.

local G = JournalGearBIS
if not (G and G.items and G.profiles) then return end

local band = bit and bit.band or function (a, b)
	local r, m = 0, 1
	while a > 0 and b > 0 do
		if a % 2 == 1 and b % 2 == 1 then r = r + m end
		a, b, m = math.floor(a / 2), math.floor(b / 2), m * 2
	end
	return r
end
G.band = band

G.CLASS_BIT = { WARRIOR = 1, PALADIN = 2, HUNTER = 4, ROGUE = 8, PRIEST = 16, DEATHKNIGHT = 32, SHAMAN = 64,
	MAGE = 128, WARLOCK = 256, DRUID = 1024 }
G.RACE_BIT = { Human = 1, Orc = 2, Dwarf = 4, NightElf = 8, Scourge = 16, Tauren = 32, Gnome = 64, Troll = 128,
	BloodElf = 512, Draenei = 1024 }
G.STANDINGS = { [0] = "Hated", "Hostile", "Unfriendly", "Neutral", "Friendly", "Honored", "Revered", "Exalted" }
G.FACTIONS = {
	[59] = "Thorium Brotherhood", [270] = "Zandalar Tribe", [529] = "Argent Dawn", [576] = "Timbermaw Hold",
	[609] = "Cenarion Circle", [749] = "Hydraxian Waterlords", [809] = "Shen'dralar", [910] = "Brood of Nozdormu",
}

-- The rows of the list, top to bottom. inv: the inventory types that go there; slots: where you wear it
-- (two for rings and trinkets).
G.ROWS = {
	{ key = "HEAD", name = "Head", inv = { [1] = true }, slots = { 1 } },
	{ key = "NECK", name = "Neck", inv = { [2] = true }, slots = { 2 } },
	{ key = "SHOULDER", name = "Shoulders", inv = { [3] = true }, slots = { 3 } },
	{ key = "BACK", name = "Back", inv = { [16] = true }, slots = { 15 } },
	{ key = "CHEST", name = "Chest", inv = { [5] = true, [20] = true }, slots = { 5 } },
	{ key = "WRIST", name = "Wrists", inv = { [9] = true }, slots = { 9 } },
	{ key = "HANDS", name = "Hands", inv = { [10] = true }, slots = { 10 } },
	{ key = "WAIST", name = "Waist", inv = { [6] = true }, slots = { 6 } },
	{ key = "LEGS", name = "Legs", inv = { [7] = true }, slots = { 7 } },
	{ key = "FEET", name = "Feet", inv = { [8] = true }, slots = { 8 } },
	{ key = "FINGER", name = "Rings", inv = { [11] = true }, slots = { 11, 12 }, pair = true },
	{ key = "TRINKET", name = "Trinkets", inv = { [12] = true }, slots = { 13, 14 }, pair = true },
	{ key = "MH", name = "Main hand", weapon = "MH", slots = { 16 } },
	{ key = "OH", name = "Off hand", weapon = "OH", slots = { 17 } },
	{ key = "RANGED", name = "Ranged", weapon = "RANGED", slots = { 18 } },
}

-- Raids in the order they open; dungeons come before them all.
G.RAID_ORDER = { [409] = 1, [249] = 2, [469] = 3, [309] = 4, [509] = 5, [531] = 6, [533] = 7 }
local TIER_EASY, TIER_DUNGEON, TIER_RAID = 1, 2, 10

-- An upgrade beats what you have by MIN_GAIN; a step is only worth taking when it's STEP_GAIN better than
-- the one before it. A slot shows at most SHOWN steps.
local MIN_GAIN, STEP_GAIN, SHOWN = 1.03, 1.08, 3
-- Curated items win their tier unless the stat-weighted pick is much better.
local CURATED_BONUS = 1.15
-- Drop chances: at least EASY is easy, at least MEDIUM is medium, below that hard.
G.EASY, G.MEDIUM = 0.15, 0.06

-- The expansion whose lists apply at a level: past an expansion's level cap you're levelling through the next
-- one, so its list takes over (Classic to 60, The Burning Crusade 61 to 70, Wrath of the Lich King from 71).
function G.Phase(level)
	if level >= 71 then return 2 end
	if level >= 61 then return 1 end
	return 0
end

-- Each expansion's level cap, and the level gearing for it starts: below that the list is a preview.
G.CAP = { [0] = 60, 70, 80 }
G.READY = { [0] = 55, 65, 75 }

-----------------------------------------
-- the item table

-- Data.lua's arrays, as named fields.
local function item(id)
	local t = G.items[id]
	if not t then return nil end
	if not t.id then
		t.id, t.name, t.inv, t.sub, t.ilvl, t.req, t.quality, t.classes, t.races, t.unique, t.stats, t.sources =
			id, t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9] == 1, t[10], t[11]
		t.class, t.subclass = math.floor(t.sub / 100), t.sub % 100
	end
	return t
end
G.Item = item

-- Items by inventory type, filled once.
local byInv
local function itemsByInv()
	if byInv then return byInv end
	byInv = {}
	for id in pairs(G.items) do
		local t = item(id)
		byInv[t.inv] = byInv[t.inv] or {}
		table.insert(byInv[t.inv], t)
	end
	return byInv
end

-----------------------------------------
-- profiles

-- The profile for a talent group (1 or 2): the tree with the most points.
function G.TalentProfile(group)
	local _, class = UnitClass("player")
	local trees = G.byTree[class]
	if not trees then return nil end
	local best, bestPoints, name = 1, -1, nil
	for tab = 1, (GetNumTalentTabs and GetNumTalentTabs() or 3) do
		local tabName, _, points = GetTalentTabInfo(tab, false, false, group)
		if (points or 0) > bestPoints then best, bestPoints, name = tab, points or 0, tabName end
	end
	return trees[best], (bestPoints > 0) and name or nil
end

-----------------------------------------
-- scoring

function G.Score(stats, weights, part)
	local s = 0
	for k, v in pairs(stats) do
		if k ~= "wdps" and k ~= "speed" then s = s + (weights[k] or 0) * v end
	end
	if stats.wdps then s = s + (weights[part or "dps"] or 0) * stats.wdps end
	return s
end

-- Stats read off an item's tooltip, for items Data.lua doesn't have (or has without their random suffix).
local scan = CreateFrame("GameTooltip", "JournalGearBISScanTip", nil, "GameTooltipTemplate")
local NAMED = {
	["Agility"] = "agi", ["Strength"] = "str", ["Intellect"] = "int", ["Spirit"] = "spi", ["Stamina"] = "sta",
	["Attack Power"] = "ap", ["Spell Power"] = "sp", ["Critical Strike Rating"] = "crit", ["Hit Rating"] = "hit",
	["Haste Rating"] = "haste", ["Defense Rating"] = "def", ["Dodge Rating"] = "dodge", ["Parry Rating"] = "parry",
	["Block Rating"] = "block", ["Block Value"] = "bv", ["Expertise Rating"] = "exp", ["Armor Penetration Rating"] = "arp",
	["Spell Penetration"] = "spen", ["Healing"] = "heal", ["Spell Damage"] = "dmg", ["Ranged Attack Power"] = "rap",
	["Mana every 5 seconds"] = "mp5", ["mana per 5 sec."] = "mp5",
}
local EQUIP = {
	{ "attack power by (%d+) in Cat", "fap" },
	{ "ranged attack power by (%d+)", "rap" },
	{ "attack power by (%d+)", "ap" },
	{ "spell power by (%d+)", "sp" },
	{ "critical strike rating by (%d+)", "crit" },
	{ "hit rating by (%d+)", "hit" },
	{ "haste rating by (%d+)", "haste" },
	{ "expertise rating by (%d+)", "exp" },
	{ "armor penetration rating by (%d+)", "arp" },
	{ "defense rating by (%d+)", "def" },
	{ "dodge rating by (%d+)", "dodge" },
	{ "parry rating by (%d+)", "parry" },
	{ "shield block rating by (%d+)", "block" },
	{ "block value of your shield by (%d+)", "bv" },
	{ "spell penetration by (%d+)", "spen" },
	{ "Restores (%d+) mana per 5 sec", "mp5" },
}
local tipCache = {}
function G.TooltipStats(link)
	if tipCache[link] then return tipCache[link] end
	scan:SetOwner(WorldFrame, "ANCHOR_NONE")
	scan:ClearLines()
	scan:SetHyperlink(link)
	local n = scan:NumLines()
	if not n or n < 2 then return nil end
	local s = {}
	for i = 2, n do
		local fs = _G["JournalGearBISScanTipTextLeft" .. i]
		local text = fs and fs:GetText()
		if text then
			local v, name = text:match("^%+(%d+) (.+)$")
			if v and NAMED[name] then
				s[NAMED[name]] = (s[NAMED[name]] or 0) + tonumber(v)
			end
			local armor = text:match("^(%d+) Armor$")
			if armor then s.armor = (s.armor or 0) + tonumber(armor) end
			local dps = text:match("%(([%d%.]+) damage per second%)")
			if dps then s.wdps = tonumber(dps) end
			if text:find("^Equip:") then
				for _, p in ipairs(EQUIP) do
					local x = text:match(p[1])
					if x then
						s[p[2]] = (s[p[2]] or 0) + tonumber(x)
						break
					end
				end
			end
		end
	end
	tipCache[link] = s
	return s
end

-- An item link's stats: Data.lua's when it has the item as it is, else what its tooltip says.
function G.LinkStats(link)
	local id, suffix = link:match("item:(%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:(%-?%d+)")
	id = tonumber(id or link:match("item:(%d+)"))
	local t = id and item(id)
	if t and (suffix == nil or suffix == "0") then return t.stats, t end
	return G.TooltipStats(link) or (t and t.stats) or {}, t
end

-----------------------------------------
-- the player

local P = {}  -- this render's player: class, race, level, stage, profile, owned
G.player = P

local function weaponPart(rowKey) return (rowKey == "OH" and "odps") or (rowKey == "RANGED" and "rdps") or "dps" end

-- Can the profile use the item there? (MH, OH, RANGED or an armor row)
function G.Fits(prof, t, rowKey)
	local inv, sub, kind = t.inv, t.subclass, prof.weapons
	if rowKey == "RANGED" then
		if prof.ranged == "wand" then return inv == 26 and t.class == 2 and sub == 19 end
		if prof.ranged == "relic" then return inv == 28 end
		return (inv == 15 or inv == 25 or inv == 26) and t.class == 2 and sub ~= 19
	elseif rowKey == "MH" then
		if kind == "2h" then return inv == 17 end
		if inv == 17 then return kind == "caster" or kind == "hunter" end
		if inv ~= 13 and inv ~= 21 then return false end
		return not prof.mh or prof.mh[sub] == true
	elseif rowKey == "OH" then
		if kind == "dw" or kind == "hunter" then
			return (inv == 13 or inv == 22) and (not prof.oh or prof.oh[sub] == true)
		end
		if kind == "tank" then return inv == 14 end
		if kind == "caster" then return inv == 14 or inv == 23 end
		return false
	end
	return true
end

local function usable(t)
	if band(t.classes, G.CLASS_BIT[P.class] or 0) == 0 then return false end
	if t.races ~= 0 and band(t.races, P.raceBit) == 0 then return false end
	return true
end

-- What you wear and carry: { [slot] = { link, id, stats, item } } and the bags' items by inventory type.
local function scanOwned()
	local worn, bags = {}, {}
	for slot = 1, 18 do
		local link = GetInventoryItemLink("player", slot)
		if link then
			local stats, t = G.LinkStats(link)
			local _, _, quality, _, _, _, _, _, equipLoc = GetItemInfo(link)
			worn[slot] = { link = link, id = tonumber(link:match("item:(%d+)")), stats = stats, item = t, quality = quality,
				twoHand = equipLoc == "INVTYPE_2HWEAPON" }
		end
	end
	for bag = 0, 4 do
		for i = 1, (GetContainerNumSlots(bag) or 0) do
			local link = GetContainerItemLink(bag, i)
			local id = link and tonumber(link:match("item:(%d+)"))
			if id then bags[id] = link end
		end
	end
	P.worn, P.bags = worn, bags
end

-----------------------------------------
-- stages: what's open to you

-- The stage an instance opens at: the realm's word (the Journal's instance list) when it has one.
local realmStage = {}
function G.LearnInstances()
	local J = Journal
	if not (J and J.LoadInstances) then return end
	J.LoadInstances(function (_, list)
		if not list then return end
		for _, inst in ipairs(list) do
			local need
			for _, v in ipairs(inst.variants or {}) do
				if (v.expansion or 0) == 0 then
					need = need and math.min(need, v.reqState or 0) or (v.reqState or 0)
				end
			end
			if need then realmStage[inst.map] = need end
			for key, g in pairs(G.instances) do
				if g.map == inst.map then g.journalId = inst.id end
			end
		end
	end)
end

function G.InstanceStage(key)
	local g = G.instances[key]
	if not g then return 99 end
	return math.max(g.stage, realmStage[g.map] or 0)
end

-- One way to get an item: { kind, inst, chance, who, quest, stage, tier, order, open, why, ... }
local function readSource(s)
	local kind = s[1]
	local src = { kind = kind }
	if kind == "D" or kind == "C" then
		src.inst, src.chance, src.who = s[2], s[3], s[4]
		local g = G.instances[src.inst]
		if not g then return nil end
		src.stage = G.InstanceStage(src.inst)
		src.raid = g.raid
		src.tier = g.raid and (TIER_RAID + (G.RAID_ORDER[src.inst] or 0)) or TIER_DUNGEON
	elseif kind == "Q" then
		src.quest, src.who, src.inst, src.stage, src.races, src.qlevel = s[2], s[3], s[4] ~= 0 and s[4] or nil, s[5], s[6], s[7]
		src.need, src.start, src.startName, src.chain = s[8] or 0, s[9] or s[2], s[10] or s[3], s[11] or 1
		if src.races ~= 0 and band(src.races, P.raceBit) == 0 then return nil end
		if src.inst then
			local g = G.instances[src.inst]
			src.stage = math.max(src.stage, G.InstanceStage(src.inst))
			src.raid = g and g.raid
			src.tier = src.raid and (TIER_RAID + (G.RAID_ORDER[src.inst] or 0)) or TIER_DUNGEON
		else
			src.tier = TIER_EASY
		end
	elseif kind == "V" then
		src.who, src.price, src.rep, src.rank, src.stage = s[2], s[3], s[4], s[5], s[6]
		src.tier = TIER_EASY
	elseif kind == "X" then
		src.who, src.stage, src.tier = s[2], 0, TIER_EASY
	else
		return nil
	end
	src.open = src.stage <= P.stage
	-- usable now: open, and you're the level its quest needs
	src.ok = src.open and (src.need or 0) <= P.level
	return src
end

-- How hard a source is: 1 easy, 2 medium, 3 hard.
function G.Difficulty(src)
	if src.kind == "Q" then return src.inst and 2 or 1 end
	if src.kind == "V" then return (src.rank or 0) >= 6 and 3 or ((src.rank or 0) >= 5 and 2 or 1) end
	if src.kind == "X" then return 2 end
	local c = src.chance or 0
	if src.raid then
		if c >= G.EASY then return 2 end
		return 3
	end
	if c >= G.EASY then return 1 end
	if c >= G.MEDIUM then return 2 end
	return 3
end

-- An item's sources you can use, the easiest first; and whether any is open.
local function sourcesOf(t)
	local list = {}
	for _, s in ipairs(t.sources) do
		local src = readSource(s)
		if src then table.insert(list, src) end
	end
	table.sort(list, function (a, b)
		if a.ok ~= b.ok then return a.ok end
		if a.open ~= b.open then return a.open end
		if a.tier ~= b.tier then return a.tier < b.tier end
		return (a.chance or 1) > (b.chance or 1)
	end)
	return list
end

-----------------------------------------
-- the steps

local curatedValue = {}
local function curatedFor(profileKey)
	if curatedValue[profileKey] then return curatedValue[profileKey] end
	local map = {}
	for _, e in ipairs((G.curated or {})[profileKey] or {}) do map[e[1]] = e[2] or true end
	curatedValue[profileKey] = map
	return map
end

-- A candidate: { item, value, sources, src (the one shown), tier, open, lock }
local function candidate(t, prof, rowKey, curated)
	local srcs = sourcesOf(t)
	if #srcs == 0 then return nil end
	local value = G.Score(t.stats, prof.weights, weaponPart(rowKey))
	local pick = curated[t.id]
	if pick then
		if type(pick) == "number" then value = math.max(value, pick) end
		value = value * CURATED_BONUS
	end
	if value <= 0 then return nil end
	local src = srcs[1]
	local c = { item = t, value = value, sources = srcs, src = src, tier = src.tier, curated = pick and true or false }
	local need = math.max(t.req, src.need or 0)
	c.stage, c.need = src.stage, need
	c.open = src.open and need <= P.level
	if need > P.level and src.open then
		c.lock = "Needs level " .. need
	elseif not src.open then
		local g = src.inst and G.instances[src.inst]
		if g then
			c.lock = "Opens with " .. g.name
		else
			c.lock = "Opens at progression stage " .. src.stage
		end
	end
	return c
end

-- Candidates for a row, by tier.
local function candidates(row, prof, curated)
	local out = {}
	local byI = itemsByInv()
	for inv, list in pairs(byI) do
		local ok
		if row.weapon then
			ok = inv == 13 or inv == 14 or inv == 15 or inv == 17 or inv == 21 or inv == 22 or inv == 23
				or inv == 25 or inv == 26 or inv == 28
		else
			ok = row.inv[inv]
		end
		if ok then
			for _, t in ipairs(list) do
				if usable(t) and (not row.weapon or G.Fits(prof, t, row.weapon)) then
					local c = candidate(t, prof, row.key, curated)
					if c then table.insert(out, c) end
				end
			end
		end
	end
	return out
end

-- What you have for a row: its value and what it is. For rings and trinkets, the weaker of the two
-- (the one an upgrade replaces), with the stronger kept too.
local function ownedFor(row, prof, curated)
	if P.preview then return { value = 0, all = {} } end
	local part = weaponPart(row.key)
	local list = {}
	for _, slot in ipairs(row.slots) do
		local w = P.worn[slot]
		if w then
			local value = G.Score(w.stats, prof.weights, part)
			-- valued as the same item would be in the list
			local pick = curated[w.id]
			if pick then
				if type(pick) == "number" then value = math.max(value, pick) end
				value = value * CURATED_BONUS
			end
			table.insert(list, { worn = w, value = value, id = w.id })
		end
	end
	if row.pair then
		table.sort(list, function (a, b) return a.value > b.value end)
		if #list < 2 then return { value = 0, weak = nil, strong = list[1], all = list } end
		return { value = list[2].value, weak = list[2], strong = list[1], all = list }
	end
	local o = list[1]
	return { value = o and o.value or 0, weak = o, strong = o, all = list }
end

-- The steps for one row: { owned, steps = { candidate... } (each with .role "get", "next" or "bis"), best (true
-- when what you have beats everything Classic has), upgrades (open candidates better than yours) }.
-- exclude: items another row already shows (the main hand's, for the off hand).
function G.BuildRow(row, prof, profileKey, ohRef, exclude)
	local curated = curatedFor(profileKey)
	local owned = ownedFor(row, prof, curated)
	local cands = candidates(row, prof, curated)

	-- A one-hander in the main hand comes with an off-hand; a two-hander doesn't.
	local base = owned.value
	if row.key == "MH" and (prof.weapons == "caster" or prof.weapons == "hunter") then
		for _, c in ipairs(cands) do
			if c.item.inv ~= 17 then c.value = c.value + (ohRef or 0) end
		end
		local w = not P.preview and P.worn[16]
		if w and not w.twoHand then base = base + (ohRef or 0) end
	end
	owned.value = base

	-- What you wear isn't offered again, nor what another row already shows.
	local wornIds = {}
	for _, o in ipairs(owned.all) do wornIds[o.id] = true end
	local pool = {}
	for _, c in ipairs(cands) do
		if not wornIds[c.item.id] and not (exclude and exclude[c.item.id]) and c.value > owned.value * MIN_GAIN + 0.5 then
			table.insert(pool, c)
		end
	end

	-- The way up through what you can get now: each tier's best when it beats the step before (in
	-- dungeons, an easier drop first when the best is a rare one).
	local tiers, order = {}, {}
	for _, c in ipairs(pool) do
		if c.open then
			if not tiers[c.tier] then tiers[c.tier] = {}; table.insert(order, c.tier) end
			table.insert(tiers[c.tier], c)
		end
	end
	table.sort(order)
	local steps, prev = {}, owned.value
	local function better(v) return v > prev * (#steps == 0 and MIN_GAIN or STEP_GAIN) + 0.5 end
	for _, tier in ipairs(order) do
		local list = tiers[tier]
		table.sort(list, function (a, b) return a.value > b.value end)
		local best = list[1]
		if better(best.value) then
			if tier == TIER_DUNGEON and G.Difficulty(best.src) >= 2 then
				for _, c in ipairs(list) do
					if c ~= best and G.Difficulty(c.src) == 1 and better(c.value) and c.value * STEP_GAIN < best.value then
						table.insert(steps, c)
						prev = c.value
						break
					end
				end
			end
			table.insert(steps, best)
			prev = best.value
		end
	end
	-- A first step worth less than half the next isn't worth the detour.
	if #steps >= 2 and steps[1].value < steps[2].value * 0.5 then table.remove(steps, 1) end

	-- What opens after that, soonest first: by progression stage, then level, then raid order.
	local locked = {}
	for _, c in ipairs(pool) do
		if not c.open then table.insert(locked, c) end
	end
	table.sort(locked, function (a, b)
		if a.stage ~= b.stage then return a.stage < b.stage end
		if a.need ~= b.need then return a.need < b.need end
		if a.tier ~= b.tier then return a.tier < b.tier end
		return a.value > b.value
	end)
	local chain, prevL = {}, prev
	for _, c in ipairs(locked) do
		if c.value > prevL * STEP_GAIN + 0.5 then
			table.insert(chain, c)
			prevL = c.value
		end
	end

	-- The slot's best in slot: the best of everything, open or not.
	local final
	for _, c in ipairs(pool) do
		if not final or c.value > final.value then final = c end
	end

	-- Shown: what to get now (the easy way in and the best you can get), then what opens next, then the
	-- best in slot; three at most.
	local shown = {}
	if #steps >= 1 then table.insert(shown, steps[1]) end
	if #steps >= 2 then table.insert(shown, steps[#steps]) end
	for _, c in ipairs(chain) do
		if #shown >= SHOWN - 1 then break end
		if c ~= final then table.insert(shown, c) end
	end
	local last = shown[#shown]
	if final then
		local present = false
		for _, c in ipairs(shown) do if c == final then present = true end end
		if not present and (not last or final.value > last.value) then
			if #shown >= SHOWN then table.remove(shown, #shown) end
			table.insert(shown, final)
		end
	end
	for _, c in ipairs(shown) do
		c.role = (c == final) and "bis" or (c.open and "get" or "next")
		c.inBags = not P.preview and P.bags[c.item.id] ~= nil
	end

	-- Every open candidate that beats what you have (for the dungeon advice).
	local upgrades = {}
	for _, c in ipairs(pool) do
		if c.open then table.insert(upgrades, c) end
	end

	return {
		row = row, owned = owned, steps = shown, upgrades = upgrades, final = final,
		best = final == nil, openSteps = #steps, candidates = cands,
	}
end

-- Where to go next: the dungeons (and the raid) with the most for you, weighted by how likely each
-- upgrade is to drop and how big it is.
function G.Recommend(rows)
	local score, count, names = {}, {}, {}
	for _, r in ipairs(rows) do
		local perInst = {}
		local base = math.max(r.owned.value, 1)
		for _, c in ipairs(r.upgrades) do
			for _, src in ipairs(c.sources) do
				if src.open and (src.kind == "D" or src.kind == "C") then
					local gain = math.min(1, (c.value - r.owned.value) / base)
					local v = gain * (src.chance or 0)
					local cur = perInst[src.inst]
					if not cur or v > cur.v then perInst[src.inst] = { v = v, c = c } end
				end
			end
		end
		for inst, e in pairs(perInst) do
			score[inst] = (score[inst] or 0) + e.v
			count[inst] = (count[inst] or 0) + 1
			names[inst] = names[inst] or {}
			local seen = false
			for _, c in ipairs(names[inst]) do
				if c.item.id == e.c.item.id then seen = true end
			end
			if not seen then table.insert(names[inst], e.c) end
		end
	end
	local dungeons, raids = {}, {}
	for inst, s in pairs(score) do
		local g = G.instances[inst]
		if g and P.level + 3 >= g.level then
			local e = { inst = inst, score = s, count = #names[inst], items = names[inst], g = g }
			table.sort(e.items, function (a, b) return a.value > b.value end)
			table.insert(g.raid and raids or dungeons, e)
		end
	end
	local function byScore(a, b) return a.score > b.score end
	table.sort(dungeons, byScore)
	table.sort(raids, byScore)
	return dungeons, raids
end

-----------------------------------------
-- everything for one render

-- choice: "active", "other" or a profile key. Returns a view, or nil and why not.
function G.Build(choice, stage)
	local _, class = UnitClass("player")
	local _, race = UnitRace("player")
	P.class, P.race, P.raceBit = class, race, G.RACE_BIT[race] or 0
	P.realLevel = UnitLevel("player")
	local phase = G.Phase(P.realLevel)
	P.preview = P.realLevel < G.READY[phase]
	-- A preview is the list as it will be at the level cap.
	P.level = P.preview and G.CAP[phase] or P.realLevel
	P.stage = stage or 18
	if not G.byTree[class] then return nil, "class" end
	scanOwned()

	local active = GetActiveTalentGroup and GetActiveTalentGroup() or 1
	local groups = GetNumTalentGroups and GetNumTalentGroups() or 1
	local profileKey, treeName, which
	if choice == "other" and groups > 1 then
		which = active == 1 and 2 or 1
		profileKey, treeName = G.TalentProfile(which)
	elseif choice and G.profiles[choice] and G.profiles[choice].class == class then
		profileKey, which = choice, nil
	else
		which = active
		profileKey, treeName = G.TalentProfile(active)
	end
	local prof = G.profiles[profileKey]
	P.profileKey, P.profile = profileKey, prof

	-- The off-hand you'd pair with a one-hander: yours, or the best you can get.
	local ohRef = 0
	local rows = {}
	local ohRow
	for _, row in ipairs(G.ROWS) do
		if row.key == "OH" then ohRow = row end
	end
	if ohRow and (prof.weapons == "caster" or prof.weapons == "hunter") then
		local oh = G.BuildRow(ohRow, prof, profileKey, 0)
		ohRef = oh.owned.value
		if ohRef == 0 then
			for _, c in ipairs(oh.candidates) do
				if c.open and c.value > ohRef then ohRef = c.value end
			end
		end
	end

	local showOH = prof.weapons ~= "2h"
	local mhShown = {}
	for _, row in ipairs(G.ROWS) do
		local r
		if row.key == "OH" and not showOH then
			r = nil
		else
			r = G.BuildRow(row, prof, profileKey, ohRef, row.key == "OH" and mhShown or nil)
		end
		if r and row.key == "MH" then
			for _, c in ipairs(r.steps) do mhShown[c.item.id] = true end
		end
		if r then table.insert(rows, r) end
	end
	-- A caster or hunter with a two-hander as the main hand's goal has no use for the off-hand row.
	if prof.weapons == "caster" or prof.weapons == "hunter" then
		local mh
		for _, r in ipairs(rows) do if r.row.key == "MH" then mh = r end end
		local twoHand = mh and #mh.steps > 0
		for _, c in ipairs(mh and mh.steps or {}) do
			if c.item.inv ~= 17 then twoHand = false end
		end
		if mh and #mh.steps == 0 then twoHand = not P.preview and P.worn[16] and P.worn[16].twoHand end
		if twoHand then
			for i, r in ipairs(rows) do
				if r.row.key == "OH" then
					r.hidden = true
					r.why = "Your main-hand goal is a two-hander."
				end
			end
		end
	end

	-- Where to go next, or why there's nowhere: a preview has no advice; otherwise, all done or out of range.
	local dungeons, raids, adviceNote = {}, {}, nil
	if P.preview then
		adviceNote = "Dungeon advice starts at level " .. G.READY[phase] .. "."
	else
		dungeons, raids = G.Recommend(rows)
		if #dungeons == 0 and #raids == 0 then
			local done = true
			for _, r in ipairs(rows) do
				if not r.best and not r.hidden then done = false end
			end
			adviceNote = done and "You have the best in slot everywhere. Well done!"
				or "No dungeon or raid open to you, near your level, has an upgrade for you right now."
		end
	end
	return {
		profileKey = profileKey, profile = prof, treeName = treeName, group = which, active = active, groups = groups,
		rows = rows, dungeons = dungeons, raids = raids, class = class, adviceNote = adviceNote,
		preview = P.preview, readyLevel = G.READY[phase], cap = G.CAP[phase],
	}
end
