-- JournalGearBIS's extras on top of the gear list: the best enchant for each item you wear, the glyphs for
-- your spec, and the consumables worth bringing. Extras.lua has the data; this adds them to Engine.lua's view
-- as row.enchant, view.glyphs and view.consumables. Gear.lua draws them.
--
-- Stats with a cap (hit, expertise, armor penetration) count only up to it: past the cap, more of them is
-- worth nothing, so an enchant giving them loses out.

local G = JournalGearBIS
if not (G and G.enchants and G.Build and G.player) then return end
local band, P = G.band, G.player

-----------------------------------------
-- caps

-- A cap: the stat keys it limits, for which role, the combat rating it reads, the cap (in % of the rating's
-- bonus; expertise in expertise points), what you have now beyond rating (talents, buffs), and the rating per
-- point of bonus at level 60 for when you have none of it yet. Against raid bosses, three levels above you.
G.CAPS = {
	{ keys = { "mhit", "hit" }, roles = { ["Melee damage"] = true, ["Ranged damage"] = true }, rating = 6, cap = 8,
		extra = function () return GetHitModifier and GetHitModifier() or 0 end, per = 9.84 },
	{ keys = { "shit", "hit" }, roles = { ["Spell damage"] = true }, rating = 8, cap = 17,
		extra = function () return G.TalentSpellHit() end, per = 8 },
	{ keys = { "exp" }, roles = { ["Melee damage"] = true }, rating = 24, cap = 26, per = 2.46,
		have = function () return GetExpertise and GetExpertise() or 0 end },
	{ keys = { "arp" }, roles = { ["Melee damage"] = true, ["Ranged damage"] = true }, rating = 25, cap = 100, per = 4.69,
		have = function () return GetArmorPenetration and GetArmorPenetration() or 0 end },
}

-- The school your spec's list values most (its biggest school damage weight), as a bit; nil for none.
local SCHOOL_BIT = { holy = 2, fire = 4, nature = 8, frost = 16, shadow = 32, arcane = 64 }
local function mainSchool()
	local best, bit = 0, nil
	for k, b in pairs(SCHOOL_BIT) do
		local w = P.profile and P.profile.weights[k] or 0
		if w > best then best, bit = w, b end
	end
	return bit
end

-- Spell hit beyond rating: what the client counts (racials, buffs, talents for all spells) plus the talents it
-- doesn't: hit with some schools only (Suppression, Elemental Precision) when they cover your spec's school, and
-- hit with one tree's spells (Shadow Focus) when that's your spec's tree. Talents the client may count are
-- taken as the larger of the two, so none is counted twice.
function G.TalentSpellHit()
	local api = GetSpellHitModifier and GetSpellHitModifier() or 0
	local _, class = UnitClass("player")
	local all, more, school = 0, 0, mainSchool()
	for _, t in ipairs(G.talentHit and G.talentHit[class] or {}) do
		local rank = P.talentAt and P.talentAt[t[1] .. ":" .. t[2] .. ":" .. t[3]] or 0
		local pct = rank * t[4]
		if t[6] == "all" then
			all = all + pct
		elseif t[6] == "school" then
			if not school or band(t[5], school) ~= 0 then more = more + pct end
		elseif t[6] == "tree" and t[1] == P.treeIndex then
			more = more + pct
		end
	end
	return math.max(api, all) + more
end

-- Rating points still worth having, by stat key (none for a stat with no cap).
local function headroom()
	local room = {}
	for _, cap in ipairs(G.CAPS) do
		if cap.roles[P.profile and P.profile.role or ""] then
			local rating = GetCombatRating and GetCombatRating(cap.rating) or 0
			local bonus = GetCombatRatingBonus and GetCombatRatingBonus(cap.rating) or 0
			-- rating per point of bonus: yours when you have some, the level 60 one (scaled down below it) if not
			local per = (rating > 0 and bonus > 0) and (rating / bonus)
				or cap.per * math.max(0.2, (math.min(P.realLevel or 60, 60) - 8) / 52)
			local have = cap.have and cap.have() or (bonus + (cap.extra and cap.extra() or 0))
			local left = math.max(0, (cap.cap - have) * per)
			for _, k in ipairs(cap.keys) do
				room[k] = math.min(room[k] or math.huge, left)
			end
		end
	end
	return room
end

-- What some stats are worth to your spec, counting caps. credit: the stats the thing they'd replace gives
-- now (they're inside what you have, so they're room for its replacement).
local function worth(stats, room, credit, part, speed)
	local w, total = P.profile.weights, 0
	for k, v in pairs(stats) do
		if type(v) == "number" then
			if k == "wdmg" then
				total = total + (w[part or "dps"] or 0) * v / (speed or 2.6)
			elseif room[k] then
				total = total + (w[k] or 0) * math.min(v, room[k] + (credit and credit[k] or 0))
			else
				total = total + (w[k] or 0) * v
			end
		end
	end
	return total
