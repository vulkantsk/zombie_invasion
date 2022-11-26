enigma_eyes = class({})

LinkLuaModifier( "modifier_enigma_eyes", "heroes/hero_enigma/enigma_eyes/enigma_eyes", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_eyes_debuff", "heroes/hero_enigma/enigma_eyes/enigma_eyes", LUA_MODIFIER_MOTION_NONE )

function enigma_eyes:OnSpellStart()
     local caster = self:GetCaster()

     caster:AddNewModifier(caster, self, "modifier_enigma_eyes", { duration =  self:GetSpecialValueFor("duration")})

end 

modifier_enigma_eyes = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return 
        {

            MODIFIER_PROPERTY_MODEL_CHANGE,
            MODIFIER_EVENT_ON_ATTACK_LANDED
        } end,
    CheckState      = function(self) return 
        {
 		[MODIFIER_STATE_MUTED] = true,  
  		[MODIFIER_STATE_SILENCED] = true,       
  
        } end,
})

function modifier_enigma_eyes:OnAttackLanded(keys)
    if keys.attacker == self:GetParent() and self:GetParent():IsAlive() and not self:GetParent():IsIllusion()  and not keys.target:IsBuilding() and not keys.target:IsOther() then

        local modif = keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_enigma_eyes_debuff", { duration = self:GetRemainingTime()})
        modif:SetStackCount(modif:GetStackCount() + 1)
    end
end


function modifier_enigma_eyes:GetModifierModelChange()
    return "models/items/enigma/eidolon/geodesic/geodesic.vmdl"
end

modifier_enigma_eyes_debuff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return 
        {

 
            MODIFIER_EVENT_ON_ATTACK_LANDED
        } end,
 
})

function modifier_enigma_eyes_debuff:OnAttackLanded(keys)
 if keys.target ~= self:GetParent()  then return end
     if keys.attacker == self:GetParent()  then return end
    if keys.attacker:HasModifier("modifier_enigma_eyes") or keys.attacker:GetUnitName() == 'npc_classic_eidolon' then
 
             ApplyDamage({
                attacker = keys.attacker, 
                victim = self:GetParent(), 
                ability = self:GetAbility(), 
                damage = self:GetAbility():GetSpecialValueFor("damage_per_stack") * self:GetStackCount(),
                damage_type = DAMAGE_TYPE_PURE
            })  		      
    end
end

 

 