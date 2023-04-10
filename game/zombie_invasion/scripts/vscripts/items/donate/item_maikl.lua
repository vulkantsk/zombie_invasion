LinkLuaModifier("modifier_item_maikl","items/donate/item_maikl.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_maikl_empty","items/donate/item_maikl.lua", LUA_MODIFIER_MOTION_NONE)

 if item_maikl == nil then
	item_maikl = class({})
 
end
 
 
 
 function item_maikl:GetIntrinsicModifierName()
	return "modifier_item_maikl_empty"
end
 
  

 modifier_item_maikl_empty = class({
    IsHidden        = function(self) return true end,
    IsPurgable      = function(self) return false end,
    IsDebuff        = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
        } end,
})

function modifier_item_maikl_empty:OnCreated()
 
    local modif = self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_item_maikl", {})  

end

modifier_item_maikl = class({
	IsHidden 		= function(self) return false end,
	IsPurgable 		= function(self) return false end,
	IsDebuff 		= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
            MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
        } end,
})
 

function modifier_item_maikl:OnCreated()
    self.chance = self:GetAbility():GetSpecialValueFor("chance")     
    self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")     
end

function modifier_item_maikl:GetModifierBonusStats_Agility()
    return self.bonus_agility * self:GetStackCount()
end

  
function modifier_item_maikl:GetModifierProcAttack_Feedback( params )
 
        local target = params.target

        if target:IsIllusion() or target:IsBuilding() then
            return
        end


        if RollPseudoRandomPercentage(self.chance, 1, self:GetCaster()) then 
            self:IncrementStackCount()       
        end 

end

function modifier_item_maikl:GetTexture( )
    return "slark_essence_shift"
end