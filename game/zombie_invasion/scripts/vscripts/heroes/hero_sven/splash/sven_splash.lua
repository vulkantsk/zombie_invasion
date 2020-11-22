sven_splash = class({})
LinkLuaModifier( "modifier_sven_splash", "heroes/hero_sven/splash/modifier_sven_splash",LUA_MODIFIER_MOTION_NONE )  
LinkLuaModifier( "modifier_sven_splash_2", "heroes/hero_sven/splash/modifier_sven_splash",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
 


 function sven_splash:GetIntrinsicModifierName()
    return "modifier_sven_splash"
end


--------------------------------------------------------------------------------
 