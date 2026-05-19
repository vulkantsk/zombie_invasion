LinkLuaModifier("tome_strenght_modifier", "/items/item_bonus_stat.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("tome_agility_modifier", "/items/item_bonus_stat.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("tome_intelect_modifier", "/items/item_bonus_stat.lua", LUA_MODIFIER_MOTION_NONE)

if item_pizza2 == nil then
	item_pizza2 = class({})
 
end


function item_pizza2:OnSpellStart()
	--print("OnSpellStart")
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
    local statBonus = self:GetSpecialValueFor("bonus_stat")

    if hTarget:GetUnitName() == "npc_gurd_jitel" then 
    	local point = hTarget:GetAbsOrigin()
    	GameRules:SendCustomMessage("<font color='#c10020'>ХА-ХА ТЫ ДУМАЛ ЧТО Я АТДАМ АРТЕФАКТ ОН МОЙ!</font>", 0, 0)
    	hTarget:Destroy()
    	local unit = CreateUnitByName("npc_boss_Gurd", point, true,nil,nil,DOTA_TEAM_BADGUYS)
     	 self.effect_cast_start = ParticleManager:CreateParticle( "particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_WORLDORIGIN, unit )
	 	 ParticleManager:SetParticleControl( self.effect_cast_start, 0, unit:GetAbsOrigin() )
	 	 ParticleManager:SetParticleControl( self.effect_cast_start, 1, Vector( 500, 0, 0 ) )   
		unit:EmitSound("Hero_Warlock.RainOfChaos")
    end
    

    if hTarget:HasModifier("tome_strenght_modifier") == false then
		hTarget:AddNewModifier(hTarget,self,"tome_strenght_modifier",nil)
        hTarget:SetModifierStackCount("tome_strenght_modifier", hTarget, statBonus)
    else
        hTarget:SetModifierStackCount("tome_strenght_modifier", hTarget, (hTarget:GetModifierStackCount("tome_strenght_modifier", hTarget) + statBonus))
    end

    if hTarget:HasModifier("tome_agility_modifier") == false then
		hTarget:AddNewModifier(hTarget,self,"tome_agility_modifier",nil)
        hTarget:SetModifierStackCount("tome_agility_modifier", hTarget, statBonus)
    else
        hTarget:SetModifierStackCount("tome_agility_modifier", hTarget, (hTarget:GetModifierStackCount("tome_agility_modifier", hTarget) + statBonus))
    end

    if hTarget:HasModifier("tome_intelect_modifier") == false then
		hTarget:AddNewModifier(hTarget,self,"tome_intelect_modifier",nil)
        hTarget:SetModifierStackCount("tome_intelect_modifier", hTarget, statBonus)
    else
        hTarget:SetModifierStackCount("tome_intelect_modifier", hTarget, (hTarget:GetModifierStackCount("tome_intelect_modifier", hTarget) + statBonus))
    end

    hTarget:EmitSound("eating")
	if self:GetCurrentCharges() <= self:GetInitialCharges() then
		UTIL_Remove(self)
		return
	end
 
 	self:SetCurrentCharges(self:GetCurrentCharges() - self:GetInitialCharges())

end