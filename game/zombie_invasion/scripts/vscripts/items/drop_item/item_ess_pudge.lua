if item_ess_pudge == nil then
	item_ess_pudge = class({})
 
end
LinkLuaModifier("modifier_item_ess_pudge", "items/drop_item/item_ess_pudge", LUA_MODIFIER_MOTION_NONE)



 
-------------------------------------------
function item_ess_pudge:GetIntrinsicModifierName()
    return "modifier_item_ess_pudge"
end

-------------------------------------------
modifier_item_ess_pudge = class({})
function modifier_item_ess_pudge:IsDebuff() return false end
function modifier_item_ess_pudge:IsHidden() return true end
function modifier_item_ess_pudge:IsPermanent() return true end
function modifier_item_ess_pudge:IsPurgable() return false end
function modifier_item_ess_pudge:IsPurgeException() return false end
function modifier_item_ess_pudge:IsStunDebuff() return false end
function modifier_item_ess_pudge:RemoveOnDeath() return true end


function modifier_item_ess_pudge:OnCreated( kv )
	-- references 		self:SetStackCount( count )
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
    
   self.ability = self:GetAbility()
	self.bonus_atr = self:GetAbility():GetSpecialValueFor( "bonus_atr" )  
 
end

function modifier_item_ess_pudge:OnRefresh( kv )
	-- references
	self.bonus_atr = self:GetAbility():GetSpecialValueFor( "bonus_atr" )
 
end
 
 
 


function modifier_item_ess_pudge:OnRemoved()
end

function modifier_item_ess_pudge:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects

function modifier_item_ess_pudge:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
 
 
 
	}
    return decFuns
end

function modifier_item_ess_pudge:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

 

 

 
 
-- Stats
function modifier_item_ess_pudge:GetModifierBonusStats_Intellect() return self.bonus_atr * self.ability:GetCurrentCharges() end
function modifier_item_ess_pudge:GetModifierBonusStats_Agility() return self.bonus_atr * self.ability:GetCurrentCharges() end
function modifier_item_ess_pudge:GetModifierBonusStats_Strength() return self.bonus_atr * self.ability:GetCurrentCharges() end

 
 