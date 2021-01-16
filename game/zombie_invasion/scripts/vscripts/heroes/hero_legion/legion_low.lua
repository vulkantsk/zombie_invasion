LinkLuaModifier("modifier_50", "heroes/hero_legion/legion_low", LUA_MODIFIER_MOTION_NONE)

legion_low = class({})

function legion_low:GetIntrinsicModifierName()
	return "modifier_50"
end

modifier_50 = class({})

function modifier_50:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

    }
    return funcs
end

function modifier_50:IsHidden()
    return true
end

function modifier_50:IsPurgable()
    return false
end

function modifier_50:RemoveOnDeath()
    return true
end

function modifier_50:OnCreated(kv)
    self:StartIntervalThink(0.2)
end

function modifier_50:OnIntervalThink()
	local caster = self:GetCaster()
	local current_health = caster:GetHealth()
	local polovina = caster:GetMaxHealth() / 2
	print("P:",current_health)
	print("D:",polovina)	
	if current_health < polovina then
		print("da")
    	number = self:GetAbility():GetSpecialValueFor( "one" )
	end
   	print("A:",number)	 
--    self:GetStackCount(number)
end

function modifier_50:OnRefresh( kv )
	self:OnCreated()
end    

function modifier_50:GetModifierPhysicalArmorBonus()
    return self:GetStackCount() * 20
end