end

-----------------------------------------
-- enchants

-- A weapon's type as its subclass number, from the client's English name for it (nil if unknown).
local WEAPON_SUBCLASS = { ["One-Handed Axes"] = 0, ["Two-Handed Axes"] = 1, ["Bows"] = 2, ["Guns"] = 3,
	["One-Handed Maces"] = 4, ["Two-Handed Maces"] = 5, ["Polearms"] = 6, ["One-Handed Swords"] = 7,
	["Two-Handed Swords"] = 8, ["Staves"] = 10, ["Fist Weapons"] = 13, ["Miscellaneous"] = 14, ["Daggers"] = 15,
	["Thrown"] = 16, ["Crossbows"] = 18, ["Wands"] = 19, ["Fishing Poles"] = 20 }

-- Which of Extras.lua's enchant slots fit an item you wear in a row.
local function enchantSlots(rowKey, worn)
	if rowKey == "MH" or rowKey == "OH" or rowKey == "RANGED" then
		local _, _, _, _, _, _, subType, _, equipLoc = GetItemInfo(worn.link)
		if rowKey == "RANGED" then
			if subType == "Bows" or subType == "Guns" or subType == "Crossbows" then return { "RANGED" } end
			return {}
		end
		if equipLoc == "INVTYPE_SHIELD" then return { "SHIELD" } end
		if equipLoc == "INVTYPE_2HWEAPON" then return { "WEAPON", "TWOHAND" } end
		if equipLoc == "INVTYPE_WEAPON" or equipLoc == "INVTYPE_WEAPONMAINHAND" or equipLoc == "INVTYPE_WEAPONOFFHAND" then
			return { "WEAPON" }
		end
		return {}
	end
	return G.enchants[rowKey] and { rowKey } or {}
end

-- How to get an enchant: its sources, read like an item's, and whether one of them is open to you.
local function enchantWays(o)
	if o.ways then
		local out = {}
		for _, s in ipairs(o.ways) do
			local src = G.ReadSource(s)
			if src then table.insert(out, src) end
		end
		return out
	end
	local x = G.extraItems[o.item]
	local out = {}
	for _, s in ipairs(x and x[4] or {}) do
		local src = G.ReadSource(s)
		if src then table.insert(out, src) end
	end
	table.sort(out, function (a, b)
		if a.open ~= b.open then return a.open end
		return (a.tier or 0) < (b.tier or 0)
	end)
	return out
end

local function enchantValue(e, room, credit, part, speed)
	local st = G.enchantStats[e]
	if not st then return 0 end
	local v = worth(st, room, credit, part, speed)
	local procs = G.enchantProcs[e]
	if procs and procs[P.profileKey] then v = v + procs[P.profileKey] end
	return v
end

-- Whether a way of getting something takes a raid: a raid drop, a quest needing a raid item, a recipe from one.
local function raidWay(w)
	local inst = w.inst or w.recipeInst
	return inst and G.instances[inst] and G.IsRaid(G.instances[inst]) or false
end

