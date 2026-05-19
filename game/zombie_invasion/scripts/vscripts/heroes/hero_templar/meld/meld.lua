LinkLuaModifier( "modifier_meld_damage", "heroes/hero_templar/meld/meld" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_meld_reduction", "heroes/hero_templar/meld/meld" ,LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_anchor_smash_passive_reduction", "heroes/hero_templar/meld/meld" ,LUA_MODIFIER_MOTION_NONE )


Meld = class({})

function Meld:Precache(context)
	PrecacheAbilityResources({
		"particles/econ/items/templar_assassin/templar_assassin_butterfly/templar_assassin_trap_explode_butterfly.vpcf",
		"particles/units/heroes/hero_antimage/antimage_blink_end.vpcf",
		"particles/units/heroes/hero_templar_assassin/templar_assassin_meld.vpcf",
	}, {
	}, context)
end


function Meld:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")

	-- load data
    local max_range = self:GetSpecialValueFor("blink_range")
    local min_blink_range = self:GetSpecialValueFor("min_blink_range")

	-- determine target position
	local direction = (point - origin)
	if direction:Length2D() > max_range then
		direction = direction:Normalized() * max_range
    end
    
	if direction:Length2D() < min_blink_range then
		direction = direction:Normalized() * min_blink_range
	end
	-- teleport
    FindClearSpaceForUnit( caster, origin + direction, true )
    
	local effect_cast_b = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_b, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast_b, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_b )
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_TemplarAssassin.Meld", self:GetCaster() )

	local all = FindUnitsInRadius(caster:GetTeam(), 
    caster:GetOrigin(), 
    nil, 
    radius,
    DOTA_UNIT_TARGET_TEAM_ENEMY, 
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
    DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_ANY_ORDER, 
    false)

    caster:AddNewModifier(caster, self, "modifier_meld_damage", {})

    for _, unit in ipairs(all) do
        unit:AddNewModifier(caster, self, "modifier_meld_reduction", {duration=duration})

        caster:PerformAttack(unit, false, true, true, false, false, false, true)
    end

   
	
	local fx = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_butterfly/templar_assassin_trap_explode_butterfly.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(fx, 0, caster:GetAbsOrigin())
	
end


modifier_meld_damage = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
            MODIFIER_PROPERTY_SUPPRESS_CLEAVE
        }
    end,
})


--------------------------------------------------------------------------------


modifier_meld_reduction = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsPurgeException        = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
        }
    end,
})

function modifier_meld_reduction:OnCreated()
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_meld_reduction:OnRefresh()
    self:OnCreated()
end

function modifier_meld_reduction:GetModifierPreAttack_BonusDamage() return self.damage end
function modifier_meld_reduction:GetSuppressCleave() return 1 end


modifier_meld_reduction = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsPurgeException        = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_meld_reduction:OnCreated()
    self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction")

    if IsServer() then
        self.fx = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_meld.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(self.fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        self:AddParticle(self.fx, false, false, -1, false, false)
    end
end

function modifier_meld_reduction:OnRefresh()
    self:OnCreated()
end

function modifier_meld_reduction:GetModifierPhysicalArmorBonus() return self.armor_reduction end


