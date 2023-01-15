
 
LinkLuaModifier( "modifier_item_arrow_fire", "items/campfire/item_arrow.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_campfire_quest", "items/campfire/item_arrow.lua", LUA_MODIFIER_MOTION_NONE )
 

 
modifier_item_arrow_fire = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})

function modifier_item_arrow_fire:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		self.value_need = 1/ability:GetSpecialValueFor("str_mult")
		self.crit_chance = ability:GetSpecialValueFor("crit_chance")
		self:StartIntervalThink(1)
	end
end

 

function modifier_item_arrow_fire:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local dps =  ability:GetSpecialValueFor("dps")

	DealDamage(caster, parent, dps, DAMAGE_TYPE_MAGICAL, nil, ability)
end

function modifier_item_arrow_fire:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end



campfire_quest = class({})

function campfire_quest:GetIntrinsicModifierName()
	return "modifier_campfire_quest"
end

modifier_campfire_quest = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})

function modifier_campfire_quest:GetEffectName()
	return "particles/vr_env/vr_camp_fire.vpcf"
--	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_campfire_quest:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_campfire_quest:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	 
	local units = FindUnitsInRadius(caster:GetTeam(), 
									caster:GetAbsOrigin(), 
									nil, 
									radius, 
									DOTA_UNIT_TARGET_TEAM_BOTH, 
									DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
--									DOTA_UNIT_TARGET_FLAG_INVULNERABLE +  
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
									FIND_ANY_ORDER, false)
	
	for i=1,#units do
		local unit = units[i]
		unit:AddNewModifier(caster, ability, "modifier_item_arrow_fire", {duration = duration})
 
 
		local testo = nil
		local trash = nil
		local tvorog = nil
		local pirog = nil
		local mag_heart = nil
		local dps_heart = nil
		local tank_heart = nil
		local item8 = nil

 
 
			for k=0,9 do
 
 
				local item_1 = unit:GetItemInSlot(k)
				local item_2 = unit:GetItemInSlot(k)
				local item_3 = unit:GetItemInSlot(k)
				local item_4 = unit:GetItemInSlot(k)

				local item_5 = unit:GetItemInSlot(k)
				local item_6 = unit:GetItemInSlot(k)
				local item_7 = unit:GetItemInSlot(k)	
				local item_8 = unit:GetItemInSlot(k)								
                if item_1 then 
				local item_name = item_1:GetName()
					if item_name == "item_testo" then 
                        testo = item_1
 
                    end
			end

				if item_2 then
 
					local item_name = item_2:GetName()
					if item_name == "item_trash" then 
                        trash = item_2
 
                    end
				end

                if item_3 then 
					local item_name = item_3:GetName()
					if item_name == "item_tvorog" then 
                        tvorog = item_3
 
                    end
				end


                if item_4 then 
					local item_name = item_4:GetName()
					if item_name == "item_pirog" then 
                            pirog = item_4
                         end
		      end

                if item_5 then 
					local item_name = item_5:GetName()
					if item_name == "item_magic_heart" then 
                            mag_heart = item_5
                         end
		      end

                if item_6 then 
					local item_name = item_6:GetName()
					if item_name == "item_undying_heart" then 
                            tank_heart = item_6
                         end
		      end  

                if item_7 then 
					local item_name = item_7:GetName()
					if item_name == "item_dps_heart" then 
                            dps_heart = item_7
                         end
		      end		      		      
			end	
	
	     if unit:HasItemInInventory("item_trash" ) and unit:HasItemInInventory("item_testo" ) and unit:HasItemInInventory("item_tvorog" ) then 
  
    local newItem = CreateItem("item_pirog", nil, nil)  

         newItem:SetPurchaseTime(0)
         CreateItemOnPositionSync(self:GetCaster():GetAbsOrigin(), newItem)
         newItem:LaunchLoot(false, 300, 0.75, self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(25, 120)))

         unit:RemoveItem(testo)
        unit:RemoveItem(trash) 
         unit:RemoveItem(tvorog)
 
        end
         
         if unit:HasItemInInventory("item_pirog" ) and unit:HasItemInInventory("item_undying_heart" ) then 

    local newItem = CreateItem("item_pirog_tank", nil, nil) 

         newItem:SetPurchaseTime(0)
         CreateItemOnPositionSync(self:GetCaster():GetAbsOrigin(), newItem)
         newItem:LaunchLoot(false, 300, 0.75, self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(25, 120)))

               unit:RemoveItem(pirog)
               unit:RemoveItem(tank_heart)   

         end
  
         if unit:HasItemInInventory("item_pirog" ) and unit:HasItemInInventory("item_magic_heart" ) then 
         	
    local newItem = CreateItem("item_pirog_magic", nil, nil) 

         newItem:SetPurchaseTime(0)
         CreateItemOnPositionSync(self:GetCaster():GetAbsOrigin(), newItem)
         newItem:LaunchLoot(false, 300, 0.75, self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(25, 120)))

               unit:RemoveItem(pirog)
               unit:RemoveItem(mag_heart) 

         end

         if unit:HasItemInInventory("item_pirog" ) and unit:HasItemInInventory("item_dps_heart" ) then 
         	
    local newItem = CreateItem("item_pirog_dps", nil, nil) 

         newItem:SetPurchaseTime(0)
         CreateItemOnPositionSync(self:GetCaster():GetAbsOrigin(), newItem)
         newItem:LaunchLoot(false, 300, 0.75, self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(25, 120)))

               unit:RemoveItem(pirog)
               unit:RemoveItem(dps_heart) 

         end

	end	
end



