-- The Journal's Gear tab: for your spec, every slot's way from what you wear to the best Classic has, a step at
-- a time, and where to go next for the most upgrades. Engine.lua works it all out; this draws it.
--
-- Your progression stage and the raids' entrances and bosses come from the Journal (EvilTactician's fork) and
-- mod-individual-progression, so a step for a raid you haven't opened shows as what's next, not as a goal.

local J = Journal
local G = JournalGearBIS

if not (J and J.RegisterTab and (J.API or 0) >= 1 and J.CreateInset and J.CreateScrollArea and J.CreatePool
		and G and G.Build) then return end

local rowName
local setShown = J.SetShown or function (f, shown) if shown then f:Show() else f:Hide() end end

local STAGE_QUEST = 66000
local MAX_STAGE = 18
local DIFFICULTY = { "|cff40ff40Easy|r", "|cffffd200Medium|r", "|cffff7f3fHard|r" }

-----------------------------------------
-- your progression stage: the realm's, or a later one the client already knows of

local completed, haveCompleted = {}, false

local function stage()
	if not J.Has(J.HELLO_PROGRESSION) then return MAX_STAGE end
	local s = J.state or MAX_STAGE
	if haveCompleted then
		for i = MAX_STAGE, 1, -1 do
			if completed[STAGE_QUEST + i] then
				if i > s then s = i end
				break
			end
		end
	end
	return s
end

-----------------------------------------
-- text

local enchantTooltip, glyphTooltip, professionTooltip, ENCHANT_COLOURS

local function itemName(t)
	local name, _, quality = GetItemInfo(t.id)
	if not name then J.QueryItem(t.id) end
	local _, _, _, hex = J.QualityColor(quality or t.quality)
	return (hex or "|cffffffff") .. (name or t.name) .. "|r"
end

local function runs(chance)
	if not chance or chance <= 0 then return "" end
	if chance >= 0.9 then return "always drops" end
	return "about 1 in " .. math.max(2, math.floor(1 / chance + 0.5)) .. (chance >= 0.5 and " kills" or " runs")
end

-- A source line's guidance after its "where": " - about 1 in 5 runs", greyed.
local function hint(text)
	return "  |cff9d9d9d- " .. text .. "|r"
end

-- An instance's name and what it is: "Scholomance (dungeon)", "Molten Core (raid)". Dungeon names are blue and
-- raid names purple, like loot; resume is the colour the text after the name goes back to.
local DUNGEON_COLOUR, RAID_COLOUR = "|cff0070dd", "|cffa335ee"
local function place(g, resume)
	if not g then return "" end
	local raid = G.IsRaid(g)
	return (raid and RAID_COLOUR or DUNGEON_COLOUR) .. g.name .. (resume or "|r") .. (raid and " (raid)" or " (dungeon)")
end

-- How to get it, in one line.
function G.SourceText(src)
	local g = src.inst and G.instances[src.inst]
	if src.kind == "D" or src.kind == "C" then
		-- a boss to know about first (summoned, or one of several that take turns): its tag
		local note = G.sourceNotes and G.sourceNotes[src.who]
		return src.who .. " in " .. place(g) .. hint(runs(src.chance)) .. (note and hint(note[1]) or "")
	elseif src.kind == "Q" then
		local t = (src.chain or 1) > 1 and ("Quest chain starting with " .. src.startName) or ("Quest: " .. src.who)
		if src.trainer then
			t = t .. hint("from your class trainer")
		elseif (src.givers or 1) > 1 and not g then
			t = t .. hint("from several quest givers")
		elseif (src.givers or 1) == 0 and not g then
			t = t .. hint("starts from an item")
		end
		if g and G.IsRaid(g) then return t .. hint("needs an item from " .. place(g, "|cff9d9d9d")) end
		if g then return t .. hint(place(g, "|cff9d9d9d")) end
		return t
	elseif src.kind == "W" then
		local t = "World drop from level " .. src.lo .. (src.hi > src.lo and ("-" .. src.hi) or "") .. " mobs"
			.. hint("about 1 in " .. math.max(2, math.floor(1 / src.chance + 0.5)) .. " kills")
		if src.boe then t = t .. hint("or buy it at the Auction House") end
		return t
	elseif src.kind == "V" then
		local t = "Sold by " .. src.who
		if (src.rep or 0) > 0 then
			t = t .. hint((G.STANDINGS[src.rank] or "?") .. " with " .. (G.FACTIONS[src.rep] or "a faction"))
		end
		if (src.price or 0) > 0 and J.Money then t = t .. "  " .. J.Money(src.price) end
		return t
	elseif src.kind == "X" then
		local t = src.who .. (src.rank and (" (" .. src.rank .. ")") or "")
		if src.where then t = t .. hint(src.where) end
		if src.bop then t = t .. hint("binds on pickup: you make it yourself") end
		return t
	end
	return ""
end

local function gainText(c, owned)
	if owned <= 0 then return "|cff40ff40new|r" end
	local pct = math.floor((c.value / owned - 1) * 100 + 0.5)
	return "|cff40ff40+" .. math.max(1, pct) .. "%|r"
end

-----------------------------------------
-- opening a step's source in the Journal

-- The Journal can open a quest in its Quests tab (Journal.API 2, on a realm with the Quests tab).
local function canOpenQuest()
	return (J.API or 0) >= 2 and J.OpenQuest and J.Has(J.HELLO_QUESTS)
end

-- What clicking a step does, for its tooltip; nil when it does nothing.
local function clickText(c)
	local src = c.src
	local g = src.inst and G.instances[src.inst]
	if src.kind == "Q" and canOpenQuest() then
		return "Click to open the quest in the Journal."
	elseif (src.kind == "D" or src.kind == "C") and g then
		return "Click to open " .. src.who:gsub(",.*", "") .. "'s loot in the Journal."
	elseif src.kind == "Q" and g then
		return "Click to open " .. g.name .. "'s quests in the Journal."
	elseif src.kind == "Q" and (src.givers or 1) ~= 1 then
		return nil
	elseif src.kind == "Q" and J.Has(J.HELLO_MAP_PINS) and J.ShowOnMap then
		return "Click to mark where the quest starts on your map."
	end
	return nil
end

local openSource

-- A quest opens in the Journal's Quests tab; when the tab doesn't list it, or the realm can't open
-- quests, the click does what it did before (the instance's quests, or the chain's start on the map).
local function openQuest(c)
	return canOpenQuest() and J.OpenQuest(c.src.quest, function (shown)
		if not shown then openSource(c, true) end
	end)
end

