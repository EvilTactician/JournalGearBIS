-- The Journal's Gear tab: for your spec, every slot's way from what you wear to the best Classic has, a step at
-- a time, and where to go next for the most upgrades. Engine.lua works it all out; this draws it.
--
-- Your progression stage and the raids' entrances and bosses come from the Journal (mod-forever-journal) and
-- mod-individual-progression, so a step for a raid you haven't opened shows as what's next, not as a goal.

local J = Journal
local G = JournalGearBIS

if not (J and J.RegisterTab and (J.API or 0) >= 1 and J.CreateInset and J.CreateScrollArea and J.CreatePool
		and G and G.Build) then return end

local setShown = J.SetShown or function (f, shown) if shown then f:Show() else f:Hide() end end

local STAGE_QUEST = 66000
local MAX_STAGE = 18
local EXPANSION_NEXT = { [0] = "The Burning Crusade", [1] = "Wrath of the Lich King" }
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

-- How to get it, in one line.
function G.SourceText(src)
	local g = src.inst and G.instances[src.inst]
	local where = g and g.name or ""
	if src.kind == "D" then
		return src.who .. " - " .. where .. "  |cff9d9d9d(" .. runs(src.chance) .. ")|r"
	elseif src.kind == "C" then
		return src.who .. " - " .. where .. "  |cff9d9d9d(" .. runs(src.chance) .. ")|r"
	elseif src.kind == "Q" then
		if g and g.raid then return "Quest: " .. src.who .. "  |cff9d9d9d(needs an item from " .. where .. ")|r" end
		if g then return "Quest: " .. src.who .. "  |cff9d9d9d(" .. where .. ")|r" end
		return "Quest: " .. src.who
	elseif src.kind == "V" then
		local t = "Sold by " .. src.who
		if (src.rep or 0) > 0 then
			t = t .. "  |cff9d9d9d(" .. (G.STANDINGS[src.rank] or "?") .. " with " .. (G.FACTIONS[src.rep] or "a faction") .. ")|r"
		end
		if (src.price or 0) > 0 and J.Money then t = t .. "  " .. J.Money(src.price) end
		return t
	elseif src.kind == "X" then
		return src.who
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

