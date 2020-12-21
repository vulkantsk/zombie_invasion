 
--------------------------------------------------------------------------------
modifier_axe_solo = {}

--------------------------------------------------------------------------------
-- Classifications
 

 
 
function modifier_axe_solo:OnTooltip()
	return self:GetStackCount()
end


function modifier_axe_solo:OnIntervalThink()

		local units = FindUnitsInRadius(
			DOTA_TEAM_GOODGUYS,
			self:GetParent():GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_BOTH,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
			FIND_CLOSEST,
			false
		)

		local count = 0 

		for _, hero in pairs( units ) do

				count = count + 1
			
		end
      self:GetCaster():CalculateStatBonus(true)
		self:SetStackCount( count )
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_axe_solo:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.armor = self:GetAbility():GetSpecialValueFor( "bonuss_armor" )
	self.strength = self:GetAbility():GetSpecialValueFor( "bonuss_strength" )	
	self.model = self:GetAbility():GetSpecialValueFor( "bonus_model" )
	self.regen = self:GetAbility():GetSpecialValueFor( "bonuss_regen" )	
		self:StartIntervalThink( 0.2 )

end

function modifier_axe_solo:OnRefresh( kv )
	-- references
	self:OnCreated()
 
 end
function modifier_axe_solo:OnRemoved()
end

function modifier_axe_solo:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_axe_solo:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_axe_solo:GetModifierConstantHealthRegen()
	if not self:GetParent():PassivesDisabled() then
		return self.regen/(self:GetStackCount() + 1)
	end
end

function modifier_axe_solo:GetModifierModelScale()
	if not self:GetParent():PassivesDisabled() then
		return self.model/(self:GetStackCount() + 1)
	end
end

function modifier_axe_solo:GetModifierBonusStats_Strength()
	if not self:GetParent():PassivesDisabled() then
		return self.strength/(self:GetStackCount() + 1)
	end
end

function modifier_axe_solo:GetModifierPhysicalArmorBonus()
	if not self:GetParent():PassivesDisabled() then
		return self.armor/(self:GetStackCount() + 1)
			end
end