-- The best enchant for what you wear in a row: { now = the best you can get, later = a better one still locked,
-- pre = the best you can get without raiding when that's not the best (a pre-raid step), next = the locked one
-- that opens soonest when it isn't the best later (Lesser Arcanum of Voracity at 50 before Death's Embrace),
-- current = the enchant on it now (0 for none), state = "good", "weak", "none" or "later" (only a locked one) },
-- or nil when nothing's worth putting on.
function G.EnchantFor(r, room)
	if r.row.pair then return nil end
	local worn = P.worn[r.row.slots[1]]
	if not worn then return nil end
	local current = tonumber(worn.link:match("item:%d+:(%d+)")) or 0
	local part = (r.row.key == "OH" and "odps") or (r.row.key == "RANGED" and "rdps") or "dps"
	local speed = worn.item and worn.item.stats and worn.item.stats.speed
	local credit = G.enchantStats[current]
	local classBit = G.CLASS_BIT[P.class] or 0
	local best, later, pre
	local locked = {}
	-- the weapon's type, for enchants that only fit some (Iron Counterweight: no staves)
	local subType = select(7, GetItemInfo(worn.link))
	local sub = WEAPON_SUBCLASS[subType]
	for _, slot in ipairs(enchantSlots(r.row.key, worn)) do
		for _, o in ipairs(G.enchants[slot] or {}) do
			local fits = (o.sub or 0) == 0 or not sub or band(o.sub, 2 ^ sub) ~= 0
			if fits and ((o.classes or 0) == 0 or band(o.classes, classBit) ~= 0) then
				local value = enchantValue(o.e, room, credit, part, speed)
				if value > 0 then
					local ways = enchantWays(o)
					local open, noRaid = false, false
					for _, w in ipairs(ways) do
						if w.open then
							open = true
							if not raidWay(w) then noRaid = true end
						end
					end
					local entry = { e = o.e, spell = o.spell, item = o.item, level = o.level or 0, value = value, ways = ways, open = open }
					if #ways > 0 then
						if open and entry.level <= P.realLevel then
							if not best or value > best.value then best = entry end
							if noRaid and (not pre or value > pre.value) then pre = entry end
						else
							if not later or value > later.value then later = entry end
							-- when it opens: the stage (the soonest of its ways) and level it needs
							entry.opensStage = math.huge
							for _, w in ipairs(ways) do entry.opensStage = math.min(entry.opensStage, w.open and P.stage or w.stage or 0) end
							table.insert(locked, entry)
						end
					end
				end
			end
		end
	end
	if not best and not later then return nil end
	if later and best and later.value <= best.value * 1.05 then later = nil end
	if pre and best and (pre.e == best.e or pre.value >= best.value * 0.98) then pre = nil end
	-- the next step: of the locked ones better than what you'll have, the one that opens soonest
	local floor = math.max(best and best.value or 0, enchantValue(current, room, credit, part, speed)) * 1.02
	local nxt
	for _, o in ipairs(locked) do
		if o.value > floor and (not nxt or o.opensStage < nxt.opensStage
				or (o.opensStage == nxt.opensStage and (o.level < nxt.level or (o.level == nxt.level and o.value > nxt.value)))) then
			nxt = o
		end
	end
	if nxt and later and nxt.e == later.e then nxt = nil end
	local have = enchantValue(current, room, credit, part, speed)
	local state
	if not best then
		-- nothing you can get yet: the one that opens later
		if have >= later.value * 0.98 then return nil end
		state = "later"
	elseif current == best.e or have >= best.value * 0.98 then
		state = "good"
	elseif current == 0 then
		state = "none"
	else
		state = "weak"
	end
	return { now = best, later = later, pre = pre, next = nxt, current = current, have = have, state = state }
end

-- An enchant's name, what it gives and its icon.
function G.EnchantName(o)
	if o.item then
		return (GetItemInfo(o.item)) or (G.extraItems[o.item] and G.extraItems[o.item][1]) or "?"
	end
	return (GetSpellInfo(o.spell)) or (G.enchantNames[o.e] or "?")
end

function G.EnchantIcon(o)
	if o.item then return GetItemIcon and GetItemIcon(o.item) end
	return select(3, GetSpellInfo(o.spell))
end

-----------------------------------------
-- glyphs

-- The levels the glyph slots open at, in order.
G.GLYPH_LEVELS = { major = { 15, 30, 80 }, minor = { 15, 50, 70 } }

