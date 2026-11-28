-- Upgrade arrows: a green arrow on the icon of an item that's an upgrade on your gear list (the same answer as
-- the tooltip's "On your gear list: Roll Need"), in the loot window, Need or Greed rolls, quest rewards and
-- merchants; and in your bags and bank (Blizzard's and DragonUI's Bagster) on one that beats what you wear.
--
-- The list comes first. Where it can't judge an item (below level 55, or an item it doesn't know), Pawn decides,
-- when Pawn is installed. The arrow is DialogueUI's, so it looks the same in DialogueUI's quest windows.

local G = JournalGearGuide

-- The old name of this addon, still in Interface\AddOns: two Gear tabs and two tooltip lines.
local warn = CreateFrame("Frame")
warn:RegisterEvent("PLAYER_LOGIN")
warn:SetScript("OnEvent", function ()
	if IsAddOnLoaded and IsAddOnLoaded("JournalGearBIS") then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffd100Gear Guide:|r JournalGearBIS is this addon's old name. Delete the "
			.. "JournalGearBIS folder in Interface\\AddOns, or you'll have both.")
	end
end)

if not (G and G.IsUpgrade and G.Knows) then return end

local ARROW = "Interface\\AddOns\\JournalGearGuide\\Textures\\UpgradeArrowSmall"

-----------------------------------------
-- Pawn, for what the list can't judge: the item scores higher than what's in one of its slots in your spec's
-- Pawn scale when you have it ticked, otherwise in at least one of your ticked scales (the way DialogueUI asks
-- Pawn); weapons as a pair (pawnWeapon). Newer Pawns answer the question themselves for armour when no spec
-- scale is in use.

local SLOTS = {
	INVTYPE_HEAD = { 1 }, INVTYPE_NECK = { 2 }, INVTYPE_SHOULDER = { 3 }, INVTYPE_BODY = { 4 }, INVTYPE_CHEST = { 5 },
	INVTYPE_ROBE = { 5 }, INVTYPE_WAIST = { 6 }, INVTYPE_LEGS = { 7 }, INVTYPE_FEET = { 8 }, INVTYPE_WRIST = { 9 },
	INVTYPE_HAND = { 10 }, INVTYPE_FINGER = { 11, 12 }, INVTYPE_TRINKET = { 13, 14 }, INVTYPE_CLOAK = { 15 },
	INVTYPE_WEAPON = { 16, 17 }, INVTYPE_SHIELD = { 17 }, INVTYPE_2HWEAPON = { 16 }, INVTYPE_WEAPONMAINHAND = { 16 },
	INVTYPE_WEAPONOFFHAND = { 17 }, INVTYPE_HOLDABLE = { 17 }, INVTYPE_RANGED = { 18 }, INVTYPE_THROWN = { 18 },
	INVTYPE_RANGEDRIGHT = { 18 }, INVTYPE_RELIC = { 18 },
}
-- slots where cloth, leather, mail and plate don't mix
local ARMOR_TYPE = { [1] = true, [3] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true }

-- Pawn's own scales for each talent tree ("Wowhead":PriestHoly, shown as "Priest: holy"); a feral druid's by
-- list, cat or bear. Death knights have two scales to a tree, so theirs aren't matched.
local SPEC_SCALE = {
	WARRIOR = { "WarriorArms", "WarriorFury", "WarriorTank" },
	PALADIN = { "PaladinHoly", "PaladinTank", "PaladinRetribution" },
	HUNTER = { "HunterBeastMastery", "HunterMarksman", "HunterSurvival" },
	ROGUE = { "RogueAssassination", "RogueCombat", "RogueSubtlety" },
	PRIEST = { "PriestDiscipline", "PriestHoly", "PriestShadow" },
	SHAMAN = { "ShamanElemental", "ShamanEnhancement", "ShamanRestoration" },
	MAGE = { "MageArcane", "MageFire", "MageFrost" },
	WARLOCK = { "WarlockAffliction", "WarlockDemonology", "WarlockDestruction" },
	DRUID = { "DruidBalance", "DruidFeralDps", "DruidRestoration" },
}
local LIST_SCALE = { DRUID_BEAR = "DruidFeralTank" }

-- Your spec's Pawn scale, when you have talent points spent and that scale ticked; nil: use every ticked scale.
-- Worked out once a frame: a bag update asks for many items at once.
local scaleAt, scaleNow
local function findSpecScale()
	if not (G.TalentProfile and PawnCommon and PawnCommon.Scales and type(PawnIsScaleVisible) == "function") then return nil end
	local _, class = UnitClass("player")
	local key, treeName, tree = G.TalentProfile(GetActiveTalentGroup and GetActiveTalentGroup() or 1)
	if not treeName then return nil end
	local internal = LIST_SCALE[key] or (SPEC_SCALE[class] and SPEC_SCALE[class][tree])
	local full = internal and ("\"Wowhead\":" .. internal)
	if not (full and PawnCommon.Scales[full]) then return nil end
	local ok, visible = pcall(PawnIsScaleVisible, full)
	return ok and visible and full or nil
