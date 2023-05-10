imba_kunkka_tidebringer = class({})
LinkLuaModifier("modifier_imba_tidebringer", "heroes/hero_demonslayer/demon_dragonslayer/demon_dragonslayer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidebringer_sword_particle", "heroes/hero_demonslayer/demon_dragonslayer/demon_dragonslayer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidebringer_manual", "heroes/hero_demonslayer/demon_dragonslayer/demon_dragonslayer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidebringer_slow", "heroes/hero_demonslayer/demon_dragonslayer/demon_dragonslayer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidebringer_cleave_hit_target", "heroes/hero_demonslayer/demon_dragonslayer/demon_dragonslayer", LUA_MODIFIER_MOTION_NONE)

function imba_kunkka_tidebringer:GetAbilityTextureName()
    return "kunkka_tidebringer"
end

function imba_kunkka_tidebringer:GetIntrinsicModifierName()
    return "modifier_imba_tidebringer"
end

function imba_kunkka_tidebringer:GetCastRange(location, target)
    return self:GetCaster():Script_GetAttackRange()
end

function imba_kunkka_tidebringer:IsStealable()
    return false
end

function imba_kunkka_tidebringer:OnSpellStart()
    if IsServer() then
        -- Force attack the target
        local caster = self:GetCaster()
        caster:MoveToTargetToAttack(self:GetCursorTarget())
        caster:AddNewModifier(caster, self, "modifier_imba_tidebringer_manual", {})
        -- If manually casted, reset CD, CD getting applied on hit
        self:EndCooldown()
    end
end

function imba_kunkka_tidebringer:OnUpgrade()
    if IsServer() then
        self:GetCaster():RemoveModifierByName("modifier_imba_tidebringer")
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_tidebringer", {})

        -- Toggles the autocast when first leveled
        local caster_tidebringer = self:GetCaster():FindAbilityByName("imba_kunkka_tidebringer")
        if caster_tidebringer and caster_tidebringer:GetLevel() == 1 then
            caster_tidebringer:ToggleAutoCast()
        end
    end
end

function imba_kunkka_tidebringer:GetCooldown( nLevel )
    local cooldown = self.BaseClass.GetCooldown( self, nLevel )
    local caster = self:GetCaster()

    if caster:HasModifier("modifier_imba_ebb_and_flow_tide_wave") or caster:HasModifier("modifier_imba_ebb_and_flow_tsunami") or (caster:HasTalent("special_bonus_imba_kunkka_2") and caster:HasModifier("modifier_imba_ghostship_rum")) then
        cooldown = 0
    end
    return cooldown
end

modifier_imba_tidebringer_sword_particle = class({})

function modifier_imba_tidebringer_sword_particle:IsHidden()
    return true
end

function modifier_imba_tidebringer_sword_particle:RemoveOnDeath()
    return false
end

function modifier_imba_tidebringer_sword_particle:IsPurgable()
    return false
end

function modifier_imba_tidebringer_sword_particle:OnDestroy()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local cooldown = ability:GetCooldown(ability:GetLevel()-1)

        caster:EmitSound("Hero_Kunkka.Tidebringer.Attack")
        ParticleManager:DestroyParticle(caster.tidebringer_weapon_pfx, true)
        ParticleManager:ReleaseParticleIndex(caster.tidebringer_weapon_pfx)
        caster.tidebringer_weapon_pfx = 0
    end
end

