slark_essence_shift_lua = class({})

function slark_essence_shift_lua:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_slark/slark_essence_shift.vpcf",
	}, {
	}, context)
end

LinkLuaModifier( "modifier_slark_essence_shift_lua", "heroes/hero_slark/essence_shift/slark_essence_shift_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_essence_shift_lua_stack", "heroes/hero_slark/essence_shift/slark_essence_shift_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function slark_essence_shift_lua:GetIntrinsicModifierName()
	return "modifier_slark_essence_shift_lua"
end

modifier_slark_essence_shift_lua = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_essence_shift_lua:IsHidden()
	return false
end

function modifier_slark_essence_shift_lua:IsDebuff()
	return false
end

function modifier_slark_essence_shift_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_essence_shift_lua:OnCreated( kv )
	-- references
	self.agi_gain = self:GetAbility():GetSpecialValueFor( "agi_gain" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_slark_essence_shift_lua:OnRefresh( kv )
	-- references
	self.agi_gain = self:GetAbility():GetSpecialValueFor( "agi_gain" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_slark_essence_shift_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_slark_essence_shift_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}

	return funcs
end
function modifier_slark_essence_shift_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		-- filter enemy
		local target = params.target
		if target:IsIllusion() or target:IsBuilding() then
			return
		end
        
        local level = target:GetLevel()   
        local abs_stack = math.floor(level/10)  
        local random_stack = level%10
        local count_stuck = 0

        if abs_stack >= 1 then 
        	count_stuck = abs_stack
        end

        if RollPseudoRandomPercentage(random_stack*10, 1, self:GetCaster()) then 
		    count_stuck = count_stuck + 1              
        end 
        
        if count_stuck >= 1 then 
            self:AddStack( duration,count_stuck )
            self:PlayEffects( params.target )  
        end

        print(level)
	end
end

function modifier_slark_essence_shift_lua:GetModifierBonusStats_Agility()
	return self:GetStackCount() * self.agi_gain
end

--------------------------------------------------------------------------------
-- Helper
function modifier_slark_essence_shift_lua:AddStack( duration, count )
	-- Add counter
	local mod = self:GetParent():AddNewModifier(
		self:GetParent(),
		self:GetAbility(),
		"modifier_slark_essence_shift_lua_stack",
		{
			duration = self.duration,
		}
	)
	mod.modifier = self
    mod.bonus = count
	-- Add stack
	self:SetStackCount(self:GetStackCount() + count)
 
end


function modifier_slark_essence_shift_lua:RemoveStack( value )
	self:SetStackCount( self:GetStackCount() - value )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_slark_essence_shift_lua:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_slark/slark_essence_shift.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() + Vector( 0, 0, 64 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

modifier_slark_essence_shift_lua_stack = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_essence_shift_lua_stack:IsHidden()
	return true
end

function modifier_slark_essence_shift_lua_stack:IsPurgable()
	return false
end
function modifier_slark_essence_shift_lua_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_essence_shift_lua_stack:OnCreated( kv )
end

function modifier_slark_essence_shift_lua_stack:OnRemoved()
	if IsServer() then
		self.modifier:RemoveStack(self.bonus)
	end
end