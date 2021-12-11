local _, nf = ...
local cfg = nf.Config

-- globals
local _G = _G
local hooksecurefunc = _G.hooksecurefunc
local unpack, select, next, pairs, m_floor = _G.unpack, _G.select, _G.next, _G.pairs, _G.math.floor

local framesToDisable = {
	_G.CharacterMicroButton,
	_G.SpellbookMicroButton,
	_G.TalentMicroButton,
	_G.QuestLogMicroButton,
	_G.SocialsMicroButton,
	_G.LFGMicroButton,
	_G.MainMenuMicroButton,
	_G.HelpMicroButton,
}

-- reposit the micromenu
for _, frame in next, framesToDisable do
	frame:UnregisterAllEvents()
	frame:SetParent(nf.nope)
	--frame:Disable()
end
	
-- disable the automatic frame position
do
	for _, frame in pairs({
		'MultiBarLeft',
		'MultiBarRight',
		'MultiBarBottomRight',
		'PossessBarFrame',
		'MULTICASTACTIONBAR_YPOS',
		'MultiCastActionBarFrame',
		'PETACTIONBAR_YPOS',
	}) do
		_G.UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
	end
end

-- hide unwanted objects
for i = 2, 3 do
	for _, object in pairs({
		_G['ActionBarUpButton'],
		_G['ActionBarDownButton'],
		_G['KeyRingButton'],
		_G['MainMenuBarTexture'..i],
		_G['MainMenuMaxLevelBar'..i],
		_G['MainMenuXPBarTexture'..i],
		_G['ReputationWatchBarTexture'..i],
		_G['ReputationXPBarTexture'..i],
		_G['MainMenuBarPageNumber'],
		_G['MainMenuBarPerformanceBarFrameButton'],
		_G['MainMenuBarPerformanceBar'],
		_G['SlidingActionBarTexture0'],
		_G['SlidingActionBarTexture1'],

		_G['StanceBarLeft'],
		_G['StanceBarMiddle'],
		_G['StanceBarRight'],

		_G['PossessBackground1'],
		_G['PossessBackground2'],
	}) do
		if (object:IsObjectType('Frame') or object:IsObjectType('Button')) then
			object:UnregisterAllEvents()
			object:SetScript('OnEnter', nil)
			object:SetScript('OnLeave', nil)
			object:SetScript('OnClick', nil)
		end

		hooksecurefunc(object, 'Show', function(self) self:Hide() self:SetAlpha(0) end)
		object:Hide()
		object:SetAlpha(0)
	end
end
	
-- remove divider
for i = 0, 3, 1 do _G['MainMenuXPBarTexture'..i]:Hide() end
local divWidth = _G.MainMenuExpBar:GetWidth() / 10
local xpos = 0

for i = 0, 1, 1 do
	local texture = _G['MainMenuXPBarTexture'..i]
	local xalign = m_floor(xpos)
	texture:Show()
	texture:SetPoint('LEFT', xalign, 1)
	xpos = xpos + 256
end

-- moveable bars
for _, frame in pairs({
	_G['PetActionBarFrame'],
	_G['StanceBarFrame'],
	_G['PossessBarFrame'],
	_G['MultiCastActionBarFrame'],
}) do
	frame:EnableMouse(false)
end

-- a new place for the exit vehicle button
hooksecurefunc('MainMenuBarVehicleLeaveButton_Update', function()
	_G.MainMenuBarVehicleLeaveButton:ClearAllPoints()
	_G.MainMenuBarVehicleLeaveButton:SetPoint('LEFT', _G.MainMenuBar, 'RIGHT', 10, 75)
	_G.MainMenuBarVehicleLeaveButton:SetScale(cfg.size.vehicle)
end)

-- anchor bags
_G.MainMenuBarBackpackButton:ClearAllPoints()
_G.CharacterBag0Slot:ClearAllPoints()
_G.CharacterBag1Slot:ClearAllPoints()
_G.CharacterBag2Slot:ClearAllPoints()
_G.CharacterBag3Slot:ClearAllPoints()

-- set new position
_G.MainMenuBarBackpackButton:SetPoint('BOTTOMRIGHT', _G.WorldFrame, 'BOTTOMRIGHT', 0, 0)
_G.CharacterBag0Slot:SetPoint('BOTTOMRIGHT', _G.MainMenuBarBackpackButton, 'BOTTOMLEFT', 0, 0)
_G.CharacterBag1Slot:SetPoint('RIGHT', CharacterBag0Slot, 'LEFT', 0, 0)
_G.CharacterBag2Slot:SetPoint('RIGHT', CharacterBag1Slot, 'LEFT', 0, 0)
_G.CharacterBag3Slot:SetPoint('RIGHT', CharacterBag2Slot, 'LEFT', 0, 0)