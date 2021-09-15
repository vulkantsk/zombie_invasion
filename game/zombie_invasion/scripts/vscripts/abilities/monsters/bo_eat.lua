bo_eat = class({})
 
LinkLuaModifier( "modifier_bo_eat", "abilities/monsters/bo_eat", LUA_MODIFIER_MOTION_NONE )
 

--------------------------------------------------------------------------------
-- Passive Modifier
function bo_eat:GetIntrinsicModifierName()
	return "modifier_bo_eat"
end

 
modifier_bo_eat = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_bo_eat:IsHidden()
	return true
end

function modifier_bo_eat:IsDebuff()
	return true
end

function modifier_bo_eat:IsStunDebuff()
	return false
end

function modifier_bo_eat:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_bo_eat:OnCreated( kv )
	-- references
			local caster = self:GetCaster()
			local ability = self:GetAbility()
    if not IsServer() then return end
    self:StartIntervalThink( 0.2 )

 
end

	local bo = 1

 function modifier_bo_eat:OnIntervalThink( kv )
	-- references
     if IsServer() then

     if bo == 1 then 
        bo = bo + 1

        local damage_table = {
            victim = self:GetCaster(),
            attacker = self:GetCaster(),
            ability = self,
            damage = self:GetCaster():GetMaxHealth() * 0.75,
            damage_type = DAMAGE_TYPE_PURE
        }
        ApplyDamage(damage_table)
     end 
 end
end

 