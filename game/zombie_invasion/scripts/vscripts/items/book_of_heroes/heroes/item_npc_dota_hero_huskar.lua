item_npc_dota_hero_huskar = class({})

function item_npc_dota_hero_huskar:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf",
	}, {
		"Hero_DoomBringer.Devour",
		"Hero_DoomBringer.DevourCast",
	}, context)
end


function item_npc_dota_hero_huskar:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self
        if caster:FindAbilityByName("lord_devour"):GetLevel() == 0 then 
           caster:FindAbilityByName("lord_devour"):SetLevel(1)
           UTIL_Remove(hItem)
        end
end

lord_devour = class({})

function lord_devour:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf",
	}, {
		"Hero_DoomBringer.Devour",
		"Hero_DoomBringer.DevourCast",
	}, context)
end

 

LinkLuaModifier( "modifier_lord_devour", "items/book_of_heroes/heroes/item_npc_dota_hero_huskar", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lord_devour_endless", "items/book_of_heroes/heroes/item_npc_dota_hero_huskar", LUA_MODIFIER_MOTION_NONE )


function lord_devour:CastFilterResultTarget( hTarget )
    local nResult = UnitFilter(
        hTarget,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_CREEP,  
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
        self:GetCaster():GetTeamNumber()
    )
    if nResult ~= UF_SUCCESS then
        return nResult
    end


    return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Start
function lord_devour:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    -- load data
    local duration = self:GetSpecialValueFor( "devour_time" )

    -- add modifier
    caster:AddNewModifier(
        caster, -- player source
        self, -- ability source
        "modifier_lord_devour", -- modifier name
        { duration = duration } -- kv
    )
    -- Play effects and no draw
    self:PlayEffects( target )
    target:SetOrigin( target:GetOrigin() + Vector( 0, 0, -200 ) )

    -- kill target
    target:Kill( self, caster )
end
 
function lord_devour:OnCreated()
    if self:GetCaster():HasModifier("modifier_lord_devour_endless") then return end
        self:GetAbility():SetActivated(false)

end
--------------------------------------------------------------------------------
function lord_devour:PlayEffects( target )
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf"
    local sound_cast = "Hero_DoomBringer.Devour"
    local sound_target = "Hero_DoomBringer.DevourCast"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        1,
        self:GetCaster(),
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    -- Create Sound
    EmitSoundOn( sound_cast, self:GetCaster() )
    EmitSoundOn( sound_target, target )
end

function lord_devour:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
 

 
modifier_lord_devour = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            
        } end,

})
 
 
--------------------------------------------------------------------------------
function modifier_lord_devour:OnCreated( kv )
    -- references
    self.bonus_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
end

function modifier_lord_devour:OnRefresh( kv )
    
end

function modifier_lord_devour:OnRemoved()
end

function modifier_lord_devour:OnDestroy()
    if not IsServer() then return end
    -- grant bonus gold if alive
    if self:GetParent():IsAlive() then
        PlayerResource:ModifyGold( self:GetParent():GetPlayerOwnerID(), self.bonus_gold, false, DOTA_ModifyGold_Unspecified )
        local modif = self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(), "modifier_lord_devour_endless", {})
        modif:IncrementStackCount()
    end
end


function modifier_lord_devour:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
 


 

modifier_lord_devour_endless = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        } end,
})


function modifier_lord_devour_endless:OnCreated( kv )
    -- references
    self.bonus_movespeed = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )

end

function modifier_lord_devour_endless:OnRefresh( kv )
    self.bonus_movespeed = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )  
end

function modifier_lord_devour_endless:GetModifierMoveSpeedBonus_Constant()
    return self:GetStackCount() * self.bonus_movespeed 
end


function modifier_lord_devour_endless:GetModifierPhysicalArmorBonus()
    return self:GetStackCount() * self.bonus_armor
end

function modifier_lord_devour_endless:GetModifierBaseAttack_BonusDamage()
    return self:GetStackCount() * self.bonus_damage
end