if item_necr_heart == nil then
	item_necr_heart = class({})
 
end
LinkLuaModifier("modifier_necr_heart", "items/drop_item/item_necr_heart", LUA_MODIFIER_MOTION_NONE)



 
-------------------------------------------
function item_necr_heart:GetIntrinsicModifierName()
    return "modifier_necr_heart"
end

-------------------------------------------
modifier_necr_heart = class({})
function modifier_necr_heart:IsDebuff() return true end
function modifier_necr_heart:IsHidden() return true end
function modifier_necr_heart:IsPermanent() return true end
function modifier_necr_heart:IsPurgable() return false end
function modifier_necr_heart:IsPurgeException() return false end
function modifier_necr_heart:IsStunDebuff() return false end
function modifier_necr_heart:RemoveOnDeath() return true end


function modifier_necr_heart:OnCreated( kv )
	-- references 		self:SetStackCount( count )
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
    
   self.ability = self:GetAbility()
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )  
	self.hit_damage = self:GetAbility():GetSpecialValueFor( "hit_damage" )  
      
		self:StartIntervalThink( 0.2 )
		self:OnIntervalThink()  
end

function modifier_necr_heart:OnRefresh( kv )
	-- references
	self.hit_damage = self:GetAbility():GetSpecialValueFor( "hit_damage" )
 
end
 
 
 


function modifier_necr_heart:OnRemoved()
end

function modifier_necr_heart:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects

function modifier_necr_heart:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS
 
	}
    return decFuns
end

function modifier_necr_heart:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_necr_heart:OnIntervalThink()
	if IsServer() then
		   local target = self:GetParent()
   local caster = self:GetCaster()
		local flDamagePerTick =   0.2 * self.hit_damage   
 
 

		if self:GetCaster():IsAlive() then
			local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = flDamagePerTick * self.ability:GetCurrentCharges(),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

			ApplyDamage( damage )
		end
	end
end

function modifier_necr_heart:GetModifierPreAttack_BonusDamage()
		return self.damage * self.ability:GetCurrentCharges()
end


 
 
 