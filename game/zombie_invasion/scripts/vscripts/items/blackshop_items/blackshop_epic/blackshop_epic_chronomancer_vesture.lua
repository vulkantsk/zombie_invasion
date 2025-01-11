if item_blackshop_epic_chronomancer_vesture == nil then
    item_blackshop_epic_chronomancer_vesture = class({})
end

LinkLuaModifier("modifier_blackshop_epic_chronomancer_vesture", "items/blackshop_items/blackshop_epic/blackshop_epic_chronomancer_vesture", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blackshop_epic_chronomancer_vesture_active", "items/blackshop_items/blackshop_epic/blackshop_epic_chronomancer_vesture", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Item Definition
--------------------------------------------------------------------------------

function item_blackshop_epic_chronomancer_vesture:GetIntrinsicModifierName()
    return "modifier_blackshop_epic_chronomancer_vesture"
end

function item_blackshop_epic_chronomancer_vesture:OnSpellStart()
    if not IsServer() then return end
    
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    
    -- Создаем иллюзию
    local illusion = CreateUnitByName(
        caster:GetUnitName(),
        caster:GetAbsOrigin(),
        false,
        caster,
        caster:GetOwner(),
        caster:GetTeamNumber()
    )
    
    -- Находим свободное место рядом с героем
    if illusion then
        FindClearSpaceForUnit(illusion, caster:GetAbsOrigin() + RandomVector(100), true)
        
        -- Применяем модификатор
        illusion:AddNewModifier(
            caster,
            self,
            "modifier_blackshop_epic_chronomancer_vesture_active",
            { duration = duration }
        )
        
        -- Копируем уровни способностей
        for i = 0, illusion:GetAbilityCount() - 1 do
            local ability = illusion:GetAbilityByIndex(i)
            if ability then
                local casterAbility = caster:GetAbilityByIndex(i)
                if casterAbility then
                    ability:SetLevel(casterAbility:GetLevel())
                end
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Basic Modifier
--------------------------------------------------------------------------------

modifier_blackshop_epic_chronomancer_vesture = class({})

function modifier_blackshop_epic_chronomancer_vesture:IsHidden() return true end
function modifier_blackshop_epic_chronomancer_vesture:IsPurgable() return false end

function modifier_blackshop_epic_chronomancer_vesture:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }
end

function modifier_blackshop_epic_chronomancer_vesture:GetModifierBonusStats_Strength() return 15 end
function modifier_blackshop_epic_chronomancer_vesture:GetModifierBonusStats_Agility() return 15 end
function modifier_blackshop_epic_chronomancer_vesture:GetModifierBonusStats_Intellect() return 15 end
function modifier_blackshop_epic_chronomancer_vesture:GetModifierManaBonus() return 300 end
function modifier_blackshop_epic_chronomancer_vesture:GetModifierSpellAmplify_Percentage() return 20 end

--------------------------------------------------------------------------------
-- Active Modifier
--------------------------------------------------------------------------------
local MODIFIER_PRIORITY_MONKAGIGA_EXTEME_HYPER_ULTRA_REINFORCED_V9 = 10001

modifier_blackshop_epic_chronomancer_vesture_active = class({})

function modifier_blackshop_epic_chronomancer_vesture_active:IsHidden() return false end
function modifier_blackshop_epic_chronomancer_vesture_active:IsPurgable() return false end
function modifier_blackshop_epic_chronomancer_vesture_active:RemoveOnDeath() return true end

function modifier_blackshop_epic_chronomancer_vesture_active:OnCreated(kv)
    if not IsServer() then return end
    
    self.caster = self:GetCaster()
    local parent = self:GetParent()
    
    -- Настройка иллюзии
    if parent then
        parent:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
        
        -- Эффект
        self.particle = ParticleManager:CreateParticle(
            "particles/units/heroes/hero_arc_warden/arc_warden_tempest_double.vpcf",
            PATTACH_ABSORIGIN_FOLLOW,
            parent
        )
        self:AddParticle(self.particle, false, false, -1, false, false)
        
        self:StartIntervalThink(0.1)
    end
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_tempest_double.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
    ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
    self:AddParticle(particle, false, false, -1, false, false)
    
    -- Добавляем эффект электрических разрядов
    local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_tempest_double_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
    self:AddParticle(particle2, false, false, -1, false, false)
    
    -- Добавляем звуковой эффект создания
    EmitSoundOn("Hero_ArcWarden.TempestDouble.Create", parent)
    
end

function modifier_blackshop_epic_chronomancer_vesture_active:OnIntervalThink()
    if not IsServer() then return end
    
    local parent = self:GetParent()
    if not parent or parent:IsNull() then return end
    
    if not self.caster or self.caster:IsNull() then
        parent:Stop()
        parent:Destroy()
        return
    end
    
    -- Следование за героем
    local direction = self.caster:GetAbsOrigin() - parent:GetAbsOrigin()
    if direction:Length2D() > 250 then
        parent:MoveToPosition(self.caster:GetAbsOrigin())
    end
end

function modifier_blackshop_epic_chronomancer_vesture_active:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }
end

function modifier_blackshop_epic_chronomancer_vesture_active:GetModifierIgnoreCastAngle()
    return 1
end

function modifier_blackshop_epic_chronomancer_vesture_active:GetModifierCastTimePercentage()
    return 100
end

function modifier_blackshop_epic_chronomancer_vesture_active:OnAbilityExecuted(params)
    if not IsServer() then return end
    
    if params.unit == self.caster then
        local ability = params.ability
        if not ability or ability:IsItem() then return end
        
        local parent = self:GetParent()
        local copyAbility = parent:FindAbilityByName(ability:GetAbilityName())
        
        if copyAbility then
            local target = params.target or ability:GetCursorTarget()
            local point = ability:GetCursorPosition()
            local behavior = ability:GetBehaviorInt()

            Timers:CreateTimer(0.1, function()
                if not parent:IsAlive() then return end
                if not behavior then return end
                
                parent:SetForwardVector(self.caster:GetForwardVector())
                
                if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 and target and not target:IsNull() and target:IsAlive() then
                    parent:CastAbilityOnTarget(target, copyAbility, -1)
                elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 then
                    parent:CastAbilityOnPosition(point, copyAbility, -1)
                elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 then
                    parent:CastAbilityNoTarget(copyAbility, -1)
                end
            end)
        end
    end
end

function modifier_blackshop_epic_chronomancer_vesture_active:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true
    }
end


function modifier_blackshop_epic_chronomancer_vesture_active:OnDestroy()
    if not IsServer() then return end
    
    local parent = self:GetParent()
    if not parent or parent:IsNull() then return end

    -- Добавляем эффект уничтожения
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_tempest_double_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
    ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
     
    -- Добавляем звук уничтожения
    EmitSoundOn("Hero_ArcWarden.TempestDouble.Destroy", parent)

    if self.particle then
        ParticleManager:DestroyParticle(self.particle, false)
    end
    UTIL_Remove(parent)
end

function modifier_blackshop_epic_chronomancer_vesture_active:GetModifierSpellAmplify_Percentage()
    if not self.caster then return 0 end
    return self.caster:GetSpellAmplification(false) * 100
end

function modifier_blackshop_epic_chronomancer_vesture_active:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_blackshop_epic_chronomancer_vesture_active:StatusEffectPriority()
	return MODIFIER_PRIORITY_MONKAGIGA_EXTEME_HYPER_ULTRA_REINFORCED_V9
end