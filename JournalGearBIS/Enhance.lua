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
		extra = function () return GetSpellHitModifier and GetSpellHitModifier() or 0 end, per = 8 },
	{ keys = { "exp" }, roles = { ["Melee damage"] = true }, rating = 24, cap = 26, per = 2.46,
		have = function () return GetExpertise and GetExpertise() or 0 end },
	{ keys = { "arp" }, roles = { ["Melee damage"] = true, ["Ranged damage"] = true }, rating = 25, cap = 100, per = 4.69,
		have = function () return GetArmorPenetration and GetArmorPenetration() or 0 end },
}

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
-- pre = the best you can get without raiding when that's not the best (a pre-raid step),
-- current = the enchant on it now (0 for none), state = "good", "weak", "none" or "later" (only a locked one) },
-- or nil when nothing's worth putting on.
function G.EnchantFor(r, room)
	if r.row.pair or P.preview then return nil end
	local worn = P.worn[r.row.slots[1]]
	if not worn then return nil end
	local current = tonumber(worn.link:match("item:%d+:(%d+)")) or 0
	local part = (r.row.key == "OH" and "odps") or (r.row.key == "RANGED" and "rdps") or "dps"
	local speed = worn.item and worn.item.stats and worn.item.stats.speed
	local credit = G.enchantStats[current]
	local classBit = G.CLASS_BIT[P.class] or 0
	local best, later, pre
	for _, slot in ipairs(enchantSlots(r.row.key, worn)) do
		for _, o in ipairs(G.enchants[slot] or {}) do
			if (o.classes or 0) == 0 or band(o.classes, classBit) ~= 0 then
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
						elseif not later or value > later.value then
							later = entry
						end
					end
				end
			end
		end
	end
	if not best and not later then return nil end
	if later and best and later.value <= best.value * 1.05 then later = nil end
	if pre and best and (pre.e == best.e or pre.value >= best.value * 0.98) then pre = nil end
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
	return { now = best, later = later, pre = pre, current = current, have = have, state = state }
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
G.GLYPH_LEVELS = { major = { 15, 50, 80 }, minor = { 15, 30, 70 } }

-- Your spec's glyphs: { major = { slot, ... }, minor = { ... } }, each slot { glyph, unlock (level), locked,
-- equipped, hint }, or nil for a spec without hand-picked glyphs yet. The best three of each kind you can use,
-- no glyph twice; one needing a talent you don't have gives way to the next, with a hint.
function G.GlyphsFor()
	local lists = G.glyphs and G.glyphs[P.profileKey]
	if not lists then return nil end
	-- the glyphs you have in any socket, and how many sockets of each kind are open
	local have, open = {}, nil
	if GetGlyphSocketInfo then
		open = { major = 0, minor = 0 }
		for i = 1, 6 do
			local enabled, kind, spell = GetGlyphSocketInfo(i)
			if enabled then
				local k = kind == 1 and "major" or "minor"
				open[k] = open[k] + 1
			end
			if spell then have[spell] = true end
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
					hint = hint or ("Better with the " .. g.talent .. " talent: " .. g.name)
				else
					table.insert(slots, { glyph = g, equipped = have[g.spell], hint = hint, order = #slots + 1 })
					hint = nil
				end
			end
		end
		-- The ones you have take the sockets you've opened, whichever socket they're in; the rest fill the
		-- others, then the sockets still to open.
		table.sort(slots, function (a, b)
			if (a.equipped and 1 or 0) ~= (b.equipped and 1 or 0) then return a.equipped and true or false end
			return a.order < b.order
		end)
		for i, s in ipairs(slots) do
			s.unlock = G.GLYPH_LEVELS[kind][i]
			if open then s.locked = i > open[kind] else s.locked = P.realLevel < s.unlock end
		end
		out[kind] = slots
	end
	return out
end

-----------------------------------------
-- consumables

-- Your spec's consumables: { { id, note, sources, count } }, or nil without a hand-picked list.
function G.ConsumablesFor()
	local list = G.consumables and G.consumables[P.profileKey]
	if not list then return nil end
	local out = {}
	for _, t in ipairs(list) do
		local x = G.extraItems[t[1]]
		local srcs = {}
		for _, s in ipairs(x and x[4] or {}) do
			local src = G.ReadSource(s)
			if src then table.insert(srcs, src) end
		end
		table.sort(srcs, function (a, b)
			if a.open ~= b.open then return a.open end
			return (a.tier or 0) < (b.tier or 0)
		end)
		table.insert(out, { id = t[1], note = t[2] ~= "" and t[2] or nil, sources = srcs, name = x and x[1],
			count = GetItemCount and GetItemCount(t[1]) or 0 })
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
	end
	return v, why
end
