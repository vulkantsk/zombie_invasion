axe_culling_blade_lua = class({})
LinkLuaModifier( "modifier_sven_great_cleave_lua", "heroes/hero_axe/rubilka/modifier_sven_great_cleave_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function axe_culling_blade_lua:OnSpellStart()
	-- unit identifier
	
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

 
	-- load data
	local damage_true = self:GetSpecialValueFor("damage_true")
	local damage = ( caster:GetBaseDamageMax() * damage_true ) / 100.0
	local threshold = ( caster:GetBaseDamageMax() * damage_true ) / 100.0
    local great_cleave_damage = self:GetSpecialValueFor("great_cleave_damage")
 	local great_cleave_radius = self:GetSpecialValueFor( "great_cleave_radius" )

 

	-- Check success / not
	local success = false
	if target:GetHealth()<=threshold and target:IsAlive() then success = true end

	-- effects
	self:PlayEffects( target, success )

	if success then
		-- Success:
		-- Damage as HPLoss 
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = threshold,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self, --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, --Optional.
		}
		ApplyDamage(damageTable)
 
 				local cleaveDamage = ( great_cleave_damage * caster:GetBaseDamageMax() ) / 100.0
				DoCleaveAttack( caster, target, self, cleaveDamage, great_cleave_radius, 360, 650, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf" )
 
 
	else
		-- Failed
		-- Magical damage
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)	

 				local cleaveDamage = ( great_cleave_damage * caster:GetBaseDamageMax() ) / 100.0
				DoCleaveAttack( caster, target, self, cleaveDamage, great_cleave_radius, 360, 650,  "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf" )

	end
end

--------------------------------------------------------------------------------
function axe_culling_blade_lua:PlayEffects( target, success )
	-- Get Resources
	local particle_cast = ""
	local sound_cast = ""
	if success then
		particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
		sound_cast = "Hero_Axe.Culling_Blade_Success"
	else
		particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade.vpcf"
		sound_cast = "Hero_Axe.Culling_Blade_Fail"
	end

	-- load data
	local direction = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 3, direction )
	ParticleManager:SetParticleControlForward( effect_cast, 4, direction )
	-- assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_color"))(self,effect_target)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end