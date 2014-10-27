local _, ns = ...

local updateClearButton
local dummyText = "What is your character doing?"

-- [[ Handle input ]]

local function toggleDummyText(self, showDummyText)
	if showDummyText then
		self:SetText(dummyText)
		self:SetTextColor(.5, .5, .5)
	else
		self:SetTextColor(1, 1, 1)
	end
end
ns.toggleDummyText = toggleDummyText

ns.onEscapePressed = function(self)
	self:ClearFocus()
	self:HighlightText(0, 0)
	self:SetText(mrpSaved.Profiles[mrpSaved.SelectedProfile].CU)

	toggleDummyText(self, self:GetText() == "")
end

ns.onEnterPressed = function(self)
	local text = self:GetText()

	self:ClearFocus()
	self:HighlightText(0, 0)

	mrp:SaveField("CU", text)

	toggleDummyText(self, text == "")
	updateClearButton(self)
end

ns.onEditFocusGained = function(self)
	toggleDummyText(self, false)

	if self:GetText() == dummyText then
		self:SetText("")
	end

	self:HighlightText()
end

ns.onClearButtonClicked = function(self)
	self.parent:SetText("")
	toggleDummyText(self.parent, true)
	updateClearButton(self.parent)
	mrp:SaveField("CU", "")
end

-- [[ Other methods ]]

-- Show/hide clear button

updateClearButton = function(self)
	self.clearButton:SetShown(self:GetText() ~= dummyText)
end
ns.updateClearButton = updateClearButton

-- To determine window opacity

ns.hasText = function(self)
	return self:GetText() ~= dummyText
end