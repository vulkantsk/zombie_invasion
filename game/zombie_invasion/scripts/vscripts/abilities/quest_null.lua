LinkLuaModifier("modifier_quest_null", "abilities/quest_null", LUA_MODIFIER_MOTION_NONE)


quest_null = class({
    GetIntrinsicModifierName = function() return "modifier_quest_null" end
})

modifier_quest_null = class({
    isHidden = function() return true end,
    IsPurgable = function() return false end,
    IsBuff = function() return true end,
})




function modifier_quest_null:OnIntervalThink(1)

	if self:GetParent():HasAbility("quest_stranger_6") then Timers:CreateTimer(8,function()
		InvasionMode:spawnalduin()
	end) end 



end