local function openSource(c)
	local src = c.src
	if src.kind == "Q" and src.quest and not src.inst then
		if J.Has(J.HELLO_MAP_PINS) and J.ShowOnMap then J.ShowOnMap("Q", src.quest) end
		return
	end
	local g = src.inst and G.instances[src.inst]
	if not g then return end
	local function open(boss, variant)
		if g.journalId then J.OpenInstance(g.journalId, { boss = boss, variant = variant }) end
	end
	-- The Journal's own loot search knows the boss and the tab; without it, the instance's page.
	if J.Search and (src.kind == "D" or src.kind == "C") then
		local name = GetItemInfo(c.item.id) or c.item.name
		J.Search(name, function (results)
			for _, r in ipairs(results or {}) do
				if r.kind == "L" and r.item == c.item.id then
					J.OpenInstance(r.instance, { boss = r.boss, variant = r.variant })
					return
				end
			end
			open()
		end)
	else
		open()
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

	local title = body:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", body, "TOPLEFT", 8, -8)
	title:SetJustifyH("LEFT")
	local note = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	note:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	note:SetPoint("RIGHT", body, "RIGHT", -230, 0)
	note:SetJustifyH("LEFT")
	note:SetTextColor(0.8, 0.8, 0.8)

	local render
	local choose = J.CreateDropdown(body, 210, function ()
		local list = {}
		local _, class = UnitClass("player")
		local function add(text, value)
			table.insert(list, { text = text, checked = (db.choice or "active") == value, func = function ()
				db.choice = value
				CloseDropDownMenus()
				render()
			end })
		end
		table.insert(list, { text = "Show the list for", isTitle = true, notCheckable = true })
		local active = GetActiveTalentGroup and GetActiveTalentGroup() or 1
		local key, tree = G.TalentProfile(active)
		add("My talents: " .. (tree or "-") .. (key and (" (" .. G.profiles[key].name .. ")") or ""), "active")
		if (GetNumTalentGroups and GetNumTalentGroups() or 1) > 1 then
			local other = active == 1 and 2 or 1
			local okey, otree = G.TalentProfile(other)
			add("My other talents: " .. (otree or "none yet") .. (okey and (" (" .. G.profiles[okey].name .. ")") or ""), "other")
		end
		table.insert(list, { text = "Or a role", isTitle = true, notCheckable = true })
		local keys = {}
		for k, p in pairs(G.profiles) do
			if p.class == class then table.insert(keys, k) end
		end
		table.sort(keys)
		for _, k in ipairs(keys) do add(G.profiles[k].name .. "  |cff9d9d9d" .. G.profiles[k].role .. "|r", k) end
		return list
	end)
	choose:SetPoint("TOPRIGHT", body, "TOPRIGHT", -8, -8)

	-- where to go next

	local advice = J.CreateInset(body)
	advice:SetPoint("TOPLEFT", body, "TOPLEFT", 0, -44)
	advice:SetPoint("RIGHT", body, "RIGHT", 0, 0)
	advice:SetHeight(76)
	local adviceTitle = advice:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	adviceTitle:SetPoint("TOPLEFT", advice, "TOPLEFT", 10, -8)
	adviceTitle:SetText("Where to go next")
	local adviceLines = {}
	for i = 1, 3 do
		local b = CreateFrame("Button", nil, advice)
		b:SetHeight(18)
		b:SetPoint("TOPLEFT", advice, "TOPLEFT", 10, -10 - i * 18)
		b:SetPoint("RIGHT", advice, "RIGHT", -10, 0)
		b.text = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		b.text:SetPoint("LEFT", b, "LEFT", 0, 0)
		b.text:SetPoint("RIGHT", b, "RIGHT", 0, 0)
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
		adviceLines[i] = b
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
		r.num = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		r.num:SetPoint("TOPLEFT", r, "TOPLEFT", 10, -4)
		r.num:SetWidth(14)
		r.icon = r:CreateTexture(nil, "ARTWORK")
		r.icon:SetSize(28, 28)
		r.icon:SetPoint("TOPLEFT", r, "TOPLEFT", 28, -3)
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
			if J.HandleItemClick(e.item.id, GetItemInfo(e.item.id), e.item.quality) then return end
			openSource(e)
		end)
		r:SetScript("OnEnter", function (self)
			local e = self.entry
			if not e then return end
			J.ShowItemTooltip(self, e.item.id)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Where to get it", 1, 0.82, 0)
			for i, s in ipairs(e.sources) do
				if i > 4 then break end
				GameTooltip:AddLine(G.SourceText(s), 1, 1, 1, true)
			end
			if e.curated then GameTooltip:AddLine("A best-in-slot pick for this spec.", 0.5, 0.85, 1, true) end
			GameTooltip:AddLine("Click to find it in the Journal. Shift-click links it.", 0.5, 0.85, 1, true)
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
		if e.inBags then return "|cff40ff40In your bags: wear it|r" end
		if not e.open then return "|cffff6060" .. (e.lock or "Locked") .. "|r" end
		return gainText(e, r.owned.value)
	end

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
		title:SetText("Classic gear: " .. prof.name .. "  |cff9d9d9d" .. prof.role .. "|r")
		local lines
		if db.choice == "other" and v.groups > 1 then
			lines = "Your other talents (" .. (v.treeName or "none yet") .. "), compared with the gear you're wearing now, which is likely your active talents' gear."
		elseif db.choice and G.profiles[db.choice] then
			lines = "The list you picked, compared with the gear you're wearing and carrying."
		else
			lines = "For your active talents" .. (v.treeName and (" (" .. v.treeName .. ")") or "")
				.. " and the gear you're wearing and carrying. Change talents, or pick a list on the right."
		end
		if J.Has(J.HELLO_PROGRESSION) then lines = lines .. "  Progression stage " .. s .. "." end
		note:SetText(lines)
		local p = G.profiles[v.profileKey]
		choose:SetText(p and p.name or "Choose")

		-- where to go next
		local ad = {}
		for i = 1, 2 do if v.dungeons[i] then table.insert(ad, v.dungeons[i]) end end
		if v.raids[1] then table.insert(ad, v.raids[1]) end
		for i = 1, 3 do
			local b, e = adviceLines[i], ad[i]
			b.entry = e
			if e then
				local names = {}
				for k = 1, math.min(3, #e.items) do table.insert(names, itemName(e.items[k].item)) end
				local more = #e.items > 3 and (" and " .. (#e.items - 3) .. " more") or ""
				local lead = (i == 1 and not e.g.raid) and "|cff40ff40Best now:|r " or (e.g.raid and "|cffffd200Raid:|r " or "|cffffd200Also good:|r ")
				b.text:SetText(lead .. "|cffffffff" .. e.g.name .. "|r  -  " .. e.count .. (e.count == 1 and " upgrade: " or " upgrades: ")
					.. table.concat(names, ", ") .. more)
				b:Show()
			else
				b:Hide()
			end
		end
		if #ad == 0 then
			adviceLines[1].text:SetText("|cff9d9d9dNo dungeon or raid open to you has an upgrade left. Well done!|r")
			adviceLines[1]:Show()
		end

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
				h.slot:SetText(r.row.name)
				local have = r.owned.weak or r.owned.strong
				if r.row.pair and r.owned.strong and r.owned.weak then have = r.owned.weak end
				h.link = have and have.worn.link
				if have then
					h.icon:SetTexture(GetItemIcon and GetItemIcon(have.id) or J.ItemIcon(have.id))
					h.icon:Show()
					local text = have.worn.link:gsub("[%[%]]", "")
					if r.row.pair and #r.owned.all == 2 then text = text .. " |cff9d9d9d(your weaker one)|r" end
					h.have:SetText(text)
				else
					h.icon:Hide()
					h.have:SetText("|cff9d9d9dNothing equipped|r")
				end
				local open = 0
				for _, e in ipairs(r.steps) do if e.open then open = open + 1 end end
				if r.best and have then
					h.state:SetText("|cff40ff40Best in slot until " .. EXPANSION_NEXT[0] .. "|r")
				elseif open == 0 and r.next then
					h.state:SetText("|cff40ff40Best you can get now|r")
				elseif open > 0 then
					h.state:SetText(open .. (open == 1 and " upgrade" or " upgrades"))
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
					st.num:SetText(e.open and (i .. ".") or "|cffff6060Next|r")
					st.num:SetWidth(e.open and 14 or 26)
					st.icon:SetTexture(GetItemIcon and GetItemIcon(e.item.id) or J.ItemIcon(e.item.id))
					st.icon:SetDesaturated(not e.open)
					st.name:SetText(itemName(e.item) .. (e.curated and " |cff9d9d9d(BiS pick)|r" or ""))
					st.name:SetWidth(width - 230)
					st.source:SetText(G.SourceText(e.src))
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

	local events = CreateFrame("Frame")
	for _, e in ipairs({ "PLAYER_EQUIPMENT_CHANGED", "BAG_UPDATE", "PLAYER_LEVEL_UP", "ACTIVE_TALENT_GROUP_CHANGED",
			"CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE", "QUEST_QUERY_COMPLETE" }) do
		events:RegisterEvent(e)
	end
	events:SetScript("OnEvent", function (self, event)
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

local load
Journal.RegisterTab({
	key = "gear", name = "Gear", order = 23, icon = "Interface\\Icons\\INV_Chest_Plate16",
	build = function (panel) load = build(panel) end,
	onShow = function () if load then load() end end,
})

SLASH_JOURNALGEARBIS1 = "/gear"
SLASH_JOURNALGEARBIS2 = "/bis"
SlashCmdList.JOURNALGEARBIS = function () J.ToggleSection("gear") end
