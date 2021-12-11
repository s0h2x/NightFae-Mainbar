local _, nf = ...
local cfg = nf.Config

-- globals
local _G = getfenv(0)
local unpack, select = _G.unpack, _G.select
local MainMenuExpBar = _G.MainMenuExpBar
local MainMenuBarExpText = _G.MainMenuBarExpText
local ReputationWatchBar = _G.ReputationWatchBar

if cfg.global.showexpbar ~= true then
	MainMenuExpBar:Hide()
	ReputationWatchBar:Hide()
	MainMenuExpBar:SetAlpha(0)
	ReputationWatchBar:SetAlpha(0)
	MainMenuExpBar = function () end
	ReputationWatchBar = function () end
	
	return
end

-- EXP
local ExpBarCorner = MainMenuExpBar:CreateTexture(nil, 'OVERLAY')
ExpBarCorner:SetScale(.78)
ExpBarCorner:SetPoint('CENTER', 0, 1)
ExpBarCorner:SetTexture(cfg.assets.cast)
ExpBarCorner:SetRotation(rad(180))

MainMenuExpBar:ClearAllPoints()
MainMenuExpBar:SetPoint('BOTTOMLEFT', _G.MultiBarBottomLeftButton1, 'TOPLEFT', 20, 12)
MainMenuExpBar:SetHeight(20)
nf.CreateBar(MainMenuExpBar, true)
nf.SetInside(ExhaustionLevelFillBar)

for _, xp in pairs({_G['MainMenuExpBar'], _G['MainMenuBarMaxLevelBar']}) do
	xp:SetWidth(142)
end
	
for i = 0, 3 do _G['MainMenuXPBarTexture'..i]:SetTexCoord(0, 0, 0, 0) end

-- REP
ReputationWatchBar._SetPoint = _G.ReputationWatchBar.SetPoint
ReputationWatchBar.SetPoint = function() end
ReputationWatchBar._ClearAllPoints = _G.ReputationWatchBar.ClearAllPoints
ReputationWatchBar.ClearAllPoints = function() end

local RepBarCorner = ReputationWatchBar:CreateTexture(nil, 'OVERLAY')
RepBarCorner:SetScale(.78)
RepBarCorner:SetPoint('CENTER', -2, 1)
RepBarCorner:SetTexture(cfg.assets.cast)
RepBarCorner:SetRotation(rad(180))

ReputationWatchBar:SetHeight(20)
ReputationWatchBar:_ClearAllPoints()
ReputationWatchBar:_SetPoint('BOTTOMRIGHT', _G.MultiBarBottomLeftButton10, 'TOPRIGHT', 62, 12)
ReputationWatchBar:_SetPoint('BOTTOMLEFT', _G.MultiBarBottomLeftButton10, 'TOPLEFT', -42, 12)
ReputationWatchBar.StatusBar:ClearAllPoints()
ReputationWatchBar.StatusBar:SetAllPoints()
ReputationWatchBar.StatusBar:SetReverseFill(true)
nf.CreateBar(ReputationWatchBar.StatusBar, false)

for i = 0, 3 do
	ReputationWatchBar.StatusBar['WatchBarTexture'..i]:SetTexCoord(0, 0, 0, 0)
	ReputationWatchBar.StatusBar['XPBarTexture'..i]:SetTexCoord(0, 0, 0, 0)
end

-- experience mouseover text
MainMenuBarExpText:SetFont(cfg.assets.font, 14, 'OUTLINE')
	
if (cfg.fade.expbar) then
	MainMenuBarExpText:SetAlpha(0)
	MainMenuExpBar:HookScript('OnEnter', function()
		securecall('UIFrameFadeIn', MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 1)
	end)
	MainMenuExpBar:HookScript('OnLeave', function()
		securecall('UIFrameFadeOut', MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 0)
	end)
else
	MainMenuBarExpText:Show()
	MainMenuBarExpText.Hide = function() end
end

-- reputation mouseover text
local ReputationBarText = _G.ReputationWatchBar.OverlayFrame.Text
ReputationBarText:SetFont(cfg.assets.font, 14, 'OUTLINE')
ReputationBarText:SetShadowOffset(0, 0)

if (cfg.fade.repbar) then
	ReputationBarText:SetAlpha(0)
	ReputationWatchBar:HookScript('OnEnter', function()
		securecall('UIFrameFadeIn', ReputationBarText, 0.2, ReputationBarText:GetAlpha(), 1)
	end)
	ReputationWatchBar:HookScript('OnLeave', function()
		securecall('UIFrameFadeOut', ReputationBarText, 0.2, ReputationBarText:GetAlpha(), 0)
	end)
else
	ReputationBarText:Show()
	ReputationBarText.Hide = function () end
end
	