 
LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/generic/modifier_generic_knockback_lua" ,LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_sled_penguin_movement_self", "modifiers/winter/modifier_sled_penguin_movement_self", LUA_MODIFIER_MOTION_HORIZONTAL )

 
 
--------------------------------------------------------
------------------------------------------------------------ sa

modifier_survior_passive = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_MODEL_CHANGE,
            MODIFIER_EVENT_ON_DEATH,
            MODIFIER_PROPERTY_MODEL_SCALE,
            MODIFIER_PROPERTY_DISABLE_HEALING,
            MODIFIER_PROPERTY_MOVESPEED_LIMIT,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        } end,
    CheckState      = function(self) return 
        {
 		[MODIFIER_STATE_MUTED] = true,  
  		[MODIFIER_STATE_SILENCED] = true,            
        } end,
})

function modifier_survior_passive:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()

		local parent = self:GetParent()
		local point = parent:GetAbsOrigin()
        
 
		self:StartIntervalThink(0.1)		
	end
end


function modifier_survior_passive:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()

		local parent = self:GetParent()
		local point = parent:GetAbsOrigin()
        
 
	end
end


function modifier_survior_passive:GetModifierMoveSpeedBonus_Constant()
    return 350
end


function modifier_survior_passive:GetModifierMoveSpeed_Limit()
    return 350
end


function modifier_survior_passive:GetModifierMoveSpeed_Limit()
    return 350
end

function modifier_survior_passive:GetModifierModelScale()
    return 80
end

function modifier_survior_passive:GetDisableHealing()
    return 1
end

function modifier_survior_passive:GetModifierModelChange()  
    return "models/events/frostivus/penguin/penguin.vmdl"
end

function modifier_survior_passive:OnDeath( kv )
	local unit = kv.unit
	local parent = self:GetParent()
    local Checkpoint
    local Checkpoint_origin
	if unit == parent then
		if current_day == 1 then 
            Checkpoint = Entities:FindByName(nil, "slide_penguin_1")
             Checkpoint_origin = Checkpoint:GetAbsOrigin()
        elseif current_day == 2 then 
             Checkpoint = Entities:FindByName(nil, "slide_penguin_2")
             Checkpoint_origin = Checkpoint:GetAbsOrigin()
        elseif current_day == 3 then 
             Checkpoint = Entities:FindByName(nil, "slide_penguin_3")
             Checkpoint_origin = Checkpoint:GetAbsOrigin()
        elseif current_day == 4 then 
             Checkpoint = Entities:FindByName(nil, "slide_penguin_4")
             Checkpoint_origin = Checkpoint:GetAbsOrigin()
        end
        
        parent:SetRespawnPosition( Checkpoint_origin + RandomVector( 280 ) )
      
	end


      return 0
end

function modifier_survior_passive:OnIntervalThink()
	local parent = self:GetParent()
	local radius = 60
	
	local units = FindUnitsInRadius(parent:GetTeamNumber(), 
									parent:GetAbsOrigin(),
									nil,
									radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_BASIC, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
									FIND_CLOSEST, 
									false)
	for _,unit in pairs (units) do

		local unit_name = unit:GetUnitName()
        local dist = (parent:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D()

        local distance = 225 - (150 / 150 * dist)
        if distance <= 0 then
            distance = 1
        end


		if not parent:HasModifier("modifier_invulnerable") and parent:IsAlive() then
			local dTable = {
				victim = parent,
				attacker = unit,
				damage = parent:GetMaxHealth() * 0.25,
				damage_type = DAMAGE_TYPE_PURE,
			}
			ApplyDamage(dTable)


			if parent:HasModifier('modifier_sled_penguin_movement_self') then 
				local modifier = parent:FindModifierByName('modifier_sled_penguin_movement_self')
				modifier:CrashAndRecover()
				
				parent:AddNewModifier( parent, self:GetAbility(), "modifier_invulnerable", {duration = 0.85} )
				return
			end
 
			local knockbackProperties =
        	{
				center_x = unit:GetAbsOrigin().x,
				center_y = unit:GetAbsOrigin().y,
				center_z = unit:GetAbsOrigin().z,
				duration = 0.85,  
				knockback_duration = 0.85,
				knockback_distance = distance,
				knockback_height = 175,
				should_stun = true
        	}

	

			parent:AddNewModifier( parent, self:GetAbility(), "modifier_knockback", knockbackProperties )
			parent:AddNewModifier( parent, self:GetAbility(), "modifier_invulnerable", {duration =  0.85} )
			EmitSoundOn( "Hero_Centaur.Stampede.Stun", unit )
			self:PlayEffects( unit, unit:IsCreep() )
		end
	--	parent:ForceKill(false)
    end
end

function modifier_survior_passive:PlayEffects( target, isCreep )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

