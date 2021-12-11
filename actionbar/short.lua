local _, nf = ...
local cfg = nf.Config

-- globals
local _G = getfenv(0)
local unpack, select = _G.unpack, _G.select
local ReputationWatchBar = _G.ReputationWatchBar
local UIParent = _G.UIParent
--local isExp = ReputationWatchBar.OverlayFrame:IsShown() or cfg.global.showexpbar
local isExp = cfg.global.showexpbar

-- reduce the size of some mainbar objects
for _, object in pairs({
	_G['MainMenuBar'],
	--_G['MainMenuExpBar'],
	--_G['MainMenuBarMaxLevelBar'],
}) do
	object:SetWidth(512)
end

ReputationWatchBar.StatusBar.WatchBarTexture2:SetTexture(nil)
ReputationWatchBar.StatusBar.WatchBarTexture3:SetTexture(nil)
ReputationWatchBar.StatusBar.XPBarTexture2:SetTexture(nil)
ReputationWatchBar.StatusBar.XPBarTexture3:SetTexture(nil)

-- remove divider
_G.MultiBarBottomRight:EnableMouse(false)
_G.MultiBarBottomLeft:SetAlpha(cfg.fade.alpha.bottomleftbar)

-- reposit normal row
_G.MultiBarBottomLeftButton1:ClearAllPoints()
_G.MultiBarBottomLeftButton1:SetPoint('BOTTOMLEFT', _G.ActionButton1, 'BOTTOMLEFT', 0, 44)
_G.MultiBarBottomRightButton1:ClearAllPoints()
_G.MultiBarBottomRightButton1:SetPoint('BOTTOMLEFT', MultiBarBottomLeft, 'TOPLEFT', 0, isExp and 46 or 26)

-- for what? (11-12 buttons spacing by x)
-- ok control it by cfg
if cfg.move_buttons then
	_G.MultiBarBottomLeftButton11:ClearAllPoints()
	_G.MultiBarBottomLeftButton11:SetPoint('BOTTOMRIGHT', _G.MultiBarBottomLeft, 'BOTTOMRIGHT', 6, -10)
	_G.ActionButton11:ClearAllPoints()
	_G.ActionButton11:SetPoint('BOTTOMLEFT', _G.ActionButton10, 'BOTTOMRIGHT', 42, 0)
end

-- hide max level
_G.MainMenuMaxLevelBar0:Hide()
_G.MainMenuMaxLevelBar1:Hide()

_G.MainMenuMaxLevelBar0:SetPoint('BOTTOM', _G.MainMenuBarMaxLevelBar, 'TOP', -128, 0)
_G.MainMenuBarLeftEndCap:SetPoint('BOTTOM', _G.MainMenuBarArtFrame, -289, 0)
_G.MainMenuBarLeftEndCap.SetPoint = function () end
_G.MainMenuBarRightEndCap:SetPoint('BOTTOM', _G.MainMenuBarArtFrame, 289, 0)
_G.MainMenuBarRightEndCap.SetPoint = function () end