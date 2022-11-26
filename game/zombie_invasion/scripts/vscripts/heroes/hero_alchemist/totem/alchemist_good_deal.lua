alchemist_good_deal = class({})

function alchemist_good_deal:OnAbilityPhaseStart()
		if IsServer() then
	    self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_VICTORY, 1)  
	end
 	return true
end


function alchemist_good_deal:OnAbilityPhaseInterrupted()
		if IsServer() then
	    self:GetCaster():RemoveGesture(ACT_DOTA_VICTORY) 
	end
 	return true
end

function alchemist_good_deal:OnSpellStart()
    local newItem = CreateItem("item_totem_upgrade", nil, nil)
	   self:GetCaster():RemoveGesture(ACT_DOTA_VICTORY) 

          newItem:SetPurchaseTime(0)
         CreateItemOnPositionSync(self:GetCaster():GetAbsOrigin(), newItem)
         newItem:LaunchLoot(false, 300, 0.75, self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(50, 150)))
end
