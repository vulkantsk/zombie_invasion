LinkLuaModifier( "modifier_blackshop_epic_vampire_blood", "items/blackshop_items/blackshop_epic/blackshop_epic_vampire_blood", LUA_MODIFIER_MOTION_NONE )
item_blackshop_epic_vampire_blood = class({})
function item_blackshop_epic_vampire_blood:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_epic_vampire_blood")
    self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_epic_vampire_blood", {}):IncrementStackCount()

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        UTIL_Remove(hItem)
        return
    end
    hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end

modifier_blackshop_epic_vampire_blood = class({})
function modifier_blackshop_epic_vampire_blood:IsHidden()
    return true
end

function modifier_blackshop_epic_vampire_blood:IsDebuff()
    return false
end

function modifier_blackshop_epic_vampire_blood:IsPurgable()
    return false
end

function modifier_blackshop_epic_vampire_blood:RemoveOnDeath()
    return false
end

function modifier_blackshop_epic_vampire_blood:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_blackshop_epic_vampire_blood:OnTakeDamage(params)
    if not IsServer() then return end
    if self:GetParent() ~= params.attacker then return end
    if params.unit == nil or self:GetParent() == params.unit then return end
    if params.unit:IsBuilding() then return end
    if params.unit:IsWard() then return end
    if params.inflictor == nil and not self:GetParent():IsIllusion() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then 
        local heal = self:GetStackCount() * 0.02 * params.damage
        self:GetParent():Heal(heal, self:GetAbility())

        local particle = "particles/generic_gameplay/generic_lifesteal.vpcf"

       

        local effect_cast = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, params.attacker )
        ParticleManager:ReleaseParticleIndex( effect_cast )
    end
end
