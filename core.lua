local _, nf = ...
local cfg = nf.Config

local _G = _G
local unpack = unpack

nf.endfunc = function () end
nf.nope = CreateFrame('Frame', nil, UIParent)
nf.nope:Hide()
nf.texcoord = {.08, .92, .08, .92}

-- api
local function DisablePixelSnap(self)
	if (self and not self:IsForbidden()) and not self.PixelSnapDisabled then
		if (self.SetSnapToPixelGrid) then
			self:SetSnapToPixelGrid(false)
			self:SetTexelSnappingBias(0)
		elseif (self.GetStatusBarTexture) then
			local Texture = self:GetStatusBarTexture()
			if (Texture and Texture.SetSnapToPixelGrid) then
				Texture:SetSnapToPixelGrid(false)
				Texture:SetTexelSnappingBias(0)
			end
		end

		self.PixelSnapDisabled = true
	end
end

local function PointsRestricted(self)
	if self and not pcall(self.GetPoint, self) then
		return true
	end
end

nf.SetInside = function(obj, a1, xOfs, yOfs, a2, noScale)
	if (not a1) then a1 = obj:GetParent() end

	if (not xOfs) then xOfs = 1 end
	if (not yOfs) then yOfs = 1 end
	
	local x = (noScale and xOfs) or xOfs
	local y = (noScale and yOfs) or yOfs

	assert(a1)
	
	if PointsRestricted(obj) or obj:GetPoint() then
		obj:ClearAllPoints()
	end
	
	DisablePixelSnap(obj)

	obj:SetPoint('TOPLEFT', a1, 'TOPLEFT', x, -y)
	obj:SetPoint('BOTTOMRIGHT', a2 or a1, 'BOTTOMRIGHT', -x, y)
end

nf.IsTaintable = function()
    return (InCombatLockdown() or (UnitAffectingCombat('player') or UnitAffectingCombat('pet')))
end

nf.CreateBar = function(self, spark, r, g, b)
	if self:GetObjectType() == 'StatusBar' then
		self:SetStatusBarTexture('Interface\\TARGETINGFRAME\\UI-TargetingFrame-BarFill')
	else
		self:SetTexture('Interface\\TARGETINGFRAME\\UI-TargetingFrame-BarFill')
	end
	
	if r and g and b then
		self:SetStatusBarColor(r, g, b)
	end
	
	--self:CreateShadow()
	--self:CreateBackdrop('Inside')
	--self.__bg:CreateStriped()

	if spark then
		self.Spark = self:CreateTexture(nil, 'OVERLAY')
		self.Spark:SetTexture('Interface\\CastingBar\\UI-CastingBar-Spark')
		self.Spark:SetBlendMode('ADD')
		self.Spark:SetAlpha(.8)
		self.Spark:SetPoint('TOPLEFT', self:GetStatusBarTexture(), 'TOPRIGHT', -10, 10)
		self.Spark:SetPoint('BOTTOMRIGHT', self:GetStatusBarTexture(), 'BOTTOMRIGHT', 10, -10)
	end
end

