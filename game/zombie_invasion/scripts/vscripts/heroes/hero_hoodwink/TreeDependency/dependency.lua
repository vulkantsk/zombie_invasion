LinkLuaModifier( "modifier_tree_dependency", "heroes/hero_hoodwink/TreeDependency/modifier_tree_dependency", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tree_dependency_find", "heroes/hero_hoodwink/TreeDependency/dependency", LUA_MODIFIER_MOTION_NONE ) 

tree_dependency = {}

function tree_dependency:GetIntrinsicModifierName()
    return "modifier_tree_dependency_find"
end

modifier_tree_dependency_find = {}

--------------------------------------------------------------------------------
-- Classifications
 

 
 
function modifier_tree_dependency_find:IsHidden()
	return true
end


 

--------------------------------------------------------------------------------
-- Initializations
function modifier_tree_dependency_find:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
 		self:StartIntervalThink( 0.2 )

end

function modifier_tree_dependency_find:OnRefresh( kv )
	-- references
	self:OnCreated()
 
 end
function modifier_tree_dependency_find:OnRemoved()
end

function modifier_tree_dependency_find:OnDestroy()
end

function modifier_tree_dependency_find:OnIntervalThink()
 	local point = self:GetCaster():GetAbsOrigin()
 
 			if GridNav:IsNearbyTree(point, self.radius, true) then
 
		return self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_tree_dependency", {})
	else
		return self:GetCaster():RemoveModifierByName("modifier_tree_dependency")
	end
 
end

--------------------------------------------------------------------------------
-- Modifier Effects
 
 
 