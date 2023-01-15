LinkLuaModifier ("modifier_item_blademail", "items/new_items/item_blademail.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_blademail_passive", "items/new_items/item_blademail.lua", LUA_MODIFIER_MOTION_NONE)

if item_blademail == nil then
    item_blademail = class ( {})
end

if item_blademail_2 == nil then
    item_blademail_2 = item_blademail
end

 

function item_blademail:GetIntrinsicModifierName ()
    return "modifier_item_blademail_passive"
end

function item_blademail:OnSpellStart ()
    local duration = self:GetSpecialValueFor ("duration")
    local caster = self:GetCaster ()
    EmitSoundOn("DOTA_Item.BladeMail.Activate", caster)
    caster:AddNewModifier(caster, self, "modifier_item_blademail", {duration = duration})
end


if modifier_item_blademail == nil then
    modifier_item_blademail = class({})
end


function modifier_item_blademail:IsPurgable()
    return false
end

function modifier_item_blademail:GetEffectName()
    return "particles/items_fx/blademail.vpcf"
end

function modifier_item_blademail:OnCreated()
    self.damage_return = self:GetAbility():GetSpecialValueFor("active_reflection_pct")/100
end

function modifier_item_blademail:OnRefresh()
    self.damage_return = self:GetAbility():GetSpecialValueFor("active_reflection_pct")/100
end


function modifier_item_blademail:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_item_blademail:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() and params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber()  and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
            local target = params.attacker

            if target == self:GetParent() then
                return
            end

            if target:IsBuilding() then
        	   return
            end
 
            ApplyDamage ( {
                victim = target,
                attacker = self:GetParent(),
                damage = params.original_damage * self.damage_return,
                damage_type = params.damage_type ,
                ability = self:GetAbility(),
                damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            })
            EmitSoundOnClient("DOTA_Item.BladeMail.Damage", params.attacker:GetPlayerOwner())
        end
    end
end

if modifier_item_blademail_passive == nil then
    modifier_item_blademail_passive = class({})
end

function modifier_item_blademail_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_blademail_passive:IsHidden()
    return true
end

function modifier_item_blademail_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }

    return funcs
end

function modifier_item_blademail_passive:GetModifierIncomingDamage_Percentage()
	return -self:GetAbility():GetSpecialValueFor("bonus_resistance")
end

function modifier_item_blademail_passive:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_blademail_passive:GetModifierPhysicalArmorBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_armor")
end

function modifier_item_blademail_passive:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_intellect")
end

function modifier_item_blademail_passive:OnCreated()
    self.damage_return_pct = self:GetAbility():GetSpecialValueFor("passive_reflection_pct")/100
    self.damage_return_cnst = self:GetAbility():GetSpecialValueFor("passive_reflection_constant") 
end

function modifier_item_blademail_passive:OnRefresh()
    self.damage_return_pct = self:GetAbility():GetSpecialValueFor("passive_reflection_pct")/100
    self.damage_return_cnst = self:GetAbility():GetSpecialValueFor("passive_reflection_constant") 
end

 function modifier_item_blademail_passive:OnTakeDamage( params )
 	if not IsServer() then return end
    if not self:GetParent():HasModifier("modifier_item_blademail") then 
		 if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and params.unit == self:GetParent() and not params.attacker:IsBuilding() and params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and params.damage_type == 1 and params.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
			-- Particle effect
		ApplyDamage({
			victim = params.attacker,
			attacker = params.unit,
			damage = (params.original_damage * self.damage_return_pct) + self.damage_return_cnst,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		}) 
		end
    end
end