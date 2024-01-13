 LinkLuaModifier( "modifier_elka_bonus", "modifiers/modifier_elka_bonus", LUA_MODIFIER_MOTION_NONE )
 
--------------------------------------------------------------------------------
modifier_main_elka = {}

--------------------------------------------------------------------------------
-- Classifications
 function modifier_main_elka:IsHidden()
 	return true
 end

 
 

function modifier_main_elka:OnIntervalThink(enemy)

if not IsServer() then return end

	local modifier = self:GetCaster():FindModifierByName("modifier_item_letter")

	if not modifier then
		return
	end

	local bitch = modifier:GetStackCount()
  
     
     		local units = FindUnitsInRadius(
			DOTA_TEAM_GOODGUYS,
			self:GetCaster():GetAbsOrigin(),
			nil,
			10100000,
			DOTA_UNIT_TARGET_TEAM_BOTH,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
			FIND_CLOSEST,
			false
		)
     local	unit = units[1]
 
		 
		          
           
     --print(bitch)
                    
       
 
     local stack =  unit:GetModifierStackCount("modifier_elka_bonus", nil)
 
--print(Christmas_night)


 
     if bitch == 1 then
 
 	for _,unit in pairs(units) do
		-- perform attack
	 
 
		          

			unit:SetModifierStackCount("modifier_elka_bonus", nil, (2))
 
                    
                  end
     elseif bitch == 2 then 
     	 	for _,unit in pairs(units) do
		-- perform attack
	 
 			unit:SetModifierStackCount("modifier_elka_bonus", nil, (3))
	        end
    
     elseif bitch == 3 then 
     	 	for _,unit in pairs(units) do
		-- perform attack
	 
 			unit:SetModifierStackCount("modifier_elka_bonus", nil, (4))
	        end
     elseif bitch == 4 then 
     	 	for _,unit in pairs(units) do
		-- perform attack
	 
 			unit:SetModifierStackCount("modifier_elka_bonus", nil, (5))
	        end
     elseif bitch == 5 then 
     	 	for _,unit in pairs(units) do
		-- perform attack
	 
 			unit:SetModifierStackCount("modifier_elka_bonus", nil, (6))
	        end
     elseif bitch == 6 then 
     	 	for _,unit in pairs(units) do
		-- perform attack
	 
 			unit:SetModifierStackCount("modifier_elka_bonus", nil, (7))
	        end   
	        if Christmas_night == 0 then
	        	   		EmitGlobalSound("ho_ho_ho")
	    	  InvasionMode:CristmasPlus()
	   end
	  end 
  
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_main_elka:OnCreated( kv )
	-- references

		self:StartIntervalThink( 0.2 )

end

function modifier_main_elka:OnRefresh( kv )
	-- references
	self:OnCreated()
 
 end
function modifier_main_elka:OnRemoved()
end

function modifier_main_elka:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_main_elka:DeclareFunctions()
	local funcs = {
 
	}

	return funcs
end

 