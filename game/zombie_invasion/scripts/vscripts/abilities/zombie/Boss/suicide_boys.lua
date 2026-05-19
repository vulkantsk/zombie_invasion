 LinkLuaModifier("modifier_tiny_toss_lua", "abilities/zombie/Boss/suicide_boys", LUA_MODIFIER_MOTION_NONE)
suicide_boys = class({})

function suicide_boys:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_techies/techies_suicide.vpcf",
		"particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf",
	}, {
		"balah_babar",
	}, context)
end

 
LinkLuaModifier( "modifier_generic_arc_lua", "heroes/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function suicide_boys:OnSpellStart()
 
   	if IsServer() then
 	
	Timers:CreateTimer(0,function()
   self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tiny_toss_lua", {duration = 5.0})
 
 
 
	end)

	Timers:CreateTimer(2.5,function()
		local radius = self:GetSpecialValueFor("radius")
		local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false)
 
		for _, enemy in pairs(units) do
 
			local damage = {
				victim = enemy,
				attacker = self:GetCaster(),
				damage = 1000000,
				damage_type = DAMAGE_TYPE_PURE,
				ability = self

			}
 
    						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_suicide.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
						ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
						ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius") ) )
						ParticleManager:ReleaseParticleIndex( nFXIndex )


	 		ApplyDamage( damage )
		end
			end)
	end

end

--------------------------------------------------------------------------------
 

--------------------------------------------------------------------------------
-- Helper
 

--------------------------------------------------------------------------------
 

modifier_tiny_toss_lua = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_tiny_toss_lua:IsHidden()
	return true
end

function modifier_tiny_toss_lua:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_tiny_toss_lua:IsStunDebuff()
	return true
end

function modifier_tiny_toss_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tiny_toss_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "toss_damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if not IsServer() then return end
	local duration = 5.0
 
	local height = 2500

	-- add arc modifier for vertical only
	self.arc = self.parent:AddNewModifier(
		self.caster, -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			duration = duration,
			distance = 0,
			height = height,
			-- fix_end = true,
			fix_duration = false,
			isStun = true,
			activity = ACT_DOTA_FLAIL,
		} -- kv
	)
 
	-- emit sound
	local sound_cast = "balah_babar"
 
	EmitSoundOn( sound_cast, self.caster )
 
end

 
--------------------------------------------------------------------------------
-- Status Effects
function modifier_tiny_toss_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

 
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_tiny_toss_lua:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end

function modifier_tiny_toss_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end