function openSource(c, notInQuestsTab)
	local src = c.src
	local g = src.inst and G.instances[src.inst]
	if src.kind == "Q" and not notInQuestsTab and openQuest(c) then return end
	if src.kind == "Q" and not g then
		-- One giver can be marked; with several (a trainer in every city) the Journal can't pick yours.
		if (src.givers or 1) == 1 and J.Has(J.HELLO_MAP_PINS) and J.ShowOnMap then
			DEFAULT_CHAT_FRAME:AddMessage("|cffffd200Journal: Gear|r marked where " .. ((src.chain or 1) > 1 and "the quest chain" or "the quest")
				.. " |cffffffff" .. src.startName .. "|r starts on your map.")
			J.ShowOnMap("Q", src.start or src.quest)
		end
		return
	end
	if not g then return end
	local function open(extra)
		if g.journalId then J.OpenInstance(g.journalId, extra) end
	end
	if src.kind == "Q" then
		open({ tab = "quests" })
	elseif J.Search then
		-- The Journal's own loot search knows the boss; without it, the instance's loot.
		local name = GetItemInfo(c.item.id) or c.item.name
		J.Search(name, function (results)
			for _, r in ipairs(results or {}) do
				if r.kind == "L" and r.item == c.item.id then
					J.OpenInstance(r.instance, { boss = r.boss, variant = r.variant, tab = "loot" })
					return
				end
			end
			open({ tab = "loot" })
		end)
	else
		open({ tab = "loot" })
	end
end

-----------------------------------------
-- the tab