end
local function specScale()
	local now = GetTime()
	if now ~= scaleAt then scaleAt, scaleNow = now, findSpecScale() end
	return scaleNow
end

local function pawnValues(item)
	local values, only = {}, specScale()
	for _, entry in ipairs(item and item.Values or {}) do
		if not only or entry[1] == only then values[entry[1]] = entry[2] or 0 end
	end
	return values
end

-- What goes in each hand: a main-hand one-hander, an off-hand, a two-hander.
local MAIN_ONE = { INVTYPE_WEAPON = true, INVTYPE_WEAPONMAINHAND = true }
local OFF = { INVTYPE_WEAPONOFFHAND = true, INVTYPE_HOLDABLE = true, INVTYPE_SHIELD = true }

local function pawnItem(link)
	local ok, data = pcall(PawnGetItemData, link)
	return ok and pawnValues(data) or {}
end
local function pawnWorn(slot)
	local ok, data = pcall(PawnGetItemDataForInventorySlot, slot, true)
	return ok and pawnValues(data) or {}
end
-- a + b, scale by scale
local function plus(a, b)
	local out = {}
	for k, v in pairs(a) do out[k] = v end
	for k, v in pairs(b) do out[k] = (out[k] or 0) + v end
	return out
end
-- better than old in any of your scales
local function beats(new, old)
	for scale, value in pairs(new) do
		if value > (old[scale] or 0) then return true end
	end
	return false
end
-- The best in your bags for a hand (kinds: the equip locations that go there), scale by scale.
local function bagBest(kinds, except)
	local best = {}
	for bag = 0, 4 do
		for i = 1, (GetContainerNumSlots(bag) or 0) do
			local link = GetContainerItemLink(bag, i)
			if link and link ~= except then
				local loc = select(9, GetItemInfo(link))
				if loc and kinds[loc] then
					for k, v in pairs(pawnItem(link)) do best[k] = math.max(best[k] or 0, v) end
				end
			end
		end
	end
	return best
end

-- Weapons as a pair, as the gear list does: a two-hander against the main hand and off-hand together; a
-- one-hander or an off-hand while you wear a two-hander, together with the best item in your bags for the
-- other hand (or alone, without one), against the two-hander.
local function pawnWeapon(link, equipLoc, new)
	local main = GetInventoryItemLink("player", 16)
	local mainLoc = main and select(9, GetItemInfo(main))
	if equipLoc == "INVTYPE_2HWEAPON" then
		local old = pawnWorn(16)
		if mainLoc ~= "INVTYPE_2HWEAPON" then old = plus(old, pawnWorn(17)) end
		return beats(new, old)
	end
	if mainLoc == "INVTYPE_2HWEAPON" then
		local partner = OFF[equipLoc] and bagBest(MAIN_ONE, link) or bagBest(OFF, link)
		return beats(plus(new, partner), pawnWorn(16))
	end
	if OFF[equipLoc] then return beats(new, pawnWorn(17)) end
	-- a one-hander: your main hand's, or (one that goes in either hand) your off-hand's when that's a weapon
	if beats(new, pawnWorn(16)) then return true end
	local off = GetInventoryItemLink("player", 17)
	local offLoc = off and select(9, GetItemInfo(off))
	return equipLoc == "INVTYPE_WEAPON" and (offLoc == "INVTYPE_WEAPON" or offLoc == "INVTYPE_WEAPONOFFHAND")
		and beats(new, pawnWorn(17)) or false
end

local function pawnUpgrade(link)
	local _, _, _, _, _, class, subclass, _, equipLoc = GetItemInfo(link)
	local slots = equipLoc and SLOTS[equipLoc]
	local weapon = equipLoc == "INVTYPE_2HWEAPON" or MAIN_ONE[equipLoc] or OFF[equipLoc]
	if weapon and type(PawnGetItemData) == "function" and type(PawnGetItemDataForInventorySlot) == "function" then
		local new = pawnItem(link)
		return next(new) ~= nil and pawnWeapon(link, equipLoc, new)
	end
	if type(PawnShouldItemLinkHaveUpgradeArrow) == "function" and not specScale() then
		local ok, yes = pcall(PawnShouldItemLinkHaveUpgradeArrow, link)
		return ok and yes and true or false
	end
	if not slots or type(PawnGetItemData) ~= "function" or type(PawnGetItemDataForInventorySlot) ~= "function" then
		return false
	end
	local new = pawnItem(link)
	if not next(new) then return false end
	for _, slot in ipairs(slots) do
		local worn = GetInventoryItemLink("player", slot)
		if worn then
			local _, _, _, _, _, wornClass, wornSub = GetItemInfo(worn)
			local otherArmor = ARMOR_TYPE[slot] and wornClass == class and wornSub ~= subclass
			if not otherArmor and beats(new, pawnWorn(slot)) then return true end
		else
			return true
		end
	end
	return false
