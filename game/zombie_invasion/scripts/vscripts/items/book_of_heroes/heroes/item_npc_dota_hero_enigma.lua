LinkLuaModifier("modifier_enigma", "items/book_of_heroes/heroes/item_npc_dota_hero_enigma", LUA_MODIFIER_MOTION_NONE)

item_npc_dota_hero_enigma = class({})

function item_npc_dota_hero_enigma:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("enigma_buff_1") then 
          caster:AddAbility("enigma_buff_1"):SetLevel(1)
          UTIL_Remove(hItem)
        end
end



enigma_buff_1 = class({})

function enigma_buff_1:GetIntrinsicModifierName()
    return "modifier_enigma"
end


modifier_enigma = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    GetAttributes   = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
 
})

function modifier_enigma:CheckState()
    if self:GetParent():GetUnitName() == npc_dota_hero_enigma then
        return {[MODIFIER_STATE_ATTACK_IMMUNE] = true}
    else
        return{[MODIFIER_STATE_ATTACK_IMMUNE] = false}
    end
end

function modifier_enigma:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return funcs
end
function modifier_enigma:GetMinHealth()
    return 666
end

function modifier_enigma:OnCreated( data )
    
end
