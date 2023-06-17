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

	if quest_stranger_7

end