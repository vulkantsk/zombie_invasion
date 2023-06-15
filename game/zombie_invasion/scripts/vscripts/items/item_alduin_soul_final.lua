 LinkLuaModifier("modifier_voodo_mask_passive", "items/magic/item_voodo_mask", LUA_MODIFIER_MOTION_NONE)
 LinkLuaModifier("modifier_item_alduin_soul_final_stack", "items/item_alduin_soul_final", LUA_MODIFIER_MOTION_NONE)
 
LinkLuaModifier("modifier_item_alduin_soul_final", "items/item_alduin_soul_final", LUA_MODIFIER_MOTION_NONE)

item_alduin_soul_final = item_alduin_soul_final or class({})

function item_alduin_soul_final:GetIntrinsicModifierName()
	return "modifier_item_alduin_soul_final"
end
 
-- Stats modifier (stackable)
modifier_item_alduin_soul_final = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions        = function(self) return 
    {           
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_DEATH,
    } end,
})
 

function modifier_item_alduin_soul_final:OnCreated()
	self.parent = self:GetParent()
    self.modif_lif = self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_voodo_mask_passive", {})

    self:StartIntervalThink(1)
end

function modifier_item_alduin_soul_final:OnIntervalThink()
    local units = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), self.parent, self:GetAbility():GetSpecialValueFor("radius") ,
    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
    local damage = self:GetParent():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("hp_damage")/100)
    for _,unit in pairs( units ) do
        ApplyDamage ( {
             victim = unit,
         attacker = self:GetParent(),
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL ,
            ability = self:GetAbility(),
        } )   
    end

end 
function modifier_item_alduin_soul_final:OnDestroy()
	self.modif_lif:Destroy()
end 

function modifier_item_alduin_soul_final:OnTakeDamage( keys )
        local parent = self:GetParent()
 
    
    	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then		

    	if keys.damage_type == DAMAGE_TYPE_MAGICAL and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.inflictor then
    		local Target = keys.unit
    		local Attacker = keys.attacker
            local ability = self:GetAbility()
            local trigger_chance = ability:GetSpecialValueFor("trigger_chance")
            local damage_pct = ability:GetSpecialValueFor("damage_pct")
            if RollPercentage(trigger_chance) then
                local damage =  keys.original_damage * (damage_pct/100) 
                local damage_pure = keys.original_damage * (self:GetStackCount()/100)
                local modif = self:GetParent():FindModifierByName("modifier_item_alduin_soul_final_stack") 

                DealDamage(Attacker, Target, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE, ability) 
                DealDamage(Attacker, Target, damage_pure, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_NONE, ability)     
                   
            local fx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_impact_dagger_arcana.vpcf", PATTACH_ABSORIGIN_FOLLOW, Target)
            ParticleManager:SetParticleControlEnt(fx, 0, Target, PATTACH_POINT_FOLLOW, "attach_hitloc", Target:GetAbsOrigin(), true)
            ParticleManager:SetParticleControl(fx, 1, Target:GetAbsOrigin())
            ParticleManager:SetParticleControlOrientation(fx, 1, self:GetCaster():GetForwardVector() * (-1), self:GetCaster():GetRightVector(), self:GetParent():GetUpVector())
            ParticleManager:ReleaseParticleIndex(fx)                            
       		end	

        end
		end

end

function modifier_item_alduin_soul_final:OnDeath(data)
        local parent = self:GetParent()
        local killer = data.attacker
        local killed_unit = data.unit

        local chance = self:GetAbility():GetSpecialValueFor("chance_to_stack")
        local max_charge = self:GetAbility():GetSpecialValueFor("max_charge")
         if killer == parent and killed_unit and RollPercentage(chance) then
        		local charges = self:GetStackCount() + 1
           	 	self:SetStackCount(math.min(charges,max_charge))
        end
end

 