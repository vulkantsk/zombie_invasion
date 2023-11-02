LinkLuaModifier("modifier_jakiro_buff", "items/book_of_heroes/heroes/item_npc_dota_hero_jakiro", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_jakiro = class({})

function item_npc_dota_hero_jakiro:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("jakiro_buff_1") then 
          caster:AddAbility("jakiro_buff_1"):SetLevel(1)
          caster:RemoveItem(hItem)
        end
end



jakiro_buff_1 = class({})

function jakiro_buff_1:GetIntrinsicModifierName()
    return "modifier_jakiro_buff"
end


modifier_jakiro_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,

        } end,
})

function modifier_jakiro_buff:IsHidden()
    return true
end

function modifier_jakiro_buff:CheckState()
    local state = {[MODIFIER_STATE_FLYING] = true}
    return state
end

function modifier_jakiro_buff:GetModifierMoveSpeedBonus_Percentage()
    return -25
end

function modifier_jakiro_buff:GetBonusNightVision()
    return 400
end

function modifier_jakiro_buff:GetBonusDayVision()
    return 800
end