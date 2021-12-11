local _, nf = ...
local cfg = nf.Config

-- globals
local _G = getfenv(0)
local unpack, select = _G.unpack, _G.select
local artframe = _G.MainMenuBarArtFrame
local RegisterStateDriver = _G.RegisterStateDriver
local PetActionBarFrame = _G.PetActionBarFrame
local StanceBarFrame = _G.StanceBarFrame
local MainMenuBar = _G.MainMenuBar
local hooksecurefunc = _G.hooksecurefunc
local cast = _G.CastingBarFrame
local UIParent = _G.UIParent

-- backdrop
MainMenuBarTexture0:Hide()
MainMenuBarTexture1:Hide()
if cfg.global.barstyle then
	local bg = artframe:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(cfg.assets.bg)
	bg:SetScale(0.62)
	bg:SetHeight(216)
	bg:SetPoint('BOTTOM', MainMenuBar, 0, -40)
end

if (not cfg.global.gryphons) then
	_G.MainMenuBarLeftEndCap:SetTexCoord(0, 0, 0, 0)
	_G.MainMenuBarRightEndCap:SetTexCoord(0, 0, 0, 0)
end

-- bottom right (3)
if (cfg.direction.vertical.bottomrightbar) then
	for i = 2, 12 do
		local rightb = _G['MultiBarBottomRightButton'..i]
		rightb:ClearAllPoints()
		rightb:SetPoint('TOP', _G['MultiBarBottomRightButton'..(i - 1)], 'BOTTOM', 0, -6)
	end

	_G.MultiBarBottomRightButton1:HookScript('OnShow', function(self)
		self:ClearAllPoints()
		if (cfg.direction.vertical.bottomrightbar_right) then -- right
			self:SetPoint('TOPRIGHT', _G.MultiBarLeftButton1, 'TOPLEFT', -6, 0)
		else
			self:SetPoint('TOPLEFT', UIParent, 'LEFT', 6, _G.MultiBarBottomRight:GetWidth()/2)
		end
	end)
	
	_G.MultiBarBottomRight:SetAlpha(cfg.fade.alpha.bottomrightbar)
end

-- right panel 1
_G.MultiBarLeft:SetAlpha(cfg.fade.alpha.leftbar)
_G.MultiBarLeft:SetScale(cfg.size.mainbar)
_G.MultiBarLeft:SetParent(UIParent)

if cfg.direction.horizontal.leftbar and cfg.direction.horizontal.rightbar then
	for i = 2, 12 do
		local mlb = _G['MultiBarLeftButton'..i]
		mlb:ClearAllPoints()
		mlb:SetPoint('LEFT', _G['MultiBarLeftButton'..(i - 1)], 'RIGHT', 6, 0)
	end

	_G.MultiBarLeftButton1:HookScript('OnShow', function(self)
		self:ClearAllPoints()
		if (not cfg.shortbar) then
			self:SetPoint('BOTTOMLEFT', _G.MultiBarBottomLeftButton1, 'TOPLEFT', 0, 6)
		else
			self:SetPoint('BOTTOMLEFT', _G.MultiBarRightButton1, 'TOPLEFT', 0, 6)
		end
	end)
else
	_G.MultiBarLeftButton1:ClearAllPoints() 
	_G.MultiBarLeftButton1:SetPoint('TOPRIGHT', _G.MultiBarRightButton1, 'TOPLEFT', -4, 0)
end

-- right panel 2
_G.MultiBarRight:SetAlpha(cfg.fade.alpha.rightbar)
_G.MultiBarRight:SetScale(cfg.size.mainbar)

if cfg.rightbar_horizontal then
	for i = 2, 12 do
		local mrb = _G['MultiBarRightButton'..i]
		mrb:ClearAllPoints()
		mrb:SetPoint('LEFT', _G['MultiBarRightButton'..(i - 1)], 'RIGHT', 6, 0)
	end

	_G.MultiBarRightButton1:HookScript('OnShow', function(self)
		self:ClearAllPoints()
		self:SetPoint('BOTTOMLEFT', _G.MultiBarBottomRightButton1, 'TOPLEFT', 0, 6)
	end)
