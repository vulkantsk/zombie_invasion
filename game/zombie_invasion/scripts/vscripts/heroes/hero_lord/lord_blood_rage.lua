LinkLuaModifier("modifier_lord_blood_rage", "heroes/hero_lord/lord_blood_rage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_blood_rage_active", "heroes/hero_lord/lord_blood_rage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_true_lord", "heroes/hero_lord/lord_true_lord", LUA_MODIFIER_MOTION_NONE)


lord_blood_rage = class({})

function lord_blood_rage:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_lord_blood_rage_active",{duration = self:GetSpecialValueFor("duration")})
	EmitSoundOn( "blood_rage", self:GetCaster() )

end

function lord_blood_rage:GetIntrinsicModifierName()
	return "modifier_lord_blood_rage"
end

modifier_lord_blood_rage = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
        	MODIFIER_EVENT_ON_DEATH,
        } end,
})

function modifier_lord_blood_rage:OnDeath(data)
        local parent = self:GetParent()
        local killer = data.attacker
        local killed_unit = data.unit
        local max_charge 
        if parent:HasModifier("modifier_lord_true_lord") or parent:HasModifier("modifier_lord_true_vampire_lord") then 
        	if parent:HasModifier("modifier_lord_true_lord") then 
        	local modif = parent:FindModifierByName("modifier_lord_true_lord")
        	max_charge =  self:GetAbility():GetSpecialValueFor("max_blood") + modif:GetAbility():GetSpecialValueFor("max_blood")
      	  else
        	local modif = parent:FindModifierByName("modifier_lord_true_vampire_lord")
        	max_charge =  self:GetAbility():GetSpecialValueFor("max_blood") + modif:GetAbility():GetSpecialValueFor("max_blood")
        	end
        else 
        	max_charge = self:GetAbility():GetSpecialValueFor("max_blood")
        end
         local charges
        if parent:HasModifier("modifier_lord_blood_rage_active") then
        	charges = (self:GetAbility():GetSpecialValueFor("blood_per_kill")*2) + self:GetStackCount()
        else 
        	charges = self:GetAbility():GetSpecialValueFor("blood_per_kill") + self:GetStackCount()
        end
         
        if killer == parent then
            self:SetStackCount(math.min(charges,max_charge))

            if self:GetStackCount() >= 100 and parent:HasAbility("lord_evolution") then 
            	local ability = parent:FindAbilityByName("lord_evolution")


            	if ability:GetLevel() == 0 then 
            		ability:SetLevel(1)
            		self:SetStackCount(0)
            	end
            end
        end
end

modifier_lord_blood_rage_active = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})
 
function modifier_lord_blood_rage_active:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.damage_percent = self:GetAbility():GetSpecialValueFor("damage_percent")
	self:OnIntervalThink()
	self:StartIntervalThink(self.interval)

	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_aoe.vpcf"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
 

	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, 0 ) )
 
end

function modifier_lord_blood_rage_active:OnDestroy()
	ParticleManager:DestroyParticle( self.effect_cast, false )
end

function modifier_lord_blood_rage_active:OnIntervalThink()
	local units = FindUnitsInRadius(
			self:GetParent():GetTeam(),
			self:GetParent():GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false
		)
 		for _, unit in pairs( units ) do
 		local damage = (self.damage + ((self.damage_percent/100) * unit:GetHealth()))*self.interval

        ApplyDamage( { victim = unit, attacker = self:GetParent(), damage = damage,
                        damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()} )
		end
end