local _, nf = ...
local cfg = nf.Config

-- globals
local _G = _G
local unpack, select = _G.unpack, _G.select
local MouseIsOver = _G.MouseIsOver
local onclass = select(2, UnitClass('player'))

local function GetNumStanceSlots()
	if onclass == 'WARRIOR' then
		return 3
	elseif onclass == 'ROGUE' or onclass == 'PRIEST' then
		return 1
	else
		return _G.NUM_STANCE_SLOTS
	end
end

-- fader function
local function CreateFader(self, bar, Min, Max, alpha)
	local minAlpha = cfg.fade.alpha.minimal

	for i = Min, Max do
		local button = _G[self..i]
		local f = CreateFrame('Frame', bar, bar)
		f:SetFrameStrata('LOW')
		f:SetFrameLevel(1)
		f:EnableMouse(true)
		f:SetPoint('TOPLEFT', self..Min, -5, 5)
		f:SetPoint('BOTTOMRIGHT', self..Max, 5, 5)

		bar:SetAlpha(minAlpha)

		f:SetScript('OnEnter', function()
			securecall('UIFrameFadeIn', bar, 0.2, bar:GetAlpha(), alpha)
		end)

		f:SetScript('OnLeave', function() 
			if (not MouseIsOver(button)) then
				securecall('UIFrameFadeOut', bar, 0.2, bar:GetAlpha(), minAlpha)
			end
		end)

		button:HookScript('OnEnter', function()
			securecall('UIFrameFadeIn', bar, 0.2, bar:GetAlpha(), alpha)
		end)

		button:HookScript('OnLeave', function() 
			if (not MouseIsOver(bar)) then
				securecall('UIFrameFadeOut', bar, 0.2, bar:GetAlpha(), minAlpha)
			end
		end)
	end
end

if cfg.fade.leftbar then
	CreateFader('MultiBarLeftButton', _G.MultiBarLeft, 1, 12, cfg.fade.alpha.leftbar)
end

if cfg.fade.rightbar then
	CreateFader('MultiBarRightButton', _G.MultiBarRight, 1, 12, cfg.fade.alpha.rightbar)
end

if cfg.fade.bottomleftbar then
	CreateFader('MultiBarBottomLeftButton', _G.MultiBarBottomLeft, 1, 12, cfg.fade.alpha.bottomleftbar)
end

if (cfg.fade.bottomrightbar) then
	CreateFader('MultiBarBottomRightButton', _G.MultiBarBottomRight, 1, 12, cfg.fade.alpha.bottomrightbar)
end

if (cfg.fade.petbar) then
	CreateFader('PetActionButton', _G.PetActionBarFrame, 1, 10, cfg.fade.alpha.petbar)
end

if (cfg.fade.stancebar) then
	CreateFader('StanceButton', _G.StanceBarFrame, 1, GetNumStanceSlots(), cfg.fade.alpha.stancebar)
end

-- fix blizzard cooldown flash
local function FixCooldownFlash(self)
	if (not self) then return end
	if self:GetEffectiveAlpha() > 0 then
		self:Show()
	else
		self:Hide()
	end
end
hooksecurefunc(getmetatable(ActionButton1Cooldown).__index, 'SetCooldown', FixCooldownFlash)
