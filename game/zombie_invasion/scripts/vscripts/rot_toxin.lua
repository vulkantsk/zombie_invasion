LinkLuaModifier("modifier_rot_effect","rot_toxin.lua", LUA_MODIFIER_MOTION_NONE)
function StartTouchDamage( trigger )
    local ent = trigger.activator

    ent:AddNewModifier(ent, self, "modifier_rot_effect", {})
end

function EndTouch( trigger )
    local ent = trigger.activator
    ent:RemoveModifierByName("modifier_rot_effect")
end

-----------------------------------------------------------------------------------------

modifier_rot_effect = modifier_rot_effect or class({})

function modifier_rot_effect:IsHidden()
    return false
end

function modifier_rot_effect:IsPassive()
    return false
end

function modifier_rot_effect:IsPurgable()
    return false
end

function modifier_rot_effect:IsDebuff()
    return true
end

 

function modifier_rot_effect:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink( 0.5 )
end

function modifier_rot_effect:OnIntervalThink()
    if IsServer() then
        local damage_table = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            ability = self,
            damage = 75,
            damage_type = DAMAGE_TYPE_PURE
        }
        ApplyDamage(damage_table)
    end
end

function modifier_rot_effect:GetEffectName()
    return "particles/econ/events/ti9/pudgling_rot_body.vpcf"
end

function modifier_rot_effect:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

 function modifier_rot_effect:GetTexture()
    return "pudge_rot"
end  
