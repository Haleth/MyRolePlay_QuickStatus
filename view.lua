local _, ns = ...

-- [[ Create frames ]]

local f = CreateFrame("EditBox", nil, UIParent)
f:SetSize(200, 30)
f:SetPoint("TOP", UIParent, -10, -50)
f:SetAutoFocus(false)
f:SetFontObject(GameFontHighlight)
f:SetTextInsets(8, 8, 0, 0)

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

local clearButton = CreateFrame("Button", nil, f)
clearButton:SetSize(17, 17)
clearButton:SetPoint("LEFT", f, "RIGHT")
clearButton.parent = f
f.clearButton = clearButton

do
	local tex = clearButton:CreateTexture(nil, "OVERLAY")
	tex:SetAllPoints()
	tex:SetTexture("Interface\\FriendsFrame\\ClearBroadcastIcon")
	tex:SetAlpha(.5)
	clearButton.tex = tex
end

-- [[ Handle input ]]

f:SetScript("OnEscapePressed", ns.onEscapePressed)
f:SetScript("OnEnterPressed", ns.onEnterPressed)
f:SetScript("OnEditFocusGained", ns.onEditFocusGained)
clearButton:SetScript("OnClick", ns.onClearButtonClicked)
clearButton:SetScript("OnEnter", function(self)
	self.tex:SetAlpha(1)
end)
clearButton:SetScript("OnLeave", function(self)
	self.tex:SetAlpha(.5)
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

ns.updateClearButton(f)