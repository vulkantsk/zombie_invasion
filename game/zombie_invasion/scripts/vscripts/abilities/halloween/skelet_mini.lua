-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
skelet_mini = class({})
 
--------------------------------------------------------------------------------
-- Ability Start
 
function skelet_mini:GetIntrinsicModifierName()
    return "modifier_doom_mini"
end
function skelet_mini:OnSpellStart()
    for i = 1, 6 do
            CreateUnitByName("npc_skelet_boss_mini",  self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(50, 300)), true, nil, nil, DOTA_TEAM_BADGUYS)
    end
end
 
 
 