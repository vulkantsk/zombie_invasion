 if item_sumon_boss == nil then
	item_sumon_boss = class({})
 
end
 
 local sumon_boss = 0
function item_sumon_boss:OnSpellStart()
	-- Effects
 
 
	    EmitSoundOn( "DOTA_Item.Refresher.Activate", self:GetCaster() )
 
    local caster        =   self:GetCaster()
 
if caster:HasModifier("modifier_sumon")   then   
 	 InvasionMode:Halloween_boss_plus()
 	 		caster:RemoveItem(self)
	local point = Entities:FindByName(nil,"skelet_boss_spawn")

		local unit = CreateUnitByName("npc_skelet_boss", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		unit:SetInitialGoalEntity(point)
	 StopGlobalSound("Rick Astley - Never Gonna Give You Up")
 	 		 
 	else 
 		sumon_boss = sumon_boss + 1
 		if sumon_boss < 12 then 
 	          GameRules:SendCustomMessage("<font color='#fffacd'>Ничего не произошло</font>", 0, 0)
 	    elseif sumon_boss == 13 then 
 	          GameRules:SendCustomMessage("<font color='#fffacd'>ТЫ СОВСЕМ ЧТО ЛИ ЕБЛАН????? ПРОЧИТАЙ ЕБУЧЕЕ ОПИСАНИЕ ПРЕДМЕТА И ПОДМУАЙ СВАОЕЙ ТУПОЙ БАШКОЙ ЧТО НУЖНО БЛЯТЬ СДЕЛАТЬ СО МНОЙ!! ЗАЕБАЛ БЛЯТЬ НАЖМИТЬ Я ЖЕ ТОЖЕ ЖИВОЙ!</font>", 0, 0)
 	    elseif sumon_boss == 30 then 
 	          GameRules:SendCustomMessage("<font color='#fffacd'>ОКЕЙ РАЗ ТЫ НАСТОЛКЬО ТУПОЙ БЛЯТЬ ВЫБЛЯДОК ОБЬЯСНЯЮ!!!! ИДЕШЬ В ЛОКАЦИЮ СКЕЛЕТОВ, ВИДИШЬ ТАМ ГЛАЗИК И СУКА ПРИКИНЬ БЛЯТЬ, ВСТАЕШЬ НА НЕГО, ТАК ЖЕ КАК У МЕНЯ ВСТАЕТ НА ТВОЮ МАМКУ, СЫН СВИНЬИ. И ПОСЛЕ ЭТОГО УЖЕ МОЖЕШЬ НАЖАТЬ МЕНЯ!!</font>", 0, 0)
 	    else 
 	          GameRules:SendCustomMessage("<font color='#fffacd'>Ничего не произошло</font>", 0, 0)
 	    end
end   
 
 
end
 