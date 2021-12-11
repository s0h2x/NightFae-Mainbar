local _, nf = ...
local cfg = nf.Config

-- globals
local _G = _G
local unpack, select, pairs = _G.unpack, _G.select, _G.pairs
local GetName, GetCVar = _G.GetName, _G.GetCVar
local NUM_OVERRIDE_BUTTONS = _G.NUM_OVERRIDE_BUTTONS
local TOOLTIP_UPDATE_TIME = _G.TOOLTIP_UPDATE_TIME
local MainMenuBar = _G.MainMenuBar
local CreateTexture = _G.CreateTexture
local SetVertexColor = _G.SetVertexColor
local hooksecurefunc = _G.hooksecurefunc
local bpadding = 2

local function RestyleActionButton(self)
	ActionButton_UpdateHotkeys(self, self.buttonType)
	
	local button = _G[self:GetName()]
	button:SetNormalTexture''

	if (not button.Background) then
		local normal = _G[self:GetName()..'NormalTexture']
		local edge_tex = button:CreateTexture(nil, 'OVERLAY', nil, 6)
		if normal then
			normal:ClearAllPoints()
			normal:SetPoint('TOPRIGHT', button, bpadding, bpadding)
			normal:SetPoint('BOTTOMLEFT', button, -bpadding, -bpadding)
			
			edge_tex:SetSize(button:GetSize())
			edge_tex:SetAllPoints(normal)
			edge_tex:SetTexture(cfg.assets.normal)
			edge_tex:SetVertexColor(unpack(cfg.colors.normal))
			
			normal:SetTexture(edge_tex)
		end
		
		local icon = _G[self:GetName()..'Icon']
		icon:SetTexCoord(unpack(nf.texcoord))
		nf.SetInside(icon)

		button:SetPushedTexture(cfg.assets.pushed)
		button:GetPushedTexture():SetAllPoints(normal)
		button:GetPushedTexture():SetDrawLayer('OVERLAY', 7)

		button:SetHighlightTexture(cfg.assets.normal)
		button:GetHighlightTexture():SetAllPoints(normal)
		button:GetHighlightTexture():SetVertexColor(1, .82, 0)

		local count = _G[self:GetName()..'Count']
		if count then
			if (not cfg.global.count) then
				count:SetAlpha(0)
			else
				count:SetPoint('BOTTOMRIGHT', button, 0, 1)
				count:SetFont(cfg.assets.font, cfg.size.count, 'OUTLINE')
				count:SetVertexColor(unpack(cfg.colors.count))
			end
		end

		local macroname = _G[self:GetName()..'Name']
		if macroname then
			if (not cfg.global.macro) then
				macroname:SetAlpha(0)
			else
				macroname:SetWidth(button:GetWidth() + 15)
				macroname:SetFont(cfg.assets.font, cfg.size.macro, 'OUTLINE')
				macroname:SetVertexColor(unpack(cfg.colors.macro))
			end
		end

		local buttonBg = _G[self:GetName()..'FloatingBG']
		if buttonBg then
			buttonBg:ClearAllPoints()
			buttonBg:SetPoint('TOPRIGHT', button, 3, 3)
			buttonBg:SetPoint('BOTTOMLEFT', button, -3, -3)
			buttonBg:SetTexture''
		end

		button.Background = button:CreateTexture(nil, 'BACKGROUND', nil, -8)
		button.Background:SetTexture(cfg.assets.button)
		button.Background:SetPoint('TOPRIGHT', button, 14, 12)
		button.Background:SetPoint('BOTTOMLEFT', button, -14, -16)
	end

	if (not InCombatLockdown()) then
		local cooldown = _G[self:GetName()..'Cooldown']
		nf.SetInside(cooldown, 1, 1)
		cooldown:SetFrameLevel(button:GetFrameLevel())
	end

	local border = _G[self:GetName()..'Border']
	if border then
		if (_G.IsEquippedAction(self.action)) then
			_G[self:GetName()..'Border']:SetAlpha(1)
			_G[self:GetName()..'Border']:SetVertexColor(unpack(cfg.colors.isequipped))
		else
			_G[self:GetName()..'Border']:SetAlpha(0)
		end
	end
