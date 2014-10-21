local _, ns = ...

local INACTIVE_ALPHA = .4

-- [[ Create frames ]]

local f = CreateFrame("EditBox", "MyRolePlay_QuickStatus", UIParent)
f:SetSize(200, 30)
f:SetPoint("TOP", UIParent, -10, -50)
f:SetAutoFocus(false)
f:SetFontObject(GameFontHighlight)
f:SetTextInsets(8, 8, 0, 0)
f:SetMovable(true)

local clearButton = CreateFrame("Button", nil, f)
clearButton:SetSize(17, 17)
clearButton:SetPoint("LEFT", f, "RIGHT")
clearButton.parent = f
f.clearButton = clearButton

local moveFrame = CreateFrame("Frame", nil, f)
moveFrame:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 1)
moveFrame:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", 20, 1)
moveFrame:SetHeight(14)
moveFrame:SetAlpha(0)
moveFrame:EnableMouse(true)
moveFrame:RegisterForDrag("LeftButton")

local moveText = moveFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
moveText:SetPoint("CENTER")
moveText:SetText("Click to unlock.")

-- [[ Frame moving ]]

local isMovable = false

moveFrame:SetScript("OnEnter", function(self)
	self:SetAlpha(1)
end)

moveFrame:SetScript("OnLeave", function(self)
	self:SetAlpha(0)
end)

moveFrame:HookScript("OnMouseUp", function(self, button)
	if isMovable then
		if IsShiftKeyDown() then
			f:ClearAllPoints()
			f:SetPoint("TOP", UIParent, -10, -50)
		end

		isMovable = false
		moveFrame:SetScript("OnDragStart", nil)
		moveFrame:SetScript("OnDragStop", nil)
		moveText:SetText("Click to unlock.")
	else
		isMovable = true
		moveFrame:SetScript("OnDragStart", function()
			f:StartMoving()
		end)
		moveFrame:SetScript("OnDragStop", function()
			f:StopMovingOrSizing()
		end)
		moveText:SetText("Click to lock. Shift-click to reset.")
	end
end)

-- [[ Textures ]]

f.left = f:CreateTexture(nil, "BACKGROUND")
f.left:SetTexture("Interface\\Common\\Common-Input-Border")
f.left:SetSize(8, 21)
f.left:SetPoint("LEFT", 0, 0)
f.left:SetTexCoord(0, 0.0625, 0, 0.625)

f.right = f:CreateTexture(nil, "BACKGROUND")
f.right:SetTexture("Interface\\Common\\Common-Input-Border")
f.right:SetSize(8, 21)
f.right:SetPoint("RIGHT", 19, 0)
f.right:SetTexCoord(0.9375, 1, 0, 0.625)

f.middle = f:CreateTexture(nil, "BACKGROUND")
f.middle:SetTexture("Interface\\Common\\Common-Input-Border")
f.middle:SetSize(0, 21)
f.middle:SetPoint("LEFT", f.left, "RIGHT")
f.middle:SetPoint("RIGHT", f.right, "LEFT")
f.middle:SetTexCoord(0.0625, 0.9375, 0, 0.625)

do
	local tex = clearButton:CreateTexture(nil, "OVERLAY")
	tex:SetAllPoints()
	tex:SetTexture("Interface\\FriendsFrame\\ClearBroadcastIcon")
	tex:SetAlpha(.5)
	clearButton.tex = tex
end

-- [[ Handle input ]]

local updateAlpha = function()
	f:SetAlpha(ns.hasText(f) and 1 or INACTIVE_ALPHA)
end

local resetAlpha = function()
	f:SetAlpha(1)
end

f:SetScript("OnEscapePressed", ns.onEscapePressed)
f:SetScript("OnEnterPressed", ns.onEnterPressed)
f:SetScript("OnEditFocusGained", ns.onEditFocusGained)
f:SetScript("OnEnter", resetAlpha)
f:SetScript("OnLeave", updateAlpha)
clearButton:SetScript("OnClick", ns.onClearButtonClicked)
clearButton:SetScript("OnEnter", function(self)
	self.tex:SetAlpha(1)
	resetAlpha()
end)
clearButton:SetScript("OnLeave", function(self)
	self.tex:SetAlpha(.5)
	updateAlpha()
end)

-- [[ Aurora / FreeUI compatibility ]]

local function applyTheme(F)
	f.left:Hide()
	f.middle:Hide()
	f.right:Hide()

	local bg = F.CreateBDFrame(f)
	bg:SetPoint("TOPLEFT")
	bg:SetPoint("BOTTOMRIGHT", 20, 0)
end

if IsAddOnLoaded("Aurora") or IsAddOnLoaded("FreeUI") then
	applyTheme(unpack(Aurora or FreeUI))
else
	f:RegisterEvent("ADDON_LOADED", function(self, event, addon)
		if addon == "Aurora" or addon == "FreeUI" then
			applyTheme(unpack(Aurora or FreeUI))

			self:UnregisterEvent("ADDON_LOADED")
		end
	end)
end

-- [[ Initialize text ]]

do
	local currently = mrpSaved.Profiles[mrpSaved.SelectedProfile].CU
	if currently ~= "" then
		f:SetText(currently)
	else
		ns.toggleDummyText(f, true)
	end
end

-- Show/hide clear button
ns.updateClearButton(f)
-- Set window alpha
updateAlpha()