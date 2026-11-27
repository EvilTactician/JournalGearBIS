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
-- Pawn, for what the list can't judge: the item scores higher than what's in one of its slots in at least one
-- of your Pawn scales (the way DialogueUI asks Pawn). Newer Pawns answer the question themselves.

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

local function pawnValues(item)
	local values = {}
	for _, entry in ipairs(item and item.Values or {}) do values[entry[1]] = entry[2] or 0 end
	return values
end

local function pawnUpgrade(link)
	if type(PawnShouldItemLinkHaveUpgradeArrow) == "function" then
		local ok, yes = pcall(PawnShouldItemLinkHaveUpgradeArrow, link)
		return ok and yes and true or false
	end
	if type(PawnGetItemData) ~= "function" or type(PawnGetItemDataForInventorySlot) ~= "function" then return false end
	local _, _, _, _, _, class, subclass, _, equipLoc = GetItemInfo(link)
	local slots = equipLoc and SLOTS[equipLoc]
	if not slots then return false end
	local ok, data = pcall(PawnGetItemData, link)
	local new = ok and pawnValues(data) or {}
	if not next(new) then return false end
	local oneHand = equipLoc == "INVTYPE_WEAPON"
	for i, slot in ipairs(slots) do
		local worn = GetInventoryItemLink("player", slot)
		if worn then
			local _, _, _, _, _, wornClass, wornSub, _, wornLoc = GetItemInfo(worn)
			local offHandNotWeapon = i == 2 and oneHand and wornLoc ~= "INVTYPE_WEAPON" and wornLoc ~= "INVTYPE_WEAPONOFFHAND"
			local otherArmor = ARMOR_TYPE[slot] and wornClass == class and wornSub ~= subclass
			if not offHandNotWeapon and not otherArmor then
				local okWorn, wornData = pcall(PawnGetItemDataForInventorySlot, slot, true)
				local old = okWorn and pawnValues(wornData) or {}
				for scale, value in pairs(new) do
					if value > (old[scale] or 0) then return true end
				end
			end
		elseif not (i == 2 and oneHand) then
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
