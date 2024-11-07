LinkLuaModifier( "modifier_out_of_game", "abilities/ability_out_of_game_helper", LUA_MODIFIER_MOTION_NONE )

out_of_game = class({
    GetIntrinsicModifierName = function(self)
        return "modifier_out_of_game"
    end
})

modifier_out_of_game = class({
    IsHidden = function(self) return false end,
    IsPurgable = function(self) return false end,
    IsDebuff = function(self) return true end,
    CheckState = function(self) return {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_INVULNERABLE] = false,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_UNSELECTABLE] = false
    } end,
})
