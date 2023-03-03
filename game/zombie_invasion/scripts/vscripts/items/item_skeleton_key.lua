LinkLuaModifier("modifier_item_skeleton_key", "items/item_skeleton_key", LUA_MODIFIER_MOTION_NONE)

item_skeleton_key = class({})
 


function item_skeleton_key:CastFilterResultTarget(target)
	--print("Error")
	if IsServer() then
 
		if   target:GetName() ~= "guard" then
			return UF_FAIL_CUSTOM
		end

     

		return UF_SUCCESS
	end
end


function item_skeleton_key:GetCustomCastErrorTarget(target)
	--print("Error")
	if IsServer() then
 
		if target:GetName() ~= "guard" then
			return "#dota_hud_error_key"
		end
 

		return UF_SUCCESS
	end
end

function item_skeleton_key:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
			local player = caster:GetPlayerOwnerID()
			local hero   = PlayerResource:GetSelectedHeroEntity(player)
			local point = target:GetAbsOrigin() 
			local team = caster:GetTeam()
        local point_for_guard = Entities:FindByName(nil, "for_guard_1"):GetAbsOrigin() 
 	local point_for_rotate = Entities:FindByName(nil, "for_guard_2")
	local guard = Entities:FindByName(nil, 'guard')    
	local gate_main = Entities:FindByName(nil, 'gate_main')

	caster:RemoveItem(self)

    if target:GetName() == "guard" then
   	 Timers:CreateTimer(0,function() 
 
          	    EmitSoundOn( "open_gate", target )
 
	      MoveToPoint(guard, point_for_guard) 
	 end)
   	 Timers:CreateTimer(4,function() 	
 
	      					guard:CastPointSkill("intro_rotate_christmas",point_for_rotate:GetAbsOrigin()) 
    			 
	 end)
   	 Timers:CreateTimer(4,function() 	
 
   	  guard:StartGestureWithPlaybackRate(ACT_DOTA_RUN, 1.0)  
   	  
	 end)	 
	 	    
   	 Timers:CreateTimer(5,function() 	 
                               PlayDustParticle(gate_main, 625 )

	      					   gate_main:ForceKill(true)
	      					     gate_main:AddNoDraw()
	      					   guard:ForceKill(true)

	 end)
	 
   end 
end


function PlayDustParticle( chel, radius )
	local vPos = chel:GetOrigin()
	vPos.z = vPos.z + 100

	local nFXIndex = ParticleManager:CreateParticle( "particles/dev/library/base_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, vPos )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

modifier_item_skeleton_key = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
 
})

 
 

 
function MoveToPoint(unit, point)
	Timers:CreateTimer(0.1, function()
		ExecuteOrderFromTable({
			UnitIndex = unit:entindex(),		-- индекс кастера
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,				-- тип приказа
			Position = point,	 	-- положение врага
			Queue = false,						-- ждать очереди ?
		})	
	end)	
end

function CDOTA_BaseNPC:CastPointSkill(skill_name, point)
	local ability = self:FindAbilityByName(skill_name)

	if ability then
		ExecuteOrderFromTable({
		UnitIndex = self:entindex(),		-- индекс кастера
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,				-- тип приказа
		AbilityIndex = ability:entindex(),	-- индекс способности
		Position = point,	 	-- положение врага
		Queue = false,						-- ждать очереди ?
		})		

			
	else
		print("ability "..skill_name.." not found !!!")
	end
	
end