function modifier_imba_tidebringer_sword_particle:OnCreated()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        caster.tidebringer_weapon_pfx = caster.tidebringer_weapon_pfx or 0
        if caster.tidebringer_weapon_pfx == 0 then
            EmitSoundOn("Hero_Kunkaa.Tidebringer", caster)
            caster.tidebringer_weapon_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_weapon_tidebringer.vpcf", PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControlEnt(caster.tidebringer_weapon_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_tidebringer", caster:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(caster.tidebringer_weapon_pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_sword", caster:GetAbsOrigin(), true)
        end
    end
end

modifier_imba_tidebringer_manual = class({})

function modifier_imba_tidebringer_manual:IsHidden()
    return false
end

modifier_imba_tidebringer = class({})

function modifier_imba_tidebringer:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
end

function modifier_imba_tidebringer:OnCreated()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    if IsServer() then
        if (not caster:HasModifier("modifier_imba_tidebringer_sword_particle")) and ability:IsCooldownReady() then
            caster:AddNewModifier(caster, ability, "modifier_imba_tidebringer_sword_particle", {})
        end
    end
end

function modifier_imba_tidebringer:OnRefresh()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    if IsServer() then
        if ( not caster:HasModifier("modifier_imba_tidebringer_sword_particle")) and ability:IsCooldownReady() then
            caster:AddNewModifier(caster, ability, "modifier_imba_tidebringer_sword_particle", {})
        end
    end
end

function modifier_imba_tidebringer:OnAttackStart( params )
    if self:GetAbility() then
        local parent = self:GetParent()
        local target = params.target
        if (parent == params.attacker) and (target:GetTeamNumber() ~= parent:GetTeamNumber()) and (target.IsCreep or target.IsHero) then
            if not target:IsBuilding() then
                local ability = self:GetAbility()
                self.sound_triggered = false
                -- Check buffs by Ebb and Flow, and set on Cooldown after cast to give a new buff
                self.tide_index = 0
                if parent:HasModifier("modifier_imba_ebb_and_flow_tsunami")     then self.tide_index = 1 end
                if parent:HasModifier("modifier_imba_ebb_and_flow_tide_low")    then self.tide_index = 2 end
                if parent:HasModifier("modifier_imba_ebb_and_flow_tide_red")    then self.tide_index = 3 end
                if parent:HasModifier("modifier_imba_ebb_and_flow_tide_flood")  then self.tide_index = 4 end
                if parent:HasModifier("modifier_imba_ebb_and_flow_tide_high")   then self.tide_index = 5 end
                if parent:HasModifier("modifier_imba_ebb_and_flow_tide_wave")   then self.tide_index = 6 end

                if ability:IsCooldownReady() and not (parent:PassivesDisabled()) then
                    if ability:GetAutoCastState() or parent:HasModifier("modifier_imba_tidebringer_manual") then
                        self.pass_attack = true
                        self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
                          self.crit_damage = ability:GetSpecialValueFor("crit_damage")
                        if (self.tide_index == 4) or (self.tide_index == 1) then
                            self.bonus_damage = self.bonus_damage + ability:GetSpecialValueFor("tide_flood_damage")
                        end
                    else
                        self.pass_attack = false
                        self.bonus_damage = 0
                        self.crit_damage = 100
                    end
                end
            end
        end
    end
end

function modifier_imba_tidebringer:OnAttackLanded( params )
    local ability = self:GetAbility()
    if self:GetAbility() then
        local parent = self:GetParent()
        local tidebringer_bonus_damage = self.bonus_damage
         local tidebringer_crit_damage = self.crit_damage
        if params.attacker == parent and ( not parent:IsIllusion() ) and self.pass_attack then
            self.pass_attack = false
            self.bonus_damage = 0
            self.crit_damage = 0

            -- If you get break during attack-swing
            if parent:PassivesDisabled() then
                return 0
            end

            local range = self:GetAbility():GetSpecialValueFor("range")
            local radius_start = self:GetAbility():GetSpecialValueFor("radius_start")
            local radius_end = self:GetAbility():GetSpecialValueFor("radius_end")

            parent:RemoveModifierByName("modifier_imba_tidebringer_sword_particle")

            if (self.tide_index == 2) or (self.tide_index == 1) then
                range = range + ability:GetSpecialValueFor("tide_low_range")
            end

            if (self.tide_index == 5) or (self.tide_index == 1) then
                radius_start = radius_start + ability:GetSpecialValueFor("tide_high_radius")
                radius_end = radius_end + ability:GetSpecialValueFor("tide_high_radius")
            end

            -- Torrent animation if Tsunami
            if self.tide_index == 1 then
                self.torrent_radius = radius_end * ( math.sqrt( math.pow((radius_end - radius_start), 2) + math.pow(range, 2)) + radius_start - radius_end) / range
                self.position_center = parent:GetAbsOrigin() + parent:GetForwardVector() * self.torrent_radius

                local torrent_fx_mini = ParticleManager:CreateParticle("particles/hero/kunkka/torrent_splash.vpcf", PATTACH_CUSTOMORIGIN, parent)
                ParticleManager:SetParticleControl(torrent_fx_mini, 0, self.position_center)
                ParticleManager:SetParticleControl(torrent_fx_mini, 1, Vector(self.torrent_radius,0,0))
            end

            local target = params.target
            if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then

                self:TidebringerEffects( target, ability )
                
                -- Calculate bonus damage to be used for cleave
                local cleaveDamage = params.damage * (ability:GetTalentSpecialValueFor("cleave_damage") / 100) + params.crit
                
                local enemies_to_cleave = FindUnitsInCone(self:GetParent():GetTeamNumber(),CalculateDirection(params.target, self:GetParent()),self:GetParent():GetAbsOrigin(), radius_start, radius_end, range, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)

                -- #7 Talent: Tidebringer will always hit enemies with Torrent debuff
                if parent:HasTalent("special_bonus_imba_kunkka_7") then
                    local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
                    local hit_enemy = false

                    for _,enemy in pairs (enemies) do
                        if enemy:HasModifier("modifier_imba_torrent_slow") or enemy:HasModifier("modifier_imba_torrent_slow_tide") or enemy:HasModifier("modifier_imba_sec_torrent_slow") or enemy:HasModifier("modifier_imba_torrent_phase") then
                            hit_enemy = true
                            -- Prevent the enemy from being hit again if it's already hit once by Tidebringer.
                            for _,enemy_hit in pairs (enemies_to_cleave) do
                                if enemy == enemy_hit then
                                    hit_enemy = false
                                end
                            end
                            if hit_enemy then
                                -- Play hit particle
                                local tidebringer_hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
                                ParticleManager:SetParticleControlEnt(tidebringer_hit_fx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
                                ParticleManager:SetParticleControlEnt(tidebringer_hit_fx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
                                ParticleManager:SetParticleControlEnt(tidebringer_hit_fx, 2, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)

                                -- Deal the cleave damage
                                ApplyDamage({attacker = self:GetParent(), victim = enemy, ability = ability, damage = cleaveDamage, crit = crit_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
                            end
                        end
                    end
                end

                -- #7 Talent: If the enemy is the target itself, Tidebringer also hits him, dealing what damage that should be done, true Cleave damage
                if parent:HasTalent("special_bonus_imba_kunkka_7") then
                    if params.target:HasModifier("modifier_imba_torrent_slow") or params.target:HasModifier("modifier_imba_torrent_slow_tide") or params.target:HasModifier("modifier_imba_sec_torrent_slow") or params.target:HasModifier("modifier_imba_torrent_phase") then
                        for _,enemy_to_hit in pairs (enemies_to_cleave) do
                            -- Play hit particle
                            local tidebringer_hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
                            ParticleManager:SetParticleControlEnt(tidebringer_hit_fx, 0, enemy_to_hit, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy_to_hit:GetAbsOrigin(), true)
                            ParticleManager:SetParticleControlEnt(tidebringer_hit_fx, 1, enemy_to_hit, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy_to_hit:GetAbsOrigin(), true)
                            ParticleManager:SetParticleControlEnt(tidebringer_hit_fx, 2, enemy_to_hit, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy_to_hit:GetAbsOrigin(), true)

                            target_cleaved = enemy_to_hit:AddNewModifier(self:GetParent(),ability,"modifier_imba_tidebringer_cleave_hit_target",{duration = 0.01})
                            if target_cleaved then
                                target_cleaved.cleave_damage = cleaveDamage
                                target_cleaved.crit_damage = crit_damage
                            end
                        end
                    else
                        DoCleaveAttack( params.attacker, params.target, ability, cleaveDamage, crit_damage, radius_start, radius_end, range, "particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf" )
                    end
                else
                    DoCleaveAttack( params.attacker, params.target, ability, cleaveDamage, crit_damage, radius_start, radius_end, range, "particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf" )
                end

                if not ((self.tide_index == 6) or (self.tide_index == 1)) then
                    local cooldown = ability:GetCooldown(ability:GetLevel()-1)
                    ability:UseResources(false, false, true)
                    Timers:CreateTimer( cooldown, function()
                            if not parent:HasModifier("modifier_imba_tidebringer_sword_particle") then
                                parent:AddNewModifier(parent, ability, "modifier_imba_tidebringer_sword_particle", {})
                            end
                            --return nil
                        end)
                end
                if parent:HasModifier("modifier_imba_tidebringer_manual") then
                    parent:RemoveModifierByName("modifier_imba_tidebringer_manual")
                end
                if parent:HasAbility("imba_kunkka_ebb_and_flow") then
                    local ability_tide = parent:FindAbilityByName("imba_kunkka_ebb_and_flow")
                    if self.tide_index >= 1 then
                        ability_tide:CastAbility()
                    end
                    cooldown = ability_tide:GetCooldownTimeRemaining() - (self.hitCounter * ability:GetSpecialValueFor("cdr_per_hit"))
                    ability_tide:EndCooldown()
                    ability_tide:StartCooldown(cooldown)
                    self.hitCounter = nil
                end
            end
        end
    end
    return 0
end

function modifier_imba_tidebringer:GetModifierPreAttack_BonusDamage(params)
    self.bonus_damage = self.bonus_damage or 0
    return self.bonus_damage
end

function modifier_imba_tidebringer:GetModifierPreAttack_CriticalStrike(params)
    self.crit_damage = self.crit_damage or 0
    return self.crit_damage
end

function modifier_imba_tidebringer:OnTakeDamage( params )
    if IsServer() then
        if params.attacker == self:GetParent() and ( bit.band( params.damage_flags , DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR) == DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR) and params.inflictor:GetAbilityName() == "imba_kunkka_tidebringer" then
            self:TidebringerEffects( params.unit, params.inflictor )
        end
    end
end

function modifier_imba_tidebringer:TidebringerEffects( target, ability )
    local sound_height = 1000
    self.hitCounter = self.hitCounter or 0
    self.hitCounter = self.hitCounter + 1
    local attacker = self:GetCaster()
    if ( self.tide_index == 1 or self.tide_index == 3 ) and not target:IsMagicImmune() then
        target:AddNewModifier(attacker, ability, "modifier_imba_tidebringer_slow", {duration = ability:GetSpecialValueFor("tide_red_slow_duration") * (1 - target:GetStatusResistance())})
    end

    if self.tide_index == 1 then
        local location = target:GetAbsOrigin()

        local distance_from_center = ( location - self.position_center ):Length2D()

        local knocking_up = ((self.torrent_radius / distance_from_center ) * 50) * ( attacker:GetAverageTrueAttackDamage(attacker) / 300) + 40 + crit_damage
        local knockback =
        {
            should_stun = 1,
            knockback_duration = ability:GetSpecialValueFor("tsunami_stun"),
            duration = ability:GetSpecialValueFor("tsunami_stun"),
            knockback_distance = 0,
            knockback_height = knocking_up,
            center_x = location.x,
            center_y = location.y,
            center_z = location.z
        }

        target:EmitSound("Hero_Kunkka.TidebringerDamage")
        if (knocking_up > sound_height) and not self.sound_triggered then
            EmitSoundOn("Kunkka.ShootingStar", target)
            self.sound_triggered = true
        end

        -- Apply knockback on enemies hit
        target:RemoveModifierByName("modifier_knockback")
        target:AddNewModifier(self:GetParent(), ability, "modifier_knockback", knockback)
    end
end

function modifier_imba_tidebringer:IsHidden()
    return true
end

function modifier_imba_tidebringer:RemoveOnDeath()
    return false
end

function modifier_imba_tidebringer:IsPurgable()
    return false
end

modifier_imba_tidebringer_slow = class({})

function modifier_imba_tidebringer_slow:DeclareFunctions()
    local decFuncs =
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
    return decFuncs
end

function modifier_imba_tidebringer_slow:GetModifierMoveSpeedBonus_Percentage( )
    return ( self:GetAbility():GetSpecialValueFor("tide_red_slow") * (-1) )
end

function modifier_imba_tidebringer_slow:IsDebuff()
    return true
end

function modifier_imba_tidebringer_slow:IsPurgable()
    return true
end

function modifier_imba_tidebringer_slow:IsHidden()
    return false
end

function modifier_imba_tidebringer_slow:RemoveOnDeath()
    return true
end

modifier_imba_tidebringer_cleave_hit_target = class({})

function modifier_imba_tidebringer_cleave_hit_target:IsHidden()
    return true
end

function modifier_imba_tidebringer_cleave_hit_target:IsPurgable()
    return false
end

function modifier_imba_tidebringer_cleave_hit_target:IsDebuff()
    return false
end

function modifier_imba_tidebringer_cleave_hit_target:StatusEffectPriority()
    return 20
end

function modifier_imba_tidebringer_cleave_hit_target:OnDestroy()
    if IsServer() then
        ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self.cleave_damage, crit_damage = self.crit_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
    end
end

function modifier_imba_tidebringer_cleave_hit_target:DeclareFunctions()
    return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end

function modifier_imba_tidebringer_cleave_hit_target:GetModifierIncomingDamage_Percentage()
    return -100
end