LinkLuaModifier("modifier_blackshop_legendary_prism_of_chaos", "items/blackshop_items/blackshop_legendary/blackshop_prism_of_chaos.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blackshop_legendary_prism_of_chaos_cd", "items/blackshop_items/blackshop_legendary/blackshop_prism_of_chaos.lua", LUA_MODIFIER_MOTION_NONE)
modifier_blackshop_legendary_prism_of_chaos = class({})

function modifier_blackshop_legendary_prism_of_chaos:IsHidden() return false end
function modifier_blackshop_legendary_prism_of_chaos:IsDebuff() return false end
function modifier_blackshop_legendary_prism_of_chaos:IsPurgable() return false end
function modifier_blackshop_legendary_prism_of_chaos:RemoveOnDeath() return false end

function modifier_blackshop_legendary_prism_of_chaos:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }
end

function modifier_blackshop_legendary_prism_of_chaos:OnCreated()
    self.spell_counter = 0
    self.can_trigger = true
    self.next_trigger_time = 0
    
    if IsServer() then
        self:StartIntervalThink(0.1)
    end
end

function modifier_blackshop_legendary_prism_of_chaos:OnIntervalThink()
    if not self.can_trigger then
        if GameRules:GetGameTime() >= self.next_trigger_time then
            self.can_trigger = true
        end
    end
end

-- Обновляем OnAbilityExecuted
function modifier_blackshop_legendary_prism_of_chaos:OnAbilityExecuted(keys)
    if not IsServer() then return end
    
    -- Проверяем, что использованная способность не является предметом
    if keys.unit == self:GetParent() and self.can_trigger and not keys.ability:IsItem() then
        self.spell_counter = self.spell_counter + 1
        local cooldown_reduction = self:GetParent():GetCooldownReduction()
        local base_duration = 12
        local reduced_duration = base_duration * (1 - cooldown_reduction / 100)
        if self.spell_counter >= 3 then
            self:CastChaosWave()
            self.spell_counter = 0
            self.can_trigger = false
            self.next_trigger_time = GameRules:GetGameTime() + 12
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_blackshop_legendary_prism_of_chaos_cd", {duration = reduced_duration})
        end
    end
end

function modifier_blackshop_legendary_prism_of_chaos:CastChaosWave()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    local radius = 400
    local base_damage = 75
    local int_multiplier = 0.4
    
    -- Рассчитываем урон
    local int_bonus = parent:GetIntellect(false) * int_multiplier
    local total_damage = base_damage + 125 * self:GetStackCount() + int_bonus
    
    -- Находим врагов в радиусе
    local enemies = FindUnitsInRadius(
        parent:GetTeamNumber(),
        parent:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    
    -- Наносим урон
    for _, enemy in pairs(enemies) do
        ApplyDamage({
            victim = enemy,
            attacker = parent,
            damage = total_damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = ability
        })
    end
    
    -- Визуальный и звуковой эффект
    self:PlayEffects(radius)
end

function modifier_blackshop_legendary_prism_of_chaos:PlayEffects(radius)
    local parent = self:GetParent()
    local particle_name = "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf"
    
    -- Создаём эффект волны
    local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, parent)
    ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
    ParticleManager:SetParticleControl(particle, 2, Vector(64, 64, 255)) -- синий цвет для магического урона
    ParticleManager:ReleaseParticleIndex(particle)
    

    
    EmitSoundOn("Hero_Invoker.EMP.Discharge", parent)
end

item_blackshop_legendary_prism_of_chaos = class({})

function item_blackshop_legendary_prism_of_chaos:OnSpellStart()
    local caster = self:GetCaster()
    local hItem = self
    local m = caster:FindModifierByName("modifier_blackshop_legendary_prism_of_chaos") 
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        caster:AddNewModifier(caster, self, "modifier_blackshop_legendary_prism_of_chaos", {}):SetStackCount(self:GetCurrentCharges())
    end

    caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        UTIL_Remove(hItem)
        return
    end
    hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end

modifier_blackshop_legendary_prism_of_chaos_cd = class({})
function modifier_blackshop_legendary_prism_of_chaos_cd:IsHidden() return false end
function modifier_blackshop_legendary_prism_of_chaos_cd:IsDebuff() return true end
function modifier_blackshop_legendary_prism_of_chaos_cd:IsPurgable() return false end
function modifier_blackshop_legendary_prism_of_chaos_cd:RemoveOnDeath() return false end

function modifier_blackshop_legendary_prism_of_chaos_cd:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        local main_modifier = parent:FindModifierByName("modifier_blackshop_legendary_prism_of_chaos")
        if main_modifier then
            main_modifier.can_trigger = true
        end
    end
end

