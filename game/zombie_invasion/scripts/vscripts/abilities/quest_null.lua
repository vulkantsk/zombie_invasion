LinkLuaModifier("modifier_quest_null", "abilities/quest_null", LUA_MODIFIER_MOTION_NONE)


quest_null = class({
    GetIntrinsicModifierName = function() return "modifier_quest_null" end
})

modifier_quest_null = class({
    isHidden = function() return true end,
    IsPurgable = function() return false end,
    IsBuff = function() return true end,
})


function modifier_quest_null:OnCreated()
    self.spawn_boss = false
    self.music_play = false
    self:StartIntervalThink(1)
end

function modifier_quest_null:OnIntervalThink()

	if self:GetParent():HasAbility("quest_stranger_7") and not self.spawn_boss then 
        Timers:CreateTimer(8,function()
          InvasionMode:SpawnBoss("npc_classic_alduin_boss",1)
	    end) 
        self.spawn_boss = true 
    end 
    if self:GetParent():HasAbility("quest_stranger_8") and not self.music_play then 
          EmitGlobalSound("skyrim")
        self.music_play = true 
    end 
     



end