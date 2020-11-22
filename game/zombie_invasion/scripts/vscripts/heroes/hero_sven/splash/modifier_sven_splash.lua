modifier_sven_splash = class({})

--------------------------------------------------------------------------------

function modifier_sven_splash:IsHidden()
	return true
end

--------------------------------------------------------------------------------

 
--------------------------------------------------------------------------------

 

--------------------------------------------------------------------------------

function modifier_sven_splash:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_sven_splash:OnAttackLanded(keys)
	local item = self:GetAbility()
	local parent = self:GetParent()
	if item then
		if (keys.attacker == parent) and (parent:IsRealHero() or parent:IsClone()) then
			if item:IsCooldownReady() then
				parent:AddNewModifier(parent, item, "modifier_sven_splash_2", {})
				item:UseResources(false,false,true)			
			end
		end
	end
end
--------------------------------------------------------------------------------
 
modifier_sven_splash_2 = class({})
 
function modifier_sven_splash_2:IsHidden() return true end
 
-------------------------------------------
function modifier_sven_splash_2:OnCreated( kv )
	local item = self:GetAbility()
	self.parent = self:GetParent()
		self.great_cleave_damage = self:GetAbility():GetSpecialValueFor( "great_cleave_damage" )
	self.great_cleave_radius = self:GetAbility():GetSpecialValueFor( "great_cleave_radius" )
	if item then
			if IsServer() then
		if self.parent == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = self.parent:GetAttackTarget()
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local cleaveDamage = ( self.great_cleave_damage * self.parent:GetBaseDamageMax() ) / 100.0
				DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, self.great_cleave_radius, 360, 700, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_crit.vpcf" )
			end
		end
	end
	
	 
 
		local max_hits = item:GetSpecialValueFor("max_hits")
		self:SetStackCount(max_hits)
 
	end
end

 

--------------------------------------------------------------------------------

function modifier_sven_splash_2:OnRefresh( kv )
	self.great_cleave_damage = self:GetAbility():GetSpecialValueFor( "great_cleave_damage" )
	self.great_cleave_radius = self:GetAbility():GetSpecialValueFor( "great_cleave_radius" )
end


 


function modifier_sven_splash_2:DeclareFunctions()
    local decFuns =
    {
 
		MODIFIER_EVENT_ON_ATTACK,
    }
    return decFuns
end

function modifier_sven_splash_2:OnAttack(keys)
	if self.parent == keys.attacker then
		
		-- If the target is a deflector, do nothing
	
		if self:GetStackCount() == 1 then
			self:Destroy()
			return nil
		end

		self:DecrementStackCount()
	end
end

 
------------