else
	_G.MultiBarRightButton1:ClearAllPoints()
	_G.MultiBarRightButton1:SetPoint('TOPRIGHT', UIParent, 'RIGHT', -6, _G.MultiBarRight:GetHeight()/2)
end

-- pet
PetActionBarFrame:SetFrameStrata('HIGH')
PetActionBarFrame:SetScale(cfg.size.petbar)
PetActionBarFrame:SetAlpha(cfg.fade.alpha.petbar)

-- move pet
--_G.PetActionButton1:SetMovable(true)
_G.PetActionButton1:ClearAllPoints()
_G.PetActionButton1:SetPoint('BOTTOMLEFT', _G.MultiBarBottomRightButton1, 'TOPRIGHT', 22, 12)
--_G.PetActionButton1:SetUserPlaced(true)

-- horizontal/vertical bars
if (cfg.direction.vertical.petbar) then
	for i = 2, 10 do
		button = _G['PetActionButton'..i]
		button:ClearAllPoints()
		button:SetPoint('TOP', _G['PetActionButton'..(i - 1)], 'BOTTOM', 0, -8)
	end
end

-- stance
_G.StanceBarLeft:SetTexture(nil)
_G.StanceBarMiddle:SetTexture(nil)
_G.StanceBarRight:SetTexture(nil)
StanceBarFrame:SetFrameStrata('MEDIUM')
StanceBarFrame:SetScale(cfg.size.stancebar)
StanceBarFrame:SetAlpha(cfg.fade.alpha.stancebar)

-- move stance
StanceBarFrame:SetMovable(true)
StanceBarFrame:ClearAllPoints()
StanceBarFrame:SetPoint('TOPLEFT', -40, 140)
StanceBarFrame:SetUserPlaced(true)

if (not cfg.global.stancebar) then
	hooksecurefunc('StanceBar_Update', function()
		if StanceBarFrame:IsShown() and not nf.IsTaintable() then
			RegisterStateDriver(StanceBarFrame, 'visibility', 'hide')
		end
	end)
end

-- mainbar
MainMenuBar:ClearAllPoints()
MainMenuBar:SetPoint('BOTTOM', UIParent, 0, 50)
MainMenuBar:SetScale(cfg.size.mainbar)

-- castbar
local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function(self, event)
	UIPARENT_MANAGED_FRAME_POSITIONS['CastingBarFrame'] = nil
	
	-- frame
	cast:ClearAllPoints()
	cast:SetPoint('BOTTOM', MainMenuBar, -2, -28)
	cast:SetFrameStrata('DIALOG')
	cast:SetSize(184, 20)
	
	-- background
    local bg = cast:CreateTexture(nil, 'BACKGROUND')
    bg:SetAllPoints(cast)
    bg:SetTexture('Interface\\Buttons\\WHITE8x8')
	bg:SetVertexColor(0, 0, 0)

	-- border
	cast.Border:SetWidth(cast.Border:GetWidth() + 4)
	cast.Border:SetHeight(cast.Border:GetHeight() - 12)
	cast.Border:ClearAllPoints()
	cast.Border:SetPoint('CENTER', 2, 1)
	cast.Border.SetPoint = function() end
	cast.Border:SetTexture(cfg.assets.cast)
	cast.Border:SetDrawLayer('OVERLAY')
	
	-- flash
	cast.Flash:Hide()
	cast.Flash:SetTexture('')

	-- text
	cast.Text:ClearAllPoints()
	cast.Text:SetPoint('CENTER', 0, 0)

	-- icon
	cast.Icon:Hide()

	self:UnregisterEvent('ADDON_LOADED')
end)