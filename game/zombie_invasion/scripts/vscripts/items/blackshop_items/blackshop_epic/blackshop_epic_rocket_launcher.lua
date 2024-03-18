LinkLuaModifier( "modifier_blackshop_epic_rocket_launcher", "items/blackshop_items/blackshop_epic/blackshop_epic_rocket_launcher", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blackshop_epic_rocket_launcher_autocast", "items/blackshop_items/blackshop_epic/blackshop_epic_rocket_launcher", LUA_MODIFIER_MOTION_NONE )
item_blackshop_epic_rocket_launcher = class({})
function item_blackshop_epic_rocket_launcher:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_epic_rocket_launcher")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddAbility("blackshop_epic_rocket_launcher"):SetLevel(1)
        self.caster:AddNewModifier( self.caster, nil, "modifier_blackshop_epic_rocket_launcher_autocast", {} )
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_epic_rocket_launcher", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        UTIL_Remove(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end


blackshop_epic_rocket_launcher = class({})

function blackshop_epic_rocket_launcher:OnSpellStart()
    local caster = self:GetCaster()
    local damage = self:GetSpecialValueFor("damage")
    local radius = self:GetSpecialValueFor("radius")
    local targets = self:GetSpecialValueFor("targets") * caster:FindModifierByName("modifier_blackshop_epic_rocket_launcher"):GetStackCount() * 0.5 + 0.5
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
        EffectName = "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
        iMoveSpeed = self:GetSpecialValueFor("speed"),
        bDodgeable = true,
        ExtraData = {
            damage = damage * caster:FindModifierByName("modifier_blackshop_epic_rocket_launcher"):GetStackCount(),
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

        local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_tinker/tinker_missile_dud.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl( effect_cast, 0, point )
        ParticleManager:SetParticleControlForward( effect_cast, 0, self:GetCaster():GetForwardVector() )
        ParticleManager:ReleaseParticleIndex( effect_cast )
        EmitSoundOn( "Hero_Tinker.Heat-Seeking_Missile", caster )
        
    end
end

function blackshop_epic_rocket_launcher:OnRefresh()
    self:OnCreated()
end


function blackshop_epic_rocket_launcher:OnProjectileHit_ExtraData( target, location, extraData )
    local damage = {
        victim = target,
        attacker = self:GetCaster(),
        damage = extraData.damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self
    }
    ApplyDamage( damage )
    self:GetCaster():PerformAttack(target, false, true, true, false, false, false, true)
    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    EmitSoundOn( "Hero_Tinker.Heat-Seeking_Missile.Impact", target )
end

modifier_blackshop_epic_rocket_launcher = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,

})

function modifier_blackshop_epic_rocket_launcher:OnCreated()
    self:StartIntervalThink(0.2)
end

function modifier_blackshop_epic_rocket_launcher:OnIntervalThink()
    if self:GetStackCount() == 15 then
        self:SetStackCount(14)
    end
end

modifier_blackshop_epic_rocket_launcher_autocast = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
})

function modifier_blackshop_epic_rocket_launcher_autocast:OnCreated()
    if IsServer() then
        local caster = self:GetCaster()
        self:StartIntervalThink(0.2)
    end
end

function modifier_blackshop_epic_rocket_launcher_autocast:OnIntervalThink()
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability2 = self:GetCaster():FindAbilityByName("blackshop_legendary_boom_buff")
    local ability = caster:FindAbilityByName("blackshop_epic_rocket_launcher")
    if ability:IsCooldownReady() and caster:IsAlive() and not caster:IsStunned() and not caster:IsMuted() and not caster:IsHexed()  then
        ability:OnSpellStart()
        if ability2 then
            Timers:CreateTimer(0.4,function() ability:OnSpellStart() end)
        end
        ability:StartCooldown(14 - caster:FindModifierByName("modifier_blackshop_epic_rocket_launcher"):GetStackCount() * 0.5)
    end
end