end

local function RestylePetButton()
	for _, name in pairs({'PetActionButton','PossessButton','StanceButton'}) do
		for i = 1, 12 do
			local button = _G[name..i]
			if button then
				button:SetNormalTexture''
				if (not button.isSkinned) then
					local normal = _G[name..i..'NormalTexture2'] or _G[name..i..'NormalTexture']
					normal:ClearAllPoints()
					normal:SetPoint('TOPRIGHT', button, 1.5, 1.5)
					normal:SetPoint('BOTTOMLEFT', button, -1.5, -1.5)
					
					local border = _G[name..i..'Border']
					if border then
						local edge_tex = button:CreateTexture(nil, 'BORDER', nil, 7)
						edge_tex:SetSize(button:GetSize())
						edge_tex:SetAllPoints(normal)
						edge_tex:SetTexture(cfg.assets.normal)
						edge_tex:SetVertexColor(unpack(cfg.colors.normal))
					
						border:SetTexture(edge_tex)
					end

					local icon = _G[name..i..'Icon']
					icon:SetTexCoord(unpack(nf.texcoord))
					nf.SetInside(icon)

					local flash = _G[name..i..'Flash']
					flash:SetColorTexture(0.8, 0.8, 0.8, 0.5)
					flash:SetPoint('TOPLEFT', button, 2, -2)
					flash:SetPoint('BOTTOMRIGHT', button, -2, 2)
					
					button:SetCheckedTexture(cfg.assets.active)
					button:GetCheckedTexture():SetAllPoints(normal)
					button:GetCheckedTexture():SetDrawLayer('OVERLAY')

					button:SetPushedTexture(cfg.assets.pushed)
					button:GetPushedTexture():SetAllPoints(normal)
					button:GetPushedTexture():SetDrawLayer('OVERLAY')

					button:SetHighlightTexture(cfg.assets.normal)
					button:GetHighlightTexture():SetAllPoints(normal)
					button:GetHighlightTexture():SetVertexColor(1, .82, 0)

					local hotkey = _G[name..i..'HotKey']
					if cfg.global.hotkey then
						hotkey:ClearAllPoints()
						hotkey:SetPoint('TOPRIGHT', button, 0, -3)
						hotkey:SetFont(cfg.assets.font, 14, 'OUTLINE')
						hotkey:SetVertexColor(unpack(cfg.colors.hotkey))
					end
		
					if button.QuickKeybindHighlightTexture then
						button.QuickKeybindHighlightTexture:SetTexture''
					end
				
					if (not InCombatLockdown()) then
						local cooldown = _G[name..i..'Cooldown']
						--cooldown:SetInside(button, 1, 1)
						nf.SetInside(cooldown, 1, 1)
						cooldown:SetFrameLevel(button:GetFrameLevel())
						cooldown:SetDrawEdge(true)
					end
					
					button.isSkinned = true
				end
			end
		end
	end
end

