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

-- A source line's guidance after its "where": " - about 1 in 5 runs", greyed.
local function hint(text)
	return "  |cff9d9d9d- " .. text .. "|r"
end

-- An instance's name and what it is: "Scholomance (dungeon)", "Molten Core (raid)".
local function place(g)
	if not g then return "" end
	return g.name .. (g.raid and " (raid)" or " (dungeon)")
end

-- How to get it, in one line.
function G.SourceText(src)
	local g = src.inst and G.instances[src.inst]
	if src.kind == "D" or src.kind == "C" then
		return src.who .. " in " .. place(g) .. hint(runs(src.chance))
	elseif src.kind == "Q" then
		local t = (src.chain or 1) > 1 and ("Quest chain starting with " .. src.startName) or ("Quest: " .. src.who)
		if src.trainer then
			t = t .. hint("from your class trainer")
		elseif (src.givers or 1) > 1 and not g then
			t = t .. hint("from several quest givers")
		elseif (src.givers or 1) == 0 and not g then
			t = t .. hint("starts from an item")
		end
		if g and g.raid then return t .. hint("needs an item from " .. place(g)) end
		if g then return t .. hint(place(g)) end
		return t
	elseif src.kind == "V" then
		local t = "Sold by " .. src.who
		if (src.rep or 0) > 0 then
			t = t .. hint((G.STANDINGS[src.rank] or "?") .. " with " .. (G.FACTIONS[src.rep] or "a faction"))
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

-- What clicking a step does, for its tooltip; nil when it does nothing.
local function clickText(c)
	local src = c.src
	local g = src.inst and G.instances[src.inst]
	if (src.kind == "D" or src.kind == "C") and g then
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

local function openSource(c)
	local src = c.src
	local g = src.inst and G.instances[src.inst]
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

-- Roles talents can't tell apart (a feral druid tanking or not): the class's profiles no tree picks.
function G.ExtraRoles(class)
	local byTree, out = {}, {}
	for _, k in ipairs(G.byTree[class] or {}) do byTree[k] = true end
	for k, p in pairs(G.profiles) do
		if p.class == class and not byTree[k] then table.insert(out, k) end
	end
	table.sort(out)
	return out
end

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
				G.MarkTipsDirty()
				CloseDropDownMenus()
				render()
			end })
		end
		table.insert(list, { text = "Show the list for", isTitle = true, notCheckable = true })
		local active = GetActiveTalentGroup and GetActiveTalentGroup() or 1
		local _, tree = G.TalentProfile(active)
		add("My talents (" .. (tree or "none yet") .. ")", "active")
		if (GetNumTalentGroups and GetNumTalentGroups() or 1) > 1 then
			local _, otree = G.TalentProfile(active == 1 and 2 or 1)
			add("My other talents (" .. (otree or "none yet") .. ")", "other")
		end
		local extra = G.ExtraRoles(class)
		if #extra > 0 then
			table.insert(list, { text = "Or a role", isTitle = true, notCheckable = true })
			for _, k in ipairs(extra) do add(G.profiles[k].name .. "  |cff9d9d9d" .. G.profiles[k].role .. "|r", k) end
		end
		return list
	end)
	choose:SetPoint("TOPRIGHT", body, "TOPRIGHT", -8, -8)

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
		r.num = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		r.num:SetPoint("TOPLEFT", r, "TOPLEFT", 4, -4)
		r.num:SetWidth(32)
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
				GameTooltip:AddLine("Available at level " .. e.availableAt .. ".", 1, 0.4, 0.4, true)
			end
			if e.role == "bis" then
				GameTooltip:AddLine(G.BIS_TEXT[0], 1, 0.82, 0, true)
			end
			if e.curated then GameTooltip:AddLine("A hand-picked item for this spec.", 0.5, 0.85, 1, true) end
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
		if e.availableAt then return "|cffff6060Available at level " .. e.availableAt .. "|r" end
		if view and view.preview then return "" end
		return gainText(e, r.owned.value)
	end
	local ROLE = { get = "|cff40ff40Now|r", next = "|cffff6060Next|r", bis = "|cffffd200BiS|r" }

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
		local picked = db.choice and G.profiles[db.choice]
		local noTalents = not v.treeName and not picked
		local spec = noTalents and "" or ((v.treeName or prof.name) .. " ")
		title:SetText("Classic gear: " .. spec .. className .. "  |cff9d9d9d" .. prof.role
			.. (prof.mh and (", " .. prof.name:lower()) or "") .. "|r")
		local lines
		if v.preview then
			lines = "A preview of your gear goals at level " .. v.cap .. ". From level " .. v.readyLevel
				.. ", the list compares them with what you're wearing."
		elseif noTalents then
			lines = "You have no talent points assigned. Please assign your talent points so that this list doesn't guess."
		elseif db.choice == "other" and v.groups > 1 then
			lines = "Your other talents (" .. (v.treeName or "none yet") .. "), compared with the gear you're wearing now, which is likely your active talents' gear."
		elseif db.choice and G.profiles[db.choice] then
			lines = "The role you picked, compared with the gear you're wearing and carrying."
		else
			lines = "For your talents" .. (v.treeName and (" (" .. v.treeName .. ")") or "")
				.. ", compared with the gear you're wearing and carrying."
		end
		note:SetText(lines)
		-- worded and coloured as the Progression tab has it
		stageText:SetText(J.Has(J.HELLO_PROGRESSION) and ("Your progression stage: |cffffffff" .. s .. "|r")
			or "|cff9d9d9dProgression isn't on for you here|r")
		-- The menu is only there when there's a choice: dual spec, or a role talents can't tell.
		local choices = (v.groups > 1) or #G.ExtraRoles(v.class) > 0
		setShown(choose, choices)
		local p = G.profiles[v.profileKey]
		choose:SetText((db.choice == "other" and "Other talents") or (db.choice and G.profiles[db.choice] and p.name) or "My talents")

		-- where to go next: two dungeons a line, then the raid
		local groups = {}
		local function group(lead, a, b)
			if a then table.insert(groups, { lead = lead, a, b }) end
		end
		group("|cff40ff40Best now:|r", v.dungeons[1], v.dungeons[2])
		group("|cffffd200Also good:|r", v.dungeons[3], v.dungeons[4])
		group("|cffffd200Raid:|r", v.raids[1])
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
					local gap = (k == 1 and g[2]) and "," or ""
					b.text:SetText("|cffffffff" .. e.g.name .. "|r |cff9d9d9d(" .. kind .. ")|r  -  " .. what .. gap)
					b:SetWidth(b.text:GetStringWidth() + (gap ~= "" and 12 or 0))
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
				h.slot:SetText(r.row.name)
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
				local open = 0
				for _, e in ipairs(r.steps) do if e.open then open = open + 1 end end
				if v.preview then
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
					st.num:SetText(ROLE[e.role] or "")
					st.icon:SetTexture(GetItemIcon and GetItemIcon(e.item.id) or J.ItemIcon(e.item.id))
					st.icon:SetDesaturated(not e.open)
					st.name:SetText(itemName(e.item))
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