local function build(panel)
	JournalGearBISCharDB = JournalGearBISCharDB or {}
	local db = JournalGearBISCharDB
	local view

	local status = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	status:SetPoint("CENTER", panel, "CENTER", 0, 20)
	status:SetWidth(540)
	local statusSub = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	statusSub:SetPoint("TOP", status, "BOTTOM", 0, -10)
	statusSub:SetWidth(540)

	local body = CreateFrame("Frame", nil, panel)
	body:SetAllPoints(panel)

	-- top: the list's title, whose talents it's for, and the choice of list

	-- The title reads "Classic gear: <spec> <class>  <role>". The spec is a button: click it for any of your
	-- class's lists (a gold arrow after it says so), the one your talents pick marked.
	local title = body:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", body, "TOPLEFT", 8, -8)
	title:SetJustifyH("LEFT")
	title:SetText("Classic gear:")
	local specButton = CreateFrame("Button", nil, body)
	specButton:SetHeight(20)
	specButton:SetPoint("LEFT", title, "RIGHT", 5, 0)
	specButton.text = specButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	specButton.text:SetPoint("LEFT", specButton, "LEFT", 0, 0)
	specButton.arrow = specButton:CreateTexture(nil, "OVERLAY")
	specButton.arrow:SetSize(14, 14)
	specButton.arrow:SetPoint("LEFT", specButton.text, "RIGHT", 2, -1)
	specButton.arrow:SetTexture("Interface\\Buttons\\Arrow-Down-Up")
	local specGlow = specButton:CreateTexture(nil, "HIGHLIGHT")
	specGlow:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	specGlow:SetBlendMode("ADD")
	specGlow:SetVertexColor(1, 0.82, 0, 0.35)
	specGlow:SetAllPoints(specButton)
	local titleTail = body:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	titleTail:SetJustifyH("LEFT")
	-- what each role's called on the title
	local ROLE_LABEL = { ["Melee damage"] = "Melee DPS", ["Spell damage"] = "Ranged DPS", ["Ranged damage"] = "Ranged DPS" }
	-- roles that share a tree (Feral cat and bear): their own names, not the tree's
	local function sharedRole(k)
		for from, swap in pairs(G.ROLE_TALENT or {}) do
			if k == from or k == swap[2] then return true end
		end
		return false
	end
	local note = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	note:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	note:SetPoint("RIGHT", body, "RIGHT", -230, 0)
	note:SetJustifyH("LEFT")
	note:SetTextColor(0.8, 0.8, 0.8)

	local render
	-- every list for your class: each talent tree by name, and a role that shares one (Feral bear) after it
	local function specChoices()
		local _, class = UnitClass("player")
		local active = GetActiveTalentGroup and GetActiveTalentGroup() or 1
		local mine, _, mineTree = G.TalentProfile(active)
		local out = {}
		for i, k in ipairs(G.byTree[class] or {}) do
			local tabName = GetTalentTabInfo(i)
			local swap = G.ROLE_TALENT[k]
			table.insert(out, { label = swap and G.profiles[k].name or tabName, value = "tree:" .. i,
				mine = (i == mineTree and mine == k) })
			if swap then
				table.insert(out, { label = G.profiles[swap[2]].name, value = swap[2],
					mine = (i == mineTree and mine == swap[2]) })
			end
		end
		return out
	end
	local specMenu = CreateFrame("Frame", "JournalGearBISSpecMenu", UIParent, "UIDropDownMenuTemplate")
	local function openSpecMenu(self)
		local list = { { text = "Show the list for", isTitle = true, notCheckable = true } }
		local current = db.choice or "active"
		local function add(text, value)
			table.insert(list, { text = text, checked = current == value, func = function ()
				db.choice = value
				G.MarkTipsDirty()
				CloseDropDownMenus()
				render()
			end })
		end
		for _, c in ipairs(specChoices()) do
			if c.mine then
				add(c.label .. "  |cff9d9d9d(your talents)|r", "active")
			else
				add(c.label, c.value)
			end
		end
		if (GetNumTalentGroups and GetNumTalentGroups() or 1) > 1 then
			local active = GetActiveTalentGroup and GetActiveTalentGroup() or 1
			local _, otree = G.TalentProfile(active == 1 and 2 or 1)
			add("My other talents (" .. (otree or "none yet") .. ")", "other")
		end
		EasyMenu(list, specMenu, self, 0, 0, "MENU")
	end
	specButton:SetScript("OnClick", function (self)
		if self.choices then openSpecMenu(self) end
	end)
	specButton:SetScript("OnEnter", function (self)
		if not self.choices then return end
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:AddLine("Click to see another list for your class.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	specButton:SetScript("OnLeave", function () GameTooltip:Hide() end)

	-- A level 80 talent build for the list's spec, saved to DragonUI's talent builds: only with a DragonUI that
	-- offers other addons a way to save one (DragonUI.API.SaveTalentBuild).
	local function dragonAPI()
		local api = _G.DragonUI and _G.DragonUI.API
		if type(api) == "table" and type(api.SaveTalentBuild) == "function" then return api end
		return nil
	end
	-- the build's ranks by DragonUI's talent order (the client's): { [tree] = { [talent index] = rank } }
	local function buildRanks(b)
		local ranks = {}
		for tab, list in ipairs(b.ranks) do
			local at = {}
			for i = 1, (GetNumTalents(tab) or 0) do
				local _, _, tier, column = GetTalentInfo(tab, i)
				if tier then at[tier .. ":" .. column] = i end
			end
			ranks[tab] = {}
			for _, x in ipairs(list) do
				local i = at[x[1] .. ":" .. x[2]]
				if not i then return nil end
				ranks[tab][i] = x[3]
			end
		end
		return ranks
	end
	local talentButton = CreateFrame("Button", nil, body)
	talentButton:SetSize(20, 20)
	talentButton.icon = talentButton:CreateTexture(nil, "ARTWORK")
	talentButton.icon:SetAllPoints(talentButton)
	talentButton.icon:SetTexture("Interface\\Icons\\INV_Misc_Book_11")
	talentButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	local function talentSaved(b)
		local api, ranks = dragonAPI(), buildRanks(b)
		return api and ranks and type(api.HasTalentBuild) == "function" and api.HasTalentBuild(b.class, b.name, ranks)
	end
	talentButton:SetScript("OnEnter", function (self)
		local b = self.build
		if not b then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine("Talent build: " .. b.name)
		if talentSaved(b) then
			GameTooltip:AddLine("Already in DragonUI's talent builds.", 0.25, 1, 0.25, true)
		else
			GameTooltip:AddLine("Click to save this level 80 build to DragonUI's talent builds, where you can "
				.. "follow it as a plan. Below level 80, spend your points along it as far as they go.", 1, 1, 1, true)
		end
		GameTooltip:AddLine("From Warcraft Tavern's guide for the spec.", 0.6, 0.6, 0.6, true)
		GameTooltip:Show()
	end)
	talentButton:SetScript("OnLeave", function () GameTooltip:Hide() end)
	talentButton:SetScript("OnClick", function (self)
		local b, api = self.build, dragonAPI()
		if not b or not api then return end
		local ranks = buildRanks(b)
		local tag = "|cffffd100GearBIS:|r "
		if not ranks then
			DEFAULT_CHAT_FRAME:AddMessage(tag .. "this build doesn't fit your talent trees, so it wasn't saved.")
			return
		end
		local result, err = api.SaveTalentBuild(b.class, b.name, ranks, 80)
		if result == "exists" then
			DEFAULT_CHAT_FRAME:AddMessage(tag .. b.name .. " is already in DragonUI's talent builds.")
		elseif result then
			DEFAULT_CHAT_FRAME:AddMessage(tag .. "Saved " .. b.name .. " to DragonUI's talent builds.")
		else
			DEFAULT_CHAT_FRAME:AddMessage(tag .. "DragonUI didn't save the build" .. (err and (": " .. err) or "") .. ".")
		end
		if GameTooltip:IsOwned(self) then self:GetScript("OnEnter")(self) end
		self.icon:SetDesaturated(talentSaved(b) and true or false)
	end)

	-- consumables: a row of icons at the top right, each with how to get it on hover
	local consumables = CreateFrame("Frame", nil, body)
	consumables:SetSize(10, 20)
	consumables.label = consumables:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	consumables.label:SetPoint("BOTTOMRIGHT", consumables, "TOPRIGHT", 0, 3)
	consumables.label:SetText("Recommended consumables")
	local consumableIcons = {}
	-- A profession's own consumables (Engineering's explosives): one icon, the items in its tooltip.
	local PROFESSION_ICONS = { [202] = "Interface\\Icons\\Trade_Engineering" }
	function professionTooltip(owner, c)
		local name = G.PROFESSIONS[c.skill]
		GameTooltip:SetOwner(owner, "ANCHOR_BOTTOMLEFT")
		GameTooltip:AddLine(name)
		GameTooltip:AddLine("Extras only " .. name:lower() .. " can use: not needed, but they help.", 0.8, 0.8, 0.8, true)
		for _, it in ipairs(c.items) do
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine((GetItemInfo(it.id)) or it.name or "?", 1, 1, 1)
			GameTooltip:AddLine(it.note, 0.8, 0.8, 0.8, true)
			if not it.usable then
				GameTooltip:AddLine("Needs " .. name .. " " .. it.rank .. " to use.", 1, 0.4, 0.4, true)
			end
			if it.sources[1] then GameTooltip:AddLine(G.SourceText(it.sources[1]), 0.5, 0.85, 1, true) end
			if it.count > 0 then GameTooltip:AddLine("You have " .. it.count .. ".", 0.25, 1, 0.25) end
		end
		GameTooltip:Show()
	end

	local function consumableIcon(i)
		if consumableIcons[i] then return consumableIcons[i] end
		local b = CreateFrame("Button", nil, consumables)
		b:SetSize(20, 20)
		b:SetPoint("LEFT", consumables, "LEFT", (i - 1) * 22, 0)
		b.icon = b:CreateTexture(nil, "ARTWORK")
		b.icon:SetAllPoints(b)
		b:SetScript("OnEnter", function (self)
			local c = self.entry
			if not c then return end
			if c.skill then return professionTooltip(self, c) end
			J.ShowItemTooltip(self, c.id)
			if c.note then GameTooltip:AddLine(c.note, 0.5, 0.85, 1, true) end
			-- elixirs: one battle and one guardian at a time; a flask counts as both. The list is best first, so one
			-- that clashes with an earlier one is that one's cheaper stand-in.
			local kind = G.elixirs and G.elixirs[c.id]
			if kind then
				local before, after, seen = {}, {}, false
				for _, o in ipairs(self.list or {}) do
					if o == c then
						seen = true
					else
						local ok = o.id and G.elixirs[o.id]
						if ok and G.band(ok, kind) ~= 0 then
							table.insert(seen and after or before, (GetItemInfo(o.id)) or o.name or "?")
						end
					end
				end
				GameTooltip:AddLine(kind == 3 and "A flask: it counts as both a battle and a guardian elixir."
					or (kind == 1 and "A battle elixir: one at a time." or "A guardian elixir: one at a time."), 1, 0.82, 0, true)
				if #before == 0 then
					if #after > 0 then
						GameTooltip:AddLine("The best choice. " .. table.concat(after, " or ") .. " is cheaper, but they don't stack: use one.",
							0.25, 1, 0.25, true)
					end
				else
					GameTooltip:AddLine("The cheaper choice: use it instead of " .. table.concat(before, " or ")
						.. ", not with it. They don't stack.", 1, 0.6, 0.2, true)
				end
			end
			if c.count > 0 then GameTooltip:AddLine("You have " .. c.count .. ".", 0.25, 1, 0.25) end
			if #c.sources > 0 then
				GameTooltip:AddLine(" ")
				-- the two best in slot for the main hand: which wins, and against what
			local cmp = e.handsCompare
			if cmp then
				if e.item.inv == 17 then
					GameTooltip:AddLine((cmp.twoWins and "Better than " or "Not quite as good as ") .. cmp.one
						.. (cmp.off and (" with " .. cmp.off) or " with the best off-hand") .. ".", 1, 0.82, 0, true)
				else
					GameTooltip:AddLine("With " .. (cmp.off or "the best off-hand") .. ", "
						.. (cmp.twoWins and "not quite as good as the two-hander" or "better than the two-hander")
						.. ". Until you have that, this and an off-hand are the way.", 1, 0.82, 0, true)
				end
			end
			GameTooltip:AddLine("Where to get it", 1, 0.82, 0)
				-- the ways open to you now; the locked ones only when there are none
				local anyOpen = c.sources[1].open
				local shown = 0
				for _, src in ipairs(c.sources) do
					if shown >= 3 then break end
					if src.open or not anyOpen then
						local t = G.SourceText(src)
						if not src.open then t = t .. "  |cffff6060(Opens at Stage " .. src.stage .. ")|r" end
						GameTooltip:AddLine(t, 1, 1, 1, true)
						shown = shown + 1
					end
				end
			end
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Shift-click links it in chat.", 0.5, 0.85, 1, true)
			GameTooltip:Show()
		end)
		b:SetScript("OnLeave", function () GameTooltip:Hide() end)
		b:SetScript("OnClick", function (self)
			if self.entry and self.entry.id then J.HandleItemClick(self.entry.id, GetItemInfo(self.entry.id)) end
		end)
		consumableIcons[i] = b
		return b
	end

	-- where to go next

	local advice = J.CreateInset(body)
	advice:SetPoint("TOPLEFT", body, "TOPLEFT", 0, -44)
	advice:SetPoint("RIGHT", body, "RIGHT", 0, 0)
	advice:SetHeight(88)
	local adviceTitle = advice:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	adviceTitle:SetPoint("TOPLEFT", advice, "TOPLEFT", 10, -8)
	adviceTitle:SetText("Where to go next")
	local stageText = advice:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	stageText:SetPoint("TOPRIGHT", advice, "TOPRIGHT", -10, -8)
	-- Three lines (Best now, Also good, Raid), each a label and up to two places; a place's items show on
	-- hover.
	local adviceLines = {}
	local adviceNote = advice:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	adviceNote:SetPoint("TOPLEFT", advice, "TOPLEFT", 10, -31)
	adviceNote:SetPoint("RIGHT", advice, "RIGHT", -10, 0)
	adviceNote:SetJustifyH("LEFT")
	local function adviceEntry()
		local b = CreateFrame("Button", nil, advice)
		b:SetHeight(18)
		b.text = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		b.text:SetPoint("LEFT", b, "LEFT", 0, 0)
		b.text:SetJustifyH("LEFT")
		local hl = b:CreateTexture(nil, "HIGHLIGHT")
		hl:SetAllPoints(b)
		hl:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		hl:SetBlendMode("ADD")
		hl:SetVertexColor(1, 1, 1, 0.2)
		b:SetScript("OnClick", function (self)
			local g = self.entry and self.entry.g
			if g and g.journalId then J.OpenInstance(g.journalId) end
		end)
		b:SetScript("OnEnter", function (self)
			local e = self.entry
			if not e then return end
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetText(e.g.name, 1, 0.82, 0)
			GameTooltip:AddLine("Upgrades for you here:", 1, 1, 1)
			for i, c in ipairs(e.items) do
				if i > 10 then break end
				local src
				for _, s in ipairs(c.sources) do
					if s.inst == e.inst then src = s break end
				end
				GameTooltip:AddDoubleLine(itemName(c.item), src and runs(src.chance) or "", 1, 1, 1, 0.6, 0.6, 0.6)
			end
			if e.g.journalId then GameTooltip:AddLine("Click to open it in the Journal.", 0.5, 0.85, 1) end
			GameTooltip:Show()
		end)
		b:SetScript("OnLeave", function () GameTooltip:Hide() end)
		return b
	end
	for i = 1, 3 do
		local line = {}
		line.lead = advice:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		line.lead:SetPoint("LEFT", advice, "TOPLEFT", 10, -19 - i * 18)
		line[1] = adviceEntry()
		line[1]:SetPoint("LEFT", line.lead, "RIGHT", 4, 0)
		line[2] = adviceEntry()
		line[2]:SetPoint("LEFT", line[1], "RIGHT", 0, 0)
		adviceLines[i] = line
	end

	-- the slots

	local list = J.CreateInset(body)
	list:SetPoint("TOPLEFT", advice, "BOTTOMLEFT", 0, -6)
	list:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT", 0, 0)
	local area = J.CreateScrollArea(list)
	area:SetPoint("TOPLEFT", list, "TOPLEFT", 8, -8)
	area:SetPoint("BOTTOMRIGHT", list, "BOTTOMRIGHT", -30, 8)
	area:SetScript("OnMouseWheel", function (self, delta)
		local max = math.max(0, self.content:GetHeight() - self:GetHeight())
		self:SetVerticalScroll(math.max(0, math.min(max, self:GetVerticalScroll() - delta * 60)))
	end)
	local c = area.content

	-- An enchant's tooltip: what's on now, the best you can get and how, and a better one that opens later.
	function enchantTooltip(owner, e)
		if not e then return end
		GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
		GameTooltip:AddLine("Enchant")
		local function effect(o) return G.enchantNames[o.e] and ("  |cff9d9d9d(" .. G.enchantNames[o.e] .. ")|r") or "" end
		local now = e.current ~= 0 and (G.enchantNames[e.current] or "an enchant this list doesn't know") or "nothing"
		GameTooltip:AddLine("On it now: " .. now, 1, 1, 1, true)
		local function ways(o)
			for i, w in ipairs(o.ways) do
				if i > 3 then break end
				GameTooltip:AddLine(G.SourceText(w), 0.8, 0.8, 0.8, true)
			end
			if o.spell then
				GameTooltip:AddLine("An enchanter with the recipe can put it on for you.", 0.8, 0.8, 0.8, true)
			end
			if o.level > (UnitLevel("player") or 0) then
				GameTooltip:AddLine("Requires level " .. o.level .. ".", 1, 0.4, 0.4, true)
			end
		end
		if e.pre then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("|cffffd200Before raids:|r " .. G.EnchantName(e.pre) .. effect(e.pre), 1, 1, 1, true)
			if e.current == e.pre.e then GameTooltip:AddLine("You have it.", 0.25, 1, 0.25) else ways(e.pre) end
		end
		if e.now then
			GameTooltip:AddLine(" ")
			local verdict = e.state == "good" and "|cff40ff40You have the best you can get now.|r"
				or (e.state == "weak" and "|cffffd200A better one you can get now:|r" or "|cffff6060Worth putting on:|r")
			GameTooltip:AddLine(verdict, 1, 1, 1, true)
			if e.state ~= "good" or e.current ~= e.now.e then
				GameTooltip:AddLine(G.EnchantName(e.now) .. effect(e.now), 1, 1, 1, true)
				ways(e.now)
			end
		end
		local function locked(label, o)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("|cff9d9d9d" .. label .. "|r " .. G.EnchantName(o) .. effect(o), 1, 1, 1, true)
			local w = o.ways[1]
			if w and not w.open then
				local g = w.inst and G.instances[w.inst]
				GameTooltip:AddLine(g and ("Opens with " .. g.name .. " (Stage " .. w.stage .. ").") or ("Opens at Stage " .. w.stage .. "."),
					1, 0.4, 0.4, true)
			end
			ways(o)
		end
		if e.next then locked("Next:", e.next) end
		if e.later then locked(e.next and "Best later:" or "Better later:", e.later) end
		GameTooltip:Show()
	end

	-- A glyph's tooltip: the glyph, how to get it, and why it's this one.
	function glyphTooltip(owner, e)
		local g = e.glyph
		J.ShowItemTooltip(owner, g.item)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Where to get it", 1, 0.82, 0)
		GameTooltip:AddLine("Crafted: Inscription (" .. g.rank .. "), or bought from someone who makes it.", 1, 1, 1, true)
		if e.locked then
			GameTooltip:AddLine("This glyph slot opens at level " .. e.unlock .. ".", 1, 0.4, 0.4, true)
		end
		if e.hint then GameTooltip:AddLine(e.hint .. ".", 0.8, 0.8, 0.8, true) end
		if e.swap then
			GameTooltip:AddLine("Better than your " .. e.swap .. ", which is lower on this list: put this one in its socket.",
				1, 0.82, 0, true)
		end
		if e.waits then
			GameTooltip:AddLine("Your socket for this one opens at level " .. e.unlock .. ". Until then, swap it out for "
				.. e.swapFor .. ", and put it back in at level " .. e.unlock .. ".", 1, 0.82, 0, true)
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Shift-click links it in chat.", 0.5, 0.85, 1, true)
		GameTooltip:Show()
	end

	local function makeHeader()
		local h = CreateFrame("Button", nil, c)
		h:SetHeight(24)
		if J.dragon then
			h.band = h:CreateTexture(nil, "BACKGROUND")
			h.band:SetAllPoints(h)
			h.band:SetTexture(0.2, 0.14, 0.04, 0.9)
			h.rule = h:CreateTexture(nil, "BORDER")
			h.rule:SetHeight(1)
			h.rule:SetPoint("BOTTOMLEFT", h, "BOTTOMLEFT")
			h.rule:SetPoint("BOTTOMRIGHT", h, "BOTTOMRIGHT")
			h.rule:SetTexture(1, 0.82, 0, 0.55)
		else
			J.CreateHeaderBand(h)
		end
		h.slot = h:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		h.slot:SetPoint("LEFT", h, "LEFT", 6, 0)
		h.slot:SetWidth(80)
		h.slot:SetJustifyH("LEFT")
		h.icon = h:CreateTexture(nil, "ARTWORK")
		h.icon:SetSize(16, 16)
		h.icon:SetPoint("LEFT", h.slot, "RIGHT", 4, 0)
		h.have = h:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		h.have:SetPoint("LEFT", h.icon, "RIGHT", 4, 0)
		h.have:SetJustifyH("LEFT")
		h.state = h:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		h.state:SetPoint("RIGHT", h, "RIGHT", -6, 0)
		h.state:SetJustifyH("RIGHT")
		-- the enchant for what you wear: its icon in a frame coloured by how you stand
		h.ench = CreateFrame("Button", nil, h)
		h.ench:SetSize(18, 18)
		h.ench:SetPoint("LEFT", h.have, "RIGHT", 8, 0)
		h.ench.frame = h.ench:CreateTexture(nil, "BACKGROUND")
		h.ench.frame:SetAllPoints(h.ench)
		h.ench.icon = h.ench:CreateTexture(nil, "ARTWORK")
		h.ench.icon:SetPoint("TOPLEFT", h.ench, "TOPLEFT", 2, -2)
		h.ench.icon:SetPoint("BOTTOMRIGHT", h.ench, "BOTTOMRIGHT", -2, 2)
		h.ench:SetScript("OnEnter", function (self) enchantTooltip(self, self.enchant) end)
		h.ench:SetScript("OnLeave", function () GameTooltip:Hide() end)
		h:SetScript("OnEnter", function (self)
			if not self.link then return end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetHyperlink(self.link:match("(item:[%-%d:]+)") or self.link)
			GameTooltip:Show()
		end)
		h:SetScript("OnLeave", function () GameTooltip:Hide() end)
		h:SetScript("OnClick", function (self)
			if self.link and IsModifiedClick("CHATLINK") then
				if not ChatEdit_InsertLink(self.link) then ChatFrame_OpenChat(self.link) end
			end
		end)
		return h
	end

	local function makeStep()
		local r = CreateFrame("Button", nil, c)
		r:SetHeight(34)
		r.num = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		r.num:SetPoint("TOPLEFT", r, "TOPLEFT", 4, -4)
		r.num:SetWidth(36)
		r.num:SetJustifyH("LEFT")
		r.icon = r:CreateTexture(nil, "ARTWORK")
		r.icon:SetSize(28, 28)
		r.icon:SetPoint("TOPLEFT", r, "TOPLEFT", 38, -3)
		r.name = r:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		r.name:SetPoint("TOPLEFT", r.icon, "TOPRIGHT", 6, -1)
		r.name:SetJustifyH("LEFT")
		r.source = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		r.source:SetPoint("TOPLEFT", r.name, "BOTTOMLEFT", 0, -3)
		r.source:SetJustifyH("LEFT")
		r.source:SetTextColor(0.75, 0.75, 0.75)
		r.state = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		r.state:SetPoint("TOPRIGHT", r, "TOPRIGHT", -6, -5)
		r.state:SetJustifyH("RIGHT")
		r.how = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		r.how:SetPoint("TOPRIGHT", r.state, "BOTTOMRIGHT", 0, -3)
		r.how:SetJustifyH("RIGHT")
		r.band = r:CreateTexture(nil, "BACKGROUND")
		r.band:SetAllPoints(r)
		local hl = r:CreateTexture(nil, "HIGHLIGHT")
		hl:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		hl:SetBlendMode("ADD")
		hl:SetVertexColor(1, 1, 1, 0.15)
		hl:SetAllPoints(r)
		r:SetScript("OnClick", function (self)
			local e = self.entry
			if not e then return end
			if e.glyph then
				J.HandleItemClick(e.glyph.item, GetItemInfo(e.glyph.item))
				return
			end
			if J.HandleItemClick(e.item.id, GetItemInfo(e.item.id), e.item.quality) then return end
			openSource(e)
		end)
		r:SetScript("OnEnter", function (self)
			local e = self.entry
			if not e then return end
			if e.glyph then return glyphTooltip(self, e) end
			J.ShowItemTooltip(self, e.item.id)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Where to get it", 1, 0.82, 0)
			for i, s in ipairs(e.sources) do
				if i > 4 then break end
				GameTooltip:AddLine(G.SourceText(s), 1, 1, 1, true)
				local note = s.kind == "D" and G.sourceNotes and G.sourceNotes[s.who]
				if note then GameTooltip:AddLine(note[2], 1, 0.82, 0, true) end
			end
			-- gear with only so many uses, unless a hand-written note already says so
			local uses = G.charges and G.charges[e.item.id]
			if uses and not (G.curatedNotes and G.curatedNotes[e.item.id]) then
				GameTooltip:AddLine("Its use effect works " .. uses .. " times; after that it's just its stats.", 1, 0.82, 0, true)
			end
			if e.src.kind == "Q" and (e.src.chain or 1) > 1 then
				GameTooltip:AddLine("It's a quest chain: start with " .. e.src.startName .. " and work through it to "
					.. e.src.who .. ".", 0.8, 0.8, 0.8, true)
			end
			if e.src.kind == "Q" and e.src.trainer then
				GameTooltip:AddLine("Your class trainer in any capital city gives you the first quest.", 0.8, 0.8, 0.8, true)
			elseif e.src.kind == "Q" and (e.src.givers or 1) > 1 and not e.src.inst then
				GameTooltip:AddLine("Several quest givers offer the first quest.", 0.8, 0.8, 0.8, true)
			end
			if e.lock then
				GameTooltip:AddLine(e.lock .. ".", 1, 0.4, 0.4, true)
			elseif e.availableAt then
				GameTooltip:AddLine("Requires level " .. e.availableAt .. ".", 1, 0.4, 0.4, true)
			end
			if e.role == "bis" then
				GameTooltip:AddLine(G.BIS_TEXT[0], 1, 0.82, 0, true)
			end
			if e.curated then GameTooltip:AddLine("A hand-picked item for this spec.", 0.5, 0.85, 1, true) end
			local note = G.curatedNotes and G.curatedNotes[e.item.id]
			if note then GameTooltip:AddLine(note, 1, 0.82, 0, true) end
			GameTooltip:AddLine(" ")
			local click = clickText(e)
			if click then GameTooltip:AddLine(click, 0.5, 0.85, 1, true) end
			GameTooltip:AddLine("Shift-click links it in chat. Ctrl-click tries it on.", 0.5, 0.85, 1, true)
			GameTooltip:Show()
		end)
		r:SetScript("OnLeave", function () GameTooltip:Hide() end)
		return r
	end

	local headers = J.CreatePool(makeHeader)
	local steps = J.CreatePool(makeStep)

	local empty = list:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	empty:SetPoint("TOP", list, "TOP", 0, -60)
	empty:SetWidth(520)

	local function showProblem(problem, sub)
		body:Hide()
		status:SetText(problem)
		statusSub:SetText(sub or "")
		status:Show()
		statusSub:Show()
	end

	local function stepState(e, r)
		if e.equipped then return "|cff40ff40Equipped|r" end
		if e.inBags then return "|cff40ff40In your bags: wear it|r" end
		if not e.open then return "|cffff6060" .. (e.lock or "Locked") .. "|r" end
		if e.availableAt then return "|cffff6060Requires level " .. e.availableAt .. "|r" end
		if view and view.preview then return "" end
		return gainText(e, r.owned.value)
	end
	-- A row's name for this list: "Two-hand" when the list only has two-handers (that's why there's no off-hand
	-- row), and "Relic" or "Wand" for the ranged slot of classes that use those.
	function rowName(row, prof, twoHandOnly)
		if row.key == "MH" then
			-- Two-hand only when the list has no off-hand row (every step a two-hander, and you don't wear a
			-- one-hander that still needs one)
			if prof.weapons == "2h" or twoHandOnly then return "Two-hand" end
		elseif row.key == "RANGED" then
			if prof.ranged == "relic" then return "Relic" end
			if prof.ranged == "wand" then return "Wand" end
		end
		return row.name
	end
	local ROLE = { get = "|cff40ff40Now|r", next = "|cffff6060Next|r", bis = "|cffffd200BiS|r" }
	-- a Now or Next you're not the level for yet
	local SOON = "|cffff9933Soon|r"
	-- an enchant icon's frame: the best on, a weaker one, none, or only one that opens later
	ENCHANT_COLOURS = { good = { 0.25, 1, 0.25 }, weak = { 1, 0.82, 0 }, none = { 1, 0.3, 0.3 }, later = { 0.5, 0.5, 0.5 } }

	render = function ()
		if not panel:IsVisible() then return end
		local level = UnitLevel("player")
		local _, class = UnitClass("player")
		if class == "DEATHKNIGHT" then
			showProblem("Death knights start in Wrath of the Lich King",
				"Gear lists for Wrath of the Lich King come in a later version of Journal: Gear.")
			return
		end
		if G.Phase(level) >= 1 then
			showProblem("On to " .. (G.Phase(level) == 1 and "The Burning Crusade" or "Wrath of the Lich King"),
				"This version has the Classic lists, for levels up to 60. Lists for "
				.. (G.Phase(level) == 1 and "The Burning Crusade" or "Wrath of the Lich King") .. " come in a later version.")
			return
		end
		status:Hide()
		statusSub:Hide()
		body:Show()

		local s = stage()
		local v = G.Build(db.choice or "active", s)
		if not v then
			showProblem("No list for this class", "")
			return
		end
		view = v

		local prof = v.profile
		local className = UnitClass("player")
		local picked = db.choice and db.choice ~= "active" and db.choice ~= "other"
		local noTalents = not v.treeName and not picked
		local spec = noTalents and "" or ((not sharedRole(v.profileKey) and v.treeName) or prof.name)
		local choices = (v.groups > 1) or #specChoices() > 1
		specButton.choices = choices
		specButton.text:SetText(spec)
		setShown(specButton.arrow, choices)
		specButton:SetWidth(specButton.text:GetStringWidth() + (choices and 16 or 0))
		specButton:EnableMouse(choices)
		titleTail:ClearAllPoints()
		titleTail:SetPoint("LEFT", specButton, "RIGHT", spec == "" and -5 or 5, 0)
		titleTail:SetText(className .. "  |cff9d9d9d" .. (ROLE_LABEL[prof.role] or prof.role) .. "|r")
		local lines
		if v.preview then
			lines = "A preview of your gear goals at level " .. v.cap .. ". From level " .. v.readyLevel
				.. ", the list compares them with what you're wearing."
		elseif noTalents then
			lines = "You have no talent points assigned. Please assign your talent points so that this list doesn't guess."
		elseif db.choice == "other" and v.groups > 1 then
			lines = "Your other talents (" .. (v.treeName or "none yet") .. "), compared with the gear you're wearing now, which is likely your active talents' gear."
		elseif db.choice and db.choice ~= "active" and db.choice ~= "other" then
			lines = "The list you picked, compared with the gear you're wearing and carrying."
		else
			lines = "For your talents" .. (v.treeName and (" (" .. v.treeName .. ")") or "")
				.. ", compared with the gear you're wearing and carrying."
		end
		note:SetText(lines)
		-- worded and coloured as the Progression tab has it
		stageText:SetText(J.Has(J.HELLO_PROGRESSION) and ("Your progression stage: |cffffffff" .. s .. "|r")
			or "|cff9d9d9dProgression isn't on for you here|r")
		-- the talent build button: after the menu, or after the title without one
		local _, cls = UnitClass("player")
		local b = G.talentBuilds and (G.talentBuilds[v.profileKey] or G.talentBuilds[cls .. ":" .. (v.treeIndex or 0)])
		talentButton.build = (b and b.class == cls and dragonAPI()) and b or nil
		setShown(talentButton, talentButton.build ~= nil)
		talentButton:ClearAllPoints()
		talentButton:SetPoint("LEFT", titleTail, "RIGHT", 8, 0)
		if talentButton.build then talentButton.icon:SetDesaturated(talentSaved(talentButton.build) and true or false) end

		-- consumables, left of the menu when it's there
		local list = {}
		for _, c in ipairs(v.consumables or {}) do table.insert(list, c) end
		for _, p in ipairs(v.professionConsumables or {}) do
			if #p.items > 0 and PROFESSION_ICONS[p.skill] then table.insert(list, p) end
		end
		consumables:ClearAllPoints()
		consumables:SetPoint("TOPRIGHT", body, "TOPRIGHT", -10, -19)
		consumables:SetWidth(math.max(1, #list * 22 - 2))
		for i, c in ipairs(list) do
			local b = consumableIcon(i)
			b.entry, b.list = c, list
			b.icon:SetTexture(c.skill and PROFESSION_ICONS[c.skill] or (GetItemIcon and GetItemIcon(c.id) or J.ItemIcon(c.id)))
			b:Show()
		end
		for i = #list + 1, #consumableIcons do consumableIcons[i]:Hide() end
		setShown(consumables, #list > 0)

		-- where to go next: two dungeons a line, then the raids
		local groups = {}
		local function group(lead, a, b)
			if a then table.insert(groups, { lead = lead, a, b }) end
		end
		group("|cff40ff40Best now:|r", v.dungeons[1], v.dungeons[2])
		group("|cff40ff40Also good:|r", v.dungeons[3], v.dungeons[4])
		-- a small raid (Upper Blackrock Spire) while it has upgrades for you, then the best big raid
		local small, big
		for _, e in ipairs(v.raids) do
			if G.SMALL_RAIDS[e.inst] then small = small or e else big = big or e end
		end
		group("|cff40ff40Raid:|r", small or big, small and big)
		for i = 1, 3 do
			local line, g = adviceLines[i], groups[i]
			setShown(line.lead, g ~= nil)
			if g then line.lead:SetText(g.lead) end
			for k = 1, 2 do
				local b, e = line[k], g and g[k]
				b.entry = e
				if e then
					local kind = e.raid and ("raid, " .. e.players .. " players") or "dungeon"
					local what = e.count .. (e.count == 1 and " upgrade" or " upgrades")
						.. (e.steps > 0 and (" (" .. e.steps .. " on your list)") or "")
					local gap = (k == 1 and g[2]) and "     |cff9d9d9d|||r" or ""
					b.text:SetText((e.raid and RAID_COLOUR or DUNGEON_COLOUR) .. e.g.name .. "|r |cff9d9d9d(" .. kind
						.. ")|r  -  " .. what .. gap)
					b:SetWidth(b.text:GetStringWidth() + (gap ~= "" and 16 or 0))
					b:Show()
				else
					b:Hide()
				end
			end
		end
		adviceNote:SetText(#groups == 0 and ("|cff9d9d9d" .. (v.adviceNote or "") .. "|r") or "")
		setShown(adviceNote, #groups == 0)

		-- the slots
		headers:Reset()
		steps:Reset()
		local width = math.max(300, area:GetWidth() - 8)
		local y = 0
		for _, r in ipairs(v.rows) do
			if not r.hidden then
				local h = headers:Get()
				h:ClearAllPoints()
				h:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y)
				h:SetWidth(width)
				h.slot:SetText(rowName(r.row, v.profile, r.twoHandOnly))
				local have = r.owned.weak or r.owned.strong
				h.link = have and have.worn.link
				if have then
					h.icon:SetTexture(GetItemIcon and GetItemIcon(have.id) or J.ItemIcon(have.id))
					h.icon:Show()
					local text = have.worn.link:gsub("[%[%]]", "")
					-- rings and trinkets: both you wear
					if r.row.pair and #r.owned.all == 2 then
						text = r.owned.all[1].worn.link:gsub("[%[%]]", "") .. ", " .. r.owned.all[2].worn.link:gsub("[%[%]]", "")
					end
					h.have:SetText(text)
				else
					h.icon:Hide()
					h.have:SetText("|cff9d9d9dNothing equipped|r")
				end
				local ench = r.enchant
				h.ench.enchant = ench
				if ench then
					local o = ench.now or ench.next or ench.later
					h.ench.icon:SetTexture(G.EnchantIcon(o))
					h.ench.icon:SetDesaturated(ench.state == "later")
					local c = ENCHANT_COLOURS[ench.state]
					h.ench.frame:SetTexture(c[1], c[2], c[3], 0.9)
					h.ench:Show()
				else
					h.ench:Hide()
				end
				local open = 0
				for _, e in ipairs(r.steps) do if e.open then open = open + 1 end end
				if r.withOneHander then
					-- the main hand mixes one- and two-handers: an off-hand only goes with the one-handers
					h.state:SetText("|cff9d9d9dWith a one-hander only|r")
				elseif v.preview then
					h.state:SetText("")
				elseif r.best and have then
					h.state:SetText("|cff40ff40" .. G.BIS_TEXT[0] .. "|r")
				elseif open == 0 and #r.steps > 0 then
					h.state:SetText("|cff40ff40Best you can get now|r")
				elseif open > 0 then
					h.state:SetText(open .. (open == 1 and " upgrade now" or " upgrades now"))
				else
					h.state:SetText("")
				end
				y = y + 26

				for i, e in ipairs(r.steps) do
					local st = steps:Get()
					st.entry = e
					st:ClearAllPoints()
					st:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y)
					st:SetWidth(width)
					st.num:SetText((e.soon and e.role ~= "bis" and SOON) or ROLE[e.role] or "")
					st.icon:SetTexture(GetItemIcon and GetItemIcon(e.item.id) or J.ItemIcon(e.item.id))
					st.icon:SetDesaturated(not e.open)
					-- the main hand mixes one- and two-handers: which this one is
					local hands = ""
					if r.mixedHands or e.handsCompare then
						local cmp = e.handsCompare
						local wins = cmp and ((e.item.inv == 17) == cmp.twoWins)
						hands = (e.item.inv == 17 and "two-hand" or "one-hand, with an off-hand") .. (wins and ": the better choice" or "")
						hands = "  |cff9d9d9d(" .. hands .. ")|r"
					end
					st.name:SetText(itemName(e.item) .. hands)
					st.name:SetWidth(width - 230)
					-- an optional extra (Manual Crowd Pummeler) says so on its line too, not just in its tooltip
					local note = G.curatedNotes and G.curatedNotes[e.item.id]
					st.source:SetText(G.SourceText(e.src) .. ((note and note:find("^Optional")) and hint("optional") or ""))
					st.source:SetWidth(width - 230)
					st.state:SetText(stepState(e, r))
					st.how:SetText(DIFFICULTY[G.Difficulty(e.src)] or "")
					if e.open then st.band:SetTexture(1, 1, 1, 0.03) else st.band:SetTexture(0.5, 0.1, 0.1, 0.12) end
					y = y + 36
				end
				if #r.steps == 0 and not r.best then
					-- nothing listed: an empty slot with no candidates (a relic, say)
					y = y + 2
				end
				y = y + 6
			end
		end
		-- glyphs: the best of each kind for your spec, in the order the slots open
		if #v.rows > 0 then
			local h = headers:Get()
			h:ClearAllPoints()
			h:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y)
			h:SetWidth(width)
			h.slot:SetText("Glyphs")
			h.link, h.ench.enchant = nil, nil
			h.icon:Hide()
			h.ench:Hide()
			local missing = 0
			for _, kind in ipairs({ "major", "minor" }) do
				for _, gs in ipairs(v.glyphs and v.glyphs[kind] or {}) do
					if not gs.equipped and not gs.locked then missing = missing + 1 end
				end
			end
			if not v.glyphs then
				h.have:SetText("|cff9d9d9dHand-picked glyphs for this spec come in a later version.|r")
				h.state:SetText("")
			else
				h.have:SetText("")
				h.state:SetText(missing == 0 and "|cff40ff40All set|r" or (missing .. (missing == 1 and " to get" or " to get")))
			end
			y = y + 26
			for _, kind in ipairs({ "major", "minor" }) do
				for _, gs in ipairs(v.glyphs and v.glyphs[kind] or {}) do
					local g = gs.glyph
					local st = steps:Get()
					st.entry = gs
					st:ClearAllPoints()
					st:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y)
					st:SetWidth(width)
					st.num:SetText(kind == "major" and "Major" or "Minor")
					st.icon:SetTexture(GetItemIcon and GetItemIcon(g.item) or J.ItemIcon(g.item))
					st.icon:SetDesaturated(gs.locked)
					local name = GetItemInfo(g.item)
					if not name then J.QueryItem(g.item) end
					st.name:SetText("|cffffffff" .. (name or g.name) .. "|r")
					st.name:SetWidth(width - 230)
					st.source:SetText("Crafted: Inscription (" .. g.rank .. ")" .. (gs.hint and hint(gs.hint) or ""))
					st.source:SetWidth(width - 230)
					if gs.locked then
						st.state:SetText("|cffff6060Requires level " .. gs.unlock .. "|r")
					elseif gs.equipped then
						st.state:SetText("|cff40ff40Equipped|r")
					elseif gs.swap then
						st.state:SetText("|cffff9933Swap in|r")
					else
						st.state:SetText("|cffff9933Missing|r")
					end
					-- a swap: which one to take out, and which one waits for its socket
					if gs.swap then
						st.how:SetText("|cffff9933Instead of " .. gs.swap .. "|r")
					elseif gs.waits then
						st.how:SetText("|cffff6060Its socket opens at level " .. gs.unlock .. "|r")
					else
						st.how:SetText("")
					end
					if gs.locked then st.band:SetTexture(0.5, 0.1, 0.1, 0.12) else st.band:SetTexture(1, 1, 1, 0.03) end
					y = y + 36
				end
			end
			y = y + 6
		end
		area:SetContentHeight(y)
		setShown(empty, #v.rows == 0)
	end

	local function load()
		-- The lists work without the realm's help; the stage and the Journal links need it.
		G.LearnInstances()
		if QueryQuestsCompleted and not haveCompleted then QueryQuestsCompleted() end
		render()
	end

	local function shown() return panel:IsVisible() end
	local function later(delay)
		J.Debounce("gearbis-render", delay or 0.3, function () if shown() then render() end end)
	end

	-- what changes the list; enchanting what you wear (UNIT_INVENTORY_CHANGED) and glyphs too, only while the
	-- tab shows
	local events = CreateFrame("Frame")
	for _, e in ipairs({ "PLAYER_EQUIPMENT_CHANGED", "BAG_UPDATE", "PLAYER_LEVEL_UP", "ACTIVE_TALENT_GROUP_CHANGED",
			"CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE", "QUEST_QUERY_COMPLETE", "UNIT_INVENTORY_CHANGED",
			"GLYPH_ADDED", "GLYPH_REMOVED", "GLYPH_UPDATED" }) do
		events:RegisterEvent(e)
	end
	events:SetScript("OnEvent", function (self, event, unit)
		if event == "UNIT_INVENTORY_CHANGED" and unit ~= "player" then return end
		if event == "QUEST_QUERY_COMPLETE" then
			local done = {}
			if GetQuestsCompleted then GetQuestsCompleted(done) end
			completed, haveCompleted = done, true
		end
		if shown() then later(event == "BAG_UPDATE" and 0.8 or 0.3) end
	end)
	J.On("ITEM_INFO", function () if shown() then later(0.5) end end)
	J.On("READY", function () if shown() then load() end end)
	J.On("NO_SERVER", function () if shown() then load() end end)
	J.On("QUESTS_CHANGED", function ()
		if shown() then J.Debounce("gearbis-completed", 3.0, function () if QueryQuestsCompleted then QueryQuestsCompleted() end end) end
	end)

	return load
end

-----------------------------------------
-- item tooltips everywhere: "On your gear list: Roll Need" on an item that's an upgrade for you, and on a
-- token that becomes one. Worked out for your active talents (or the role you picked), and kept until your
-- gear, bags, level, talents or stage change.

local tipView, tipDirty = nil, true

local function viewForTips()
	if tipDirty or not tipView then
		local db = JournalGearBISCharDB or {}
		local choice = (db.choice == "other") and "active" or db.choice
		if not G.learned then
			G.learned = true
			G.LearnInstances()
		end
		local _, class = UnitClass("player")
		if class == "DEATHKNIGHT" or G.Phase(UnitLevel("player")) ~= 0 then
			tipView = nil
		else
			tipView = G.Build(choice or "active", stage())
		end
		tipDirty = false
	end
	return tipView
end

-- The line goes in on the next frame, so it comes after every other addon's lines (Pawn's included).
local pending = {}
local adder = CreateFrame("Frame")
adder:Hide()
adder:SetScript("OnUpdate", function (self)
	self:Hide()
	for tip, e in pairs(pending) do
		pending[tip] = nil
		local _, link = tip:GetItem()
		if tip:IsShown() and link == e.link then
			tip:AddLine("|cffffd200On your gear list:|r |cff00ff00Roll Need|r")
			if e.becomes then
				local names = {}
				for _, other in ipairs(e.becomes) do
					table.insert(names, GetItemInfo(other) or (G.Item(other) and G.Item(other).name) or ("item " .. other))
				end
				tip:AddLine("Exchange it for: " .. table.concat(names, ", "), 1, 1, 1, true)
			end
			tip:Show()
		end
	end
end)

local function onTooltipItem(tip)
	local _, link = tip:GetItem()
	local id = link and tonumber(link:match("item:(%d+)"))
	if not id then return end
	local ok, row, becomes = pcall(function () return G.Verdict(viewForTips(), id) end)
	if not ok or not (row or becomes) then return end
	pending[tip] = { link = link, becomes = becomes }
	adder:Show()
end
local function onTooltipCleared(tip) pending[tip] = nil end

for _, tip in ipairs({ GameTooltip, ItemRefTooltip }) do
	if tip then
		tip:HookScript("OnTooltipSetItem", onTooltipItem)
		tip:HookScript("OnTooltipCleared", onTooltipCleared)
	end
end

local tipEvents = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_EQUIPMENT_CHANGED", "BAG_UPDATE", "PLAYER_LEVEL_UP", "ACTIVE_TALENT_GROUP_CHANGED",
		"CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE", "QUEST_QUERY_COMPLETE", "PLAYER_ENTERING_WORLD" }) do
	tipEvents:RegisterEvent(e)
end
tipEvents:SetScript("OnEvent", function () tipDirty = true end)
J.On("READY", function () tipDirty = true end)
G.MarkTipsDirty = function () tipDirty = true end

local load
Journal.RegisterTab({
	key = "gear", name = "Gear", order = 23, icon = "Interface\\Icons\\INV_Chest_Plate16",
	build = function (panel) load = build(panel) end,
	onShow = function () if load then load() end end,
})

SLASH_JOURNALGEARBIS1 = "/gear"
SLASH_JOURNALGEARBIS2 = "/bis"
SlashCmdList.JOURNALGEARBIS = function () J.ToggleSection("gear") end