end

-- Public: whether an item's icon gets the arrow. carried: it's in your bags or bank (better than what you wear?).
function G.ShowsArrow(link, carried)
	if not link then return false end
	if G.Knows(link) then
		local row, becomes = G.IsUpgrade(link, carried)
		return (row or becomes) and true or false
	end
	return pawnUpgrade(link)
end

-----------------------------------------
-- drawing

-- anchor: the icon, when it isn't the button itself (quest rewards)
local function setArrow(button, link, anchor, carried)
	if not button then return end
	local show = link and G.ShowsArrow(link, carried)
	local arrow = button.gearGuideArrow
	if show and not arrow then
		arrow = button:CreateTexture(nil, "OVERLAY")
		arrow:SetDrawLayer("OVERLAY", 7)
		arrow:SetTexture(ARROW)
		arrow:SetWidth(16)
		arrow:SetHeight(16)
		arrow:SetPoint("TOPLEFT", anchor or button, "TOPLEFT", 1, -1)
		button.gearGuideArrow = arrow
	end
	if arrow then
		if show then arrow:Show() else arrow:Hide() end
	end
end

-- Bags and bank: every slot's icon goes through SetItemButtonTexture, Bagster's too (its slots are made from
-- the same template; it sets the slot's link just before).
hooksecurefunc("SetItemButtonTexture", function (button)
	local name = button and button.GetName and button:GetName()
	if not name then return end
	if name:match("^DragonUI_BagsterItem%d+$") then
		setArrow(button, type(button.hasItem) == "string" and button.hasItem or nil, nil, true)
	elseif name:match("^ContainerFrame%d+Item%d+$") then
		local parent = button:GetParent()
		setArrow(button, parent and GetContainerItemLink(parent:GetID(), button:GetID()), nil, true)
	elseif name:match("^BankFrameItem%d+$") then
		setArrow(button, GetContainerItemLink(BANK_CONTAINER or -1, button:GetID()), nil, true)
	end
end)

-- Your bags again when the answer changes without them changing (talents, level, what you wear).
local refresh = CreateFrame("Frame")
for _, e in ipairs({ "ACTIVE_TALENT_GROUP_CHANGED", "CHARACTER_POINTS_CHANGED", "PLAYER_LEVEL_UP", "PLAYER_EQUIPMENT_CHANGED" }) do
	refresh:RegisterEvent(e)
end
refresh:SetScript("OnEvent", function ()
	if G.MarkTipsDirty then G.MarkTipsDirty() end
	for i = 1, NUM_CONTAINER_FRAMES or 13 do
		local frame = _G["ContainerFrame" .. i]
		if frame and frame:IsShown() and ContainerFrame_Update then ContainerFrame_Update(frame) end
	end
end)

-- Loot window
hooksecurefunc("LootFrame_Update", function ()
	for i = 1, LOOTFRAME_NUMBUTTONS or 4 do
		local button = _G["LootButton" .. i]
		setArrow(button, button and button:IsShown() and button.slot and GetLootSlotLink(button.slot))
	end
end)

-- Need or Greed
if GroupLootFrame_OnShow then
	hooksecurefunc("GroupLootFrame_OnShow", function (self)
		setArrow(_G[self:GetName() .. "IconFrame"], self.rollID and GetLootRollItemLink(self.rollID))
	end)
end

-- Quest rewards and choices, in the quest window and the quest log. The quest templates keep their own reference
-- to QuestInfo_ShowRewards, so a hook on it never runs: QuestInfo_Display, which shows them, is called by name.
if QuestInfo_Display then
	hooksecurefunc("QuestInfo_Display", function ()
		local log = QuestInfoFrame and QuestInfoFrame.questLog
		for i = 1, MAX_NUM_ITEMS or 10 do
			local button = _G["QuestInfoItem" .. i]
			if button then
				local link
				if button:IsShown() and (button.type == "reward" or button.type == "choice") then
					if log then link = GetQuestLogItemLink(button.type, button:GetID())
					else link = GetQuestItemLink(button.type, button:GetID()) end
				end
				setArrow(button, link, _G["QuestInfoItem" .. i .. "IconTexture"])
			end
		end
	end)
end

-- Merchants (not the buyback tab)
hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function ()
	local perPage = MERCHANT_ITEMS_PER_PAGE or 10
	for i = 1, perPage do
		local button = _G["MerchantItem" .. i .. "ItemButton"]
		local index = ((MerchantFrame.page or 1) - 1) * perPage + i
		setArrow(button, button and button:IsShown() and GetMerchantItemLink(index))
	end
end)
hooksecurefunc("MerchantFrame_UpdateBuybackInfo", function ()
	for i = 1, MERCHANT_ITEMS_PER_PAGE or 10 do setArrow(_G["MerchantItem" .. i .. "ItemButton"], nil) end
end)
