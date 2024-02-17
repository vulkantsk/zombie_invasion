LinkLuaModifier( "modifier_blackshop_epic_rocket_shot", "items/blackshop_items/blackshop_epic/blackshop_epic_rocket_shot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blackshop_epic_rocket_shot_autocast", "items/blackshop_items/blackshop_epic/blackshop_epic_rocket_shot", LUA_MODIFIER_MOTION_NONE )
item_blackshop_epic_rocket_shot = class({})
function item_blackshop_epic_rocket_shot:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_epic_rocket_shot")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddAbility("blackshop_epic_rocket_shot"):SetLevel(1)
        self.caster:AddNewModifier( self.caster, nil, "modifier_blackshop_epic_rocket_shot_autocast", {} )
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_epic_rocket_shot", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        self.caster:RemoveItem(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end

blackshop_epic_rocket_shot = class({})

function blackshop_epic_rocket_shot:OnSpellStart()
    local caster = self:GetCaster()
    local damage = self:GetSpecialValueFor("damage")
    local radius = self:GetSpecialValueFor("radius")
    local targets = self:GetSpecialValueFor("targets") * caster:FindModifierByName("modifier_blackshop_epic_rocket_shot"):GetStackCount()
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
        FIND_CLOSEST,
        false
    )
    local info = {
        Source = caster,
        Ability = self,
        EffectName = "particles/econ/items/clockwerk/clockwerk_paraflare/clockwerk_para_rocket_flare.vpcf",
        iMoveSpeed = self:GetSpecialValueFor("speed"),
        bDodgeable = true,
        ExtraData = {
            damage = damage * caster:FindModifierByName("modifier_blackshop_epic_rocket_shot"):GetStackCount(),
        }
    }
    for i=1,math.min(targets,#enemies) do
        info.Target = enemies[i]
        ProjectileManager:CreateTrackingProjectile( info )
    end

    if #enemies<1 then
        local attach = "attach_attack1"
        if self:GetCaster():ScriptLookupAttachment( "attach_attack3" )~=0 then attach = "attach_attack3" end
        local point = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( attach ) )

        local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/clockwerk/clockwerk_paraflare/clockwerk_para_rocket_flare_explosion_flameouts.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl( effect_cast, 0, point )
        ParticleManager:SetParticleControlForward( effect_cast, 0, self:GetCaster():GetForwardVector() )
        ParticleManager:ReleaseParticleIndex( effect_cast )
        EmitSoundOn( "Hero_Tinker.Heat-Seeking_Missile", caster )
        
    end
end

function blackshop_epic_rocket_shot:OnRefresh()
    self:OnCreated()
end


function blackshop_epic_rocket_shot:OnProjectileHit_ExtraData( target, location, extraData )
    local damage = {
        victim = target,
        attacker = self:GetCaster(),
        damage = extraData.damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self
    }
    ApplyDamage( damage )
    self:GetCaster():PerformAttack(target, false, false, false, false, false, false, false)

    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_gyrocopter/gyro_rocket_barrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    EmitSoundOn( "Hero_Tinker.Heat-Seeking_Missile.Impact", target )
end

modifier_blackshop_epic_rocket_shot = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,

})
function modifier_blackshop_epic_rocket_shot:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end


function modifier_blackshop_epic_rocket_shot:GetModifierPreAttack_BonusDamage()
    local caster = self:GetCaster()
    local ability = self:GetCaster():FindAbilityByName("blackshop_legendary_boom_buff")
    if ability then
        return 200 * caster:FindModifierByName("modifier_blackshop_legendary_boom_buff"):GetStackCount()
    end
end


modifier_blackshop_epic_rocket_shot_autocast = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
})

function modifier_blackshop_epic_rocket_shot_autocast:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end


function modifier_blackshop_epic_rocket_shot_autocast:OnCreated()
    if IsServer() then
        local caster = self:GetCaster()
        self:StartIntervalThink(0.1)
    end
end

function modifier_blackshop_epic_rocket_shot_autocast:OnAttackLanded()
    local caster = self:GetCaster()
    local ability = caster:FindAbilityByName("blackshop_epic_rocket_shot")
    if RollPercentage(15 * caster:FindModifierByName("modifier_blackshop_legendary_boom_buff"):GetStackCount()) then
        if  caster:IsAlive() and not caster:IsStunned() and not caster:IsMuted() and not caster:IsHexed()  then
            ability:OnSpellStart()
        end
    end
end