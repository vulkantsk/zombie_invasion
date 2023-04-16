ability_hell_summon = {}

LinkLuaModifier( "modifier_hell_summon_portal", "heroes/hero_sargatanas/ability_hell_summon", LUA_MODIFIER_MOTION_NONE )


function ability_hell_summon:OnSpellStart() 
	local caster = self:GetCaster()
	local point = self:GetCaster():GetAbsOrigin() 
	local portal = CreateUnitByName("npc_portal", point, true, nil, nil, DOTA_TEAM_GOODGUYS)  
	local point_for_unit = portal:GetAbsOrigin()
	local unit_name = self:UnitnameHell() 

	local str_dmg = caster:GetStrength() * self:GetSpecialValueFor("str_dmg")
	local str_hp = caster:GetStrength() *  self:GetSpecialValueFor("str_hp")
	local ag_speed = caster:GetAgility() * self:GetSpecialValueFor("ag_speed")

  	portal:AddNewModifier(self:GetCaster(),self,"modifier_hell_summon_portal", {})

    Timers:CreateTimer(2, function()
    	if caster:HasModifier("modifier_star_devour_stack") then
    		local modif = caster:FindModifierByName("modifier_star_devour_stack")

    	for i=1, modif:GetStackCount() do
			local unit = CreateUnitByName(unit_name, point_for_unit, true, nil, nil, DOTA_TEAM_GOODGUYS)  
			unit:SetOwner( caster )
			unit:SetControllableByPlayer( caster:GetPlayerID(), true )
			FindClearSpaceForUnit( unit, point_for_unit, true )
			unit:SetBaseMaxHealth(str_hp)
			unit:SetBaseDamageMin(str_dmg)	
			unit:SetBaseDamageMax(str_dmg)
 		end
		caster:RemoveModifierByName("modifier_star_devour_stack")
		end
   end)

end

function ability_hell_summon:UnitnameHell() 
	local ability_lvl = self:GetLevel()
	if ability_lvl == 1 then 
		return "npc_spirit_sargatanas_hell_summon"
	elseif ability_lvl == 2 then
		return "npc_golem_sargatanas_hell_summon"
	elseif ability_lvl == 3 then
		return "npc_scorpion_sargatanas_hell_summon"
	elseif ability_lvl == 4 then
		return "npc_dragon_sargatanas_hell_summon"
	elseif ability_lvl == 5 then
		return "npc_kaban_sargatanas_hell_summon"


	end
end

 modifier_hell_summon_portal = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
    AllowIllusionDuplicate 	= function(self) return true end,
    GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})
 
function modifier_hell_summon_portal:OnCreated()

	local particleName2 = "particles/units/heroes/heroes_underlord/abbysal_underlord_portal_ambient.vpcf"
	self.pfx2 = ParticleManager:CreateParticle(particleName2,PATTACH_ABSORIGIN_FOLLOW,self:GetParent())

   Timers:CreateTimer(5, function()
		self:GetParent():Destroy()
   end)
end

function modifier_hell_summon_portal:OnDestroy()
	ParticleManager:DestroyParticle(self.pfx2,true)
end
 
