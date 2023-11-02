LinkLuaModifier("modifier_lucent", "items/book_of_heroes/heroes/item_npc_dota_hero_luna", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_luna = class({})

function item_npc_dota_hero_luna:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("luna_buff_1") then 
          caster:AddAbility("luna_buff_1"):SetLevel(1)
          caster:RemoveItem(hItem)
        end
end



luna_buff_1 = class({})

function luna_buff_1:GetIntrinsicModifierName()
    return "modifier_lucent"
end


modifier_lucent = class({
    IsHidden        = function(self) return true end,
    GetAttributes   = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions  = function(self) return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }end,
})


function modifier_lucent:OnCreated( data )
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_lucent:OnRefresh()
    self:OnCreated()
end

function modifier_lucent:OnAttackLanded( data )
    local caster = self:GetCaster()
    local target = data.target
    local attacker = data.attacker
    local damageTable = {
        victim = target,
        attacker = self:GetParent(),
        damage = self.damage + (self:GetCaster():GetAgility() * (self:GetAbility():GetSpecialValueFor("agi_pct") / 100)),
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
    }

    if attacker == caster then
        ApplyDamage(damageTable)
    local effect_cast = ParticleManager:CreateParticle(
        "particles/econ/items/luna/luna_lucent_ti5/luna_lucent_beam_impact_shared_ti_5.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        target
    )
    ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        1,
        target,
        PATTACH_ABSORIGIN_FOLLOW,
        "attach_hitloc",
        Vector(),
        true
    )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        5,
        target,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(),
        true
    )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        6,
        self:GetCaster(),
        PATTACH_POINT_FOLLOW,
        "attach_attack1",
        Vector(),
        true
    )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    EmitSoundOn( "Hero_Luna.LucentBeam.Cast", self:GetCaster() )
    EmitSoundOn( "Hero_Luna.LucentBeam.Target", target )
    end
end