LinkLuaModifier( "modifier_animation_skelet_boss", "abilities/halloween/skelet_boss", LUA_MODIFIER_MOTION_NONE )
 
skelet_boss = {}

function skelet_boss:GetIntrinsicModifierName()
    return "modifier_animation_skelet_boss"
end

 
  
 
if modifier_animation_skelet_boss == nil then
    modifier_animation_skelet_boss = class({})
end

local public = modifier_animation_skelet_boss

function public:IsHidden()
    return true
end
function public:IsDebuff()
    return false
end
function public:IsPurgable()
    return false
end
function public:IsPurgeException()
    return false
end
function public:AllowIllusionDuplicate()
    return false
end
function public:RemoveOnDeath()
    return false
end
function public:DestroyOnExpire()
    return false
end
function public:OnCreated(params)
    self.AttackSpeedActivityModifiers = KeyValues.UnitsKv[self:GetParent():GetUnitName()].AttackSpeedActivityModifiers
    self.AttackRangeActivityModifiers = KeyValues.UnitsKv[self:GetParent():GetUnitName()].AttackRangeActivityModifiers
    self.MovementSpeedActivityModifiers = KeyValues.UnitsKv[self:GetParent():GetUnitName()].MovementSpeedActivityModifiers

    if IsServer() then
        -- self:StartIntervalThink(0)
    end
 
end
 
function public:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function public:GetActivityTranslationModifiers(params)
    if self.MovementSpeedActivityModifiers ~= nil then
        local ActivityTranslationModifiers = ""
        local flMoveSpeed = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false)
        local flMaxSpeed = -1
        for key, speed in pairs(self.MovementSpeedActivityModifiers) do
            if flMoveSpeed > speed and speed > flMaxSpeed then
                ActivityTranslationModifiers = key
                flMaxSpeed = speed
            end
        end
        return ActivityTranslationModifiers
    end
end