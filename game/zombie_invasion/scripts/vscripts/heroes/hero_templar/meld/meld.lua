LinkLuaModifier( "modifier_meld_damage_deal", "heroes/hero_templar/meld/meld" ,LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_anchor_smash_passive_reduction", "heroes/hero_templar/meld/meld" ,LUA_MODIFIER_MOTION_NONE )


Meld = class({})

function Meld:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()

	-- load data
	local max_range = self:GetSpecialValueFor("meld_damage_deal")
    local min_blink_range = self:GetSpecialValueFor("radius")

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


	AddNewModifier(self:GetCaster(), self:GetModifier(), 'modifier_meld_damage_deal', {
        duration = self:GetAbility():GetSpecialValueFor("duration"),
        })
	end

	if  self:GetCaster():HasModifier("modifier_meld_damage_deal") then

		local enemies = FindUnitsInRadius(
        self:GetCaster():GetTeamNumber(), -- int, your team number
        self:GetCaster():GetOrigin(), -- point, center point
        nil, -- handle, cacheUnit. (not known)
        self.radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
        self:GetAbility():GetAbilityTargetFlags(), -- int, flag filter
        0, -- int, order filter
        false -- bool, can grow cache
        )
        for _,enemy in pairs(enemies) do
        ApplyDamage( {
        victim = enemy,
        attacker = self:GetParent(),
        damage = self.meld_damage_deal,
        damage_type = self:GetAbilityDamageType(),
        ability = self, --Optional.
        })

        local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
        ParticleManager:SetParticleControl(fx, 0, self:GetCaster():GetAbsOrigin())

            EmitSoundOn("Hero_TemplarAssassin.PsionicTrap", self:GetCaster())
 
	end


end
modifier_meld_damage_deal = class({})
function modifier_templar_assassin_psi_blades_custom_attack_cd:IsHidden() return true end
function modifier_templar_assassin_psi_blades_custom_attack_cd:IsPurgable() return false end
function modifier_templar_assassin_psi_blades_custom_attack_cd:RemoveOnDeath() return true end
function modifier_templar_assassin_psi_blades_custom_attack_cd:IsDebuff() return false end