local function SetupButtonGrid()
	MainMenuBar:SetMovable(true)
	MainMenuBar:SetUserPlaced(true)
	MainMenuBar.ignoreFramePositionManager = true
	MainMenuBar:SetAttribute('ignoreFramePositionManager', true)

	-- update button grid
	local function buttonShowGrid(name, showgrid)
		for i = 1, 12 do
			local button = _G[name..i]
			button:SetAttribute('showgrid', showgrid)
			ActionButton_ShowGrid(button, ACTION_BUTTON_SHOW_GRID_REASON_CVAR)
		end
	end
	
	local updateAfterCombat
	local function ToggleButtonGrid()
		if InCombatLockdown() then
			updateAfterCombat = true
			F:RegisterEvent('PLAYER_REGEN_ENABLED', ToggleButtonGrid)
		else
			local showgrid = tonumber(GetCVar('alwaysShowActionBars'))
			buttonShowGrid('ActionButton', showgrid)
			buttonShowGrid('MultiBarBottomLeftButton', showgrid)
			buttonShowGrid('MultiBarBottomRightButton', showgrid)
			if updateAfterCombat then
				F:UnregisterEvent('PLAYER_REGEN_ENABLED', ToggleButtonGrid)
				updateAfterCombat = false
			end
		end
	end
	hooksecurefunc('MultiActionBar_UpdateGridVisibility', ToggleButtonGrid)
	hooksecurefunc('ActionButton_ShowGrid', function(self)
		local normal = _G[self:GetName()..'NormalTexture']
		if normal then
			normal:SetVertexColor(unpack(cfg.colors.normal))
		end
	end)
end

-- hook
hooksecurefunc('PetActionBar_Update', RestylePetButton)
securecall('PetActionBar_Update') -- force update
	
hooksecurefunc('ActionButton_Update', RestyleActionButton)
hooksecurefunc('ActionButton_UpdateUsable', function(self)
	if (IsAddOnLoaded('tullaRange') or IsAddOnLoaded('RangeColors')) then return end
	
	local normal = _G[self:GetName()..'NormalTexture']
	if normal then
		normal:SetVertexColor(unpack(cfg.colors.normal))
	end

	local isUsable, notEnoughMana = IsUsableAction(self.action)
	
	if isUsable then
		_G[self:GetName()..'Icon']:SetVertexColor(1, 1, 1)
	elseif (notEnoughMana) then
		_G[self:GetName()..'Icon']:SetVertexColor(unpack(cfg.colors.rangemana))
	else
		_G[self:GetName()..'Icon']:SetVertexColor(unpack(cfg.colors.notusable))
	end
end)

hooksecurefunc('ActionButton_UpdateHotkeys', function(self, actionButtonType)
	local hotkey = _G[self:GetName()..'HotKey']
	if cfg.global.hotkey then
		hotkey:ClearAllPoints()
		hotkey:SetPoint('TOPRIGHT', self, 0, -3)
		hotkey:SetFont(cfg.assets.font, cfg.size.hotkey, 'OUTLINE')
		hotkey:SetVertexColor(unpack(cfg.colors.hotkey))
	else
		hotkey:Hide()
	end
end)

hooksecurefunc('ActionButton_OnUpdate', function(self, elapsed)
	if (IsAddOnLoaded('tullaRange') or IsAddOnLoaded('RangeColors')) then return end
	
	if (self.rangeTimer == TOOLTIP_UPDATE_TIME) then
		local hotkey = _G[self:GetName()..'HotKey']
		local valid = IsActionInRange(self.action)
		if hotkey:GetText() == RANGE_INDICATOR then
			if valid == false then
				hotkey:Show()
				if cfg.global.range then
					_G[self:GetName()..'Icon']:SetVertexColor(unpack(cfg.colors.rangeout))
					hotkey:SetVertexColor(unpack(cfg.colors.rangeout))
				else
					hotkey:SetVertexColor(unpack(cfg.colors.rangeout))
				end
			elseif valid then
				hotkey:Show()
				hotkey:SetVertexColor(unpack(cfg.colors.hotkey))
				ActionButton_UpdateUsable(self)
			else
				hotkey:Hide()
			end
		else
			if valid == false then
				if cfg.global.range then
					_G[self:GetName()..'Icon']:SetVertexColor(unpack(cfg.colors.rangeout))
					hotkey:SetVertexColor(unpack(cfg.colors.rangeout))
				else
					hotkey:SetVertexColor(unpack(cfg.colors.rangeout))
				end
			else
				hotkey:SetVertexColor(unpack(cfg.colors.hotkey))
				ActionButton_UpdateUsable(self)
			end
		end
	end
end)