-- Your spec's glyphs: { major = { slot, ... }, minor = { ... } }, each slot { glyph, unlock (level), locked,
-- equipped, hint }, or nil for a spec without hand-picked glyphs yet. The best three of each kind you can use,
-- no glyph twice; one needing a talent you don't have gives way to the next, with a hint.
function G.GlyphsFor()
	local lists = G.glyphs and G.glyphs[P.profileKey]
	if not lists then return nil end
	-- the glyphs you have in any socket, and how many sockets of each kind are open
	-- and, by kind, the glyphs in them and the open sockets with none
	local have, open, inSockets, empty = {}, nil, { major = {}, minor = {} }, { major = 0, minor = 0 }
	if GetGlyphSocketInfo then
		open = { major = 0, minor = 0 }
		for i = 1, 6 do
			local enabled, kind, spell = GetGlyphSocketInfo(i)
			local k = kind == 1 and "major" or "minor"
			if enabled then
				open[k] = open[k] + 1
				if not spell then empty[k] = empty[k] + 1 end
			end
			if spell then
				have[spell] = true
				table.insert(inSockets[k], spell)
			end
		end
	end
	local out = {}
	for _, kind in ipairs({ "major", "minor" }) do
		local slots, hint = {}, nil
		for _, t in ipairs(lists[kind] or {}) do
			if #slots >= 3 then break end
			local g = { item = t[1], spell = t[2], rank = t[3], stage = t[4], level = t[5], talent = t[6] ~= "" and t[6] or nil,
				name = t[7] }
			if g.stage <= P.stage and g.level <= P.level then
				if g.talent and (P.talents[g.talent] or 0) == 0 then
					-- a list two specs share (Affliction and Demonology): another tree's glyph isn't for you
					local tree = P.talentTree and P.talentTree[g.talent]
					if not (tree and P.treeIndex and tree ~= P.treeIndex) then
						hint = hint or ("Better with the " .. g.talent .. " talent: " .. g.name)
					end
				else
					table.insert(slots, { glyph = g, equipped = have[g.spell], hint = hint, order = #slots + 1 })
					hint = nil
				end
			end
		end
		-- Best first, whichever socket you have them in. Your open sockets go to the best ones on the list (two of
		-- each kind until level 70 and 80, as in Classic). One you have counts as Equipped wherever it sits. One you
		-- don't goes in an empty socket (Missing), else in place of one that shouldn't be there (Swap in): a glyph
		-- not on the list first, then the weakest one on it, which waits for the socket that opens later.
		local count = open and open[kind] or 0
		if not open then
			for _, lvl in ipairs(G.GLYPH_LEVELS[kind]) do if P.realLevel >= lvl then count = count + 1 end end
		end
		local onList = {}
		for i, sl in ipairs(slots) do
			sl.unlock = G.GLYPH_LEVELS[kind][i]
			sl.locked = not sl.equipped and i > count
			onList[sl.glyph.spell] = true
		end
		-- what can make room, in the order to take it out: off the list, then the list's weakest past your sockets
		local spare = {}
		for _, spell in ipairs(inSockets[kind]) do
			if not onList[spell] then
				table.insert(spare, { name = (GetSpellInfo and GetSpellInfo(spell)) or "your other glyph", offList = true })
			end
		end
		for k = #slots, count + 1, -1 do
			if slots[k].equipped then table.insert(spare, { slot = slots[k], name = slots[k].glyph.name }) end
		end
		local free = empty[kind]
		for i = 1, math.min(count, #slots) do
			local sl = slots[i]
			if not sl.equipped then
				if free > 0 then
					free = free - 1
				elseif #spare > 0 then
					local o = table.remove(spare, 1)
					sl.swap, sl.swapOffList = o.name, o.offList
					-- the weaker one on the list waits for the socket that opens later
					if o.slot then o.slot.waits, o.slot.swapFor = true, sl.glyph.name end
				end
			end
		end
		out[kind] = slots
	end
	return out
end

-----------------------------------------
-- consumables

-- Your spec's consumables: { { id, note, sources, count } }, or nil without a hand-picked list. Only what's open at
-- your stage: an entry with alternatives (Mageblood Elixir, then Elixir of Greater Intellect) shows the
-- first of them that does; one without and nothing open by then (Dirge's chops before Ahn'Qiraj) isn't shown.
function G.ConsumablesFor()
	local list = G.consumables and G.consumables[P.profileKey]
	if not list then return nil end
	local out, taken = {}, false
	for _, t in ipairs(list) do
		if not t[3] then taken = false end
		if not taken then
			local x = G.extraItems[t[1]]
			local srcs, first = {}, nil
			for _, s in ipairs(x and x[4] or {}) do
				local src = G.ReadSource(s)
				if src then
					table.insert(srcs, src)
					first = math.min(first or 99, src.stage or 0)
				end
			end
			if (first or 0) <= P.stage then
				taken = true
				table.sort(srcs, function (a, b)
					if a.open ~= b.open then return a.open end
					return (a.tier or 0) < (b.tier or 0)
				end)
				table.insert(out, { id = t[1], note = t[2] ~= "" and t[2] or nil, sources = srcs, name = x and x[1],
					count = GetItemCount and GetItemCount(t[1]) or 0 })
			end
		end
	end
	return out
end

-- Consumables only a profession can use, for the professions you have: { { skill = profession, items =
-- { { id, rank (skill to use it), usable, note, sources, name, count } } } }.
function G.ProfessionConsumablesFor()
	local out = {}
	for skill, list in pairs(G.professionConsumables or {}) do
		local have = P.skills and P.skills[skill]
		if have then
			local entry = { skill = skill, items = {} }
			for _, t in ipairs(list) do
				local x = G.extraItems[t[1]]
				local srcs = {}
				for _, s in ipairs(x and x[4] or {}) do
					local src = G.ReadSource(s)
					if src then table.insert(srcs, src) end
				end
				table.insert(entry.items, { id = t[1], rank = t[2], usable = have >= t[2], note = t[3], sources = srcs,
					name = x and x[1], count = GetItemCount and GetItemCount(t[1]) or 0 })
			end
			table.insert(out, entry)
		end
	end
	return out
end

-----------------------------------------
-- into the view

local build = G.Build
function G.Build(...)
	local v, why = build(...)
	if v then
		local room = headroom()
		for _, r in ipairs(v.rows) do r.enchant = G.EnchantFor(r, room) end
		v.glyphs = G.GlyphsFor()
		v.consumables = G.ConsumablesFor()
		v.professionConsumables = G.ProfessionConsumablesFor()
	end
	return v, why
end
