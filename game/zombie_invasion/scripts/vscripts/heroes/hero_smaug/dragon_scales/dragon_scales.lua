LinkLuaModifier( "modifier_dragon_scales", "heroes/hero_smaug/dragon_scales/dragon_scales", LUA_MODIFIER_MOTION_NONE )

dragon_scales = class({})

function dragon_scales:Precache(context)
	PrecacheAbilityResources({
		"particles/econ/items/medusa/medusa_daughters/medusa_daughters_mana_shield.vpcf",
	}, {
	}, context)
end


function dragon_scales:OnSpellStart() 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_dragon_scales", { duration =  self:GetSpecialValueFor("duration")})
    
end


modifier_dragon_scales = class({
        IsHidden                 = function(self) return false end,
        IsPurgable                 = function(self) return false end,
        IsDebuff                 = function(self) return true end,
        IsBuff                  = function(self) return true end,
        RemoveOnDeath             = function(self) return false end,
        DeclareFunctions        = function(self)
        return {
            MODIFIER_EVENT_ON_TAKEDAMAGE,
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        }
        end,
        CheckState      = function(self) return 
            {
                [MODIFIER_STATE_STUNNED] = true,
                [MODIFIER_STATE_MUTED] = true,  
                [MODIFIER_STATE_SILENCED] = true,          
            } end,
    })

function modifier_dragon_scales:OnTakeDamage(k)
    local target = k.unit
    local caster = self:GetParent()
    local original_damage = k.original_damage
    local damage_type = k.damage_type
    if target == caster and not caster:PassivesDisabled() then
        local reflect = self:GetAbility():GetSpecialValueFor("reflect")
        local min_radius = self:GetAbility():GetSpecialValueFor("min_radius")
        local max_radius = self:GetAbility():GetSpecialValueFor("max_radius")

        local all = FindUnitsInRadius(target:GetTeam(), 
        caster:GetOrigin(), 
        nil, 
        max_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER, 
        false)

        for _, hero in ipairs(all) do

            local distance = (caster:GetAbsOrigin() - hero:GetAbsOrigin()):Length2D()
            local dif = distance - 300
            local reflect = distance <= min_radius and reflect or reflect - (0.0175 * dif)

            local damage = original_damage / 100 * reflect

            ApplyDamage({
                victim = hero,
                attacker = caster,
                damage = damage,
                damage_type = damage_type,
                damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
                ability = self:GetAbility()
            })
        end
    end
end

function modifier_dragon_scales:GetModifierIncomingDamage_Percentage() return self:GetAbility():GetSpecialValueFor("reflect") end

function modifier_dragon_scales:GetModifierIncomingDamage_Percentage() return self:GetAbility():GetSpecialValueFor("invul") end

function modifier_dragon_scales:GetEffectName()
    return "particles/econ/items/medusa/medusa_daughters/medusa_daughters_mana_shield.vpcf"
end
function modifier_dragon_scales:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end