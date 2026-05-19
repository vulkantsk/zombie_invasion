pudge_spawn = class({})
 
LinkLuaModifier( "modifier_pudge_spawn", "abilities/zombie/Boss/pudge_spawn", LUA_MODIFIER_MOTION_NONE )
 

--------------------------------------------------------------------------------
-- Passive Modifier
function pudge_spawn:GetIntrinsicModifierName()
	return "modifier_pudge_spawn"
end

 
modifier_pudge_spawn = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_pudge_spawn:IsHidden()
	return true
end

function modifier_pudge_spawn:IsDebuff()
	return true
end

function modifier_pudge_spawn:IsStunDebuff()
	return false
end

function modifier_pudge_spawn:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_pudge_spawn:OnCreated( kv )
	-- references
 	self.limit = self:GetAbility():GetSpecialValueFor( "limit" )
	self:StartIntervalThink( 15.0 )
 
end

 function modifier_pudge_spawn:OnIntervalThink( kv )
	-- references
  
		local units = FindUnitsInRadius(
			DOTA_TEAM_BADGUYS,
			self:GetParent():GetAbsOrigin(),
			nil,
			10000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
			FIND_CLOSEST,
			false
		)

    	local count = 0 

		for _, unit in pairs( units ) do
      
         if unit:GetUnitName() == "npc_wave_boss_mini_pudge" then 
				count = count + 1
				print(count)
		 end
		end

  if count < self.limit then 
	for i=1, 1 do
 
		local unit = CreateUnitByName("npc_wave_boss_mini_pudge", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
 
	end 
  end 
end

 
 


 