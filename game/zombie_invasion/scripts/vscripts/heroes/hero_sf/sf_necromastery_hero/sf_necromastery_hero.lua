sf_necromastery_hero = class({})
LinkLuaModifier( "modifier_sf_necromastery_hero", "heroes/hero_sf/sf_necromastery_hero/sf_necromastery_hero", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function sf_necromastery_hero:GetIntrinsicModifierName()
	return "modifier_sf_necromastery_hero"
end


modifier_sf_necromastery_hero = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
        } end,
})
 

--------------------------------------------------------------------------------

function modifier_sf_necromastery_hero:OnCreated( kv )
	-- get references
	self.soul_max = self:GetAbility():GetSpecialValueFor("soul_max")
	self.soul_release = self:GetAbility():GetSpecialValueFor("soul_release")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("soul_damage")

	if IsServer() then
		self:SetStackCount(0)
	end
end

function modifier_sf_necromastery_hero:OnRefresh( kv )
	-- get references
	self.soul_max = self:GetAbility():GetSpecialValueFor("soul_max")
	self.soul_release = self:GetAbility():GetSpecialValueFor("soul_release")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("soul_damage")
end

 
--------------------------------------------------------------------------------
-- soul release
function modifier_sf_necromastery_hero:OnDeath( params )
	if IsServer() then
		self:DeathLogic( params )
		self:KillLogic( params )
	end
end

function modifier_sf_necromastery_hero:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount() * self.soul_damage
end

--------------------------------------------------------------------------------
function modifier_sf_necromastery_hero:DeathLogic( params )
	-- filter
	local unit = params.unit
 
	-- logic
	if unit==self:GetParent() and params.reincarnate==false then
		local after_death = math.floor(self:GetStackCount() * self.soul_release)
		self:SetStackCount(math.max(after_death,1))
	end
end

function modifier_sf_necromastery_hero:KillLogic( params )
	local target = params.unit
	local attacker = params.attacker
	if attacker~=self:GetParent() and target==self:GetParent() and attacker:IsAlive() then return end
		if target:IsIllusion() and target:IsBuilding() then return	end
     		
 
 
	-- logic
	if not self:GetParent():PassivesDisabled() then
		self:AddStack( 1 )
		self:PlayEffects( target )
	end
end

function modifier_sf_necromastery_hero:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value
	if after > self.soul_max then
		after = self.soul_max
	end
	self:SetStackCount( after )
end

function modifier_sf_necromastery_hero:OnTakeDamage( params )
	if  params.attacker == self:GetParent() and not params.unit:IsBuilding() and not params.unit:IsOther() and params.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		-- Spell lifesteal handler
 

			-- Heal and fire the particle			
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, params.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
		 
			params.attacker:Heal(params.damage * self:GetAbility():GetSpecialValueFor("lifesteal_pct") * 0.01, params.attacker)
		end

end




function modifier_sf_necromastery_hero:PlayEffects( target )
	-- Get Resources
	local projectile_name
    if self:GetCaster():HasModifier("modifier_special_effect_sf_skin") then 
         projectile_name = "particles/heroes/azzazel/nevermore_necro_souls.vpcf"
    else 
         projectile_name = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"
    end

	   

	-- CreateProjectile
	local info = {
		Target = self:GetParent(),
		Source = target,
		EffectName = projectile_name,
		iMoveSpeed = 400,
		vSourceLoc= target:GetAbsOrigin(),                -- Optional
		bDodgeable = false,                                -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 5,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end