 LinkLuaModifier("modifier_grill_passive", "items/item_gril", LUA_MODIFIER_MOTION_NONE)
 if item_gril == nil then
	item_gril = class({})
 
end
 
function item_gril:CastFilterResult()
	--print("Error")
	if IsServer() then
		if not self:GetCaster():HasItemInInventory("item_meat") then
			return UF_FAIL_CUSTOM
		end
 

		return UF_SUCCESS
	end
end			 
	  
function item_gril:GetCustomCastError()
	--print("Error")
	if IsServer() then
		if not self:GetCaster():HasItemInInventory("item_meat") then
			return "#dota_hud_error_gril_not_meat"
		end
 

		return UF_SUCCESS
	end
end		

 function item_gril:GetIntrinsicModifierName()
	return "modifier_grill_passive"
end

function item_gril:GetTexture()
	return "item_grill"
end   

function item_gril:OnSpellStart()
	-- Effects
	  sound_castat = RandomInt(1,3)
	if sound_castat == 1 then 
	    EmitSoundOn( "grill_ing", self:GetCaster() )
	elseif sound_castat == 2 then 
      EmitSoundOn( "grill_ing_2", self:GetCaster() )
	elseif sound_castat == 3 then 
       EmitSoundOn( "grill_ing_3", self:GetCaster() )
	end
	print(sound_castat)
	      self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_VICTORY, 1.00)
end

--------------------------------------------------------------------------------
-- Ability Channeling
-- function sand_king_epicenter_lua:GetChannelTime()

-- end
   
 

function item_gril:OnChannelFinish( bInterrupted )
	-- cancel if fail
 
 
 
	if bInterrupted then 
	if sound_castat == 1 then 
	    		StopSoundOn( "grill_ing", self:GetCaster() )
	elseif sound_castat == 2 then 
      StopSoundOn( "grill_ing_2", self:GetCaster() )
	elseif sound_castat == 3 then 
       StopSoundOn( "grill_ing_3", self:GetCaster() )
	end
        self:GetCaster():RemoveGesture(ACT_DOTA_VICTORY) 
 		return
	end
   self:GetCaster():RemoveGesture(ACT_DOTA_VICTORY) 
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local hItem = nil
	local itemName = self:GetAbilityName()
    local newItem = CreateItem("item_bewstheaks", nil, nil)
		local item1 = nil
   
		 
 	
for k=0,9 do
				local item = hCaster:GetItemInSlot(k)


				if item then
 
					local item_name = item:GetName()
					if item_name == "item_meat" then 
                        hItem = item
                    end
				end
end
 
 
  if hCaster:HasItemInInventory("item_meat") then 
 
         newItem:SetPurchaseTime(0)
         CreateItemOnPositionSync(hCaster:GetAbsOrigin(), newItem)
         newItem:LaunchLoot(false, 150, 0.75, hCaster:GetAbsOrigin() + RandomVector(RandomFloat(50, 350)))

 
 	EmitSoundOn( "grill_end", hCaster )

    	if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
		     hCaster:RemoveItem(hItem)
		     return
	    end

	     hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
  else
	return nil
  end 

 

	-- Effects
  
end

modifier_grill_passive = modifier_grill_passive or class({})

-- Modifier properties

function modifier_grill_passive:IsHidden()		return true end
function modifier_grill_passive:IsPurgable()		return false end
function modifier_grill_passive:RemoveOnDeath()	return false end
function modifier_grill_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

 
function modifier_grill_passive:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	local ability   =   self:GetAbility()
	if IsServer() then
		-- Give buff aura modifier
 
	end

	-- Ability parameters
	if self:GetParent():IsHero() and ability then
		self.bonus_int              =   ability:GetSpecialValueFor("bonus_atribute")
		self.bonus_str              =   ability:GetSpecialValueFor("bonus_atribute")
		self.bonus_agil              =   ability:GetSpecialValueFor("bonus_atribute")
 
 
	end
end

-- Various stat bonuses
function modifier_grill_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
 
 
	}
end

function modifier_grill_passive:GetTexture()
	return "item_grill"
end   

-- Stats
function modifier_grill_passive:GetModifierBonusStats_Intellect() return self.bonus_int end
function modifier_grill_passive:GetModifierBonusStats_Agility() return self.bonus_agil end
function modifier_grill_passive:GetModifierBonusStats_Strength() return self.bonus_str end

 
 