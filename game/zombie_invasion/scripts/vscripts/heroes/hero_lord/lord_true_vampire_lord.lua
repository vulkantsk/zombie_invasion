LinkLuaModifier("modifier_lord_true_vampire_lord", "heroes/hero_lord/lord_true_vampire_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_true_vampire_lord_active", "heroes/hero_lord/lord_true_vampire_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_blood_rage", "heroes/hero_lord/lord_blood_rage", LUA_MODIFIER_MOTION_NONE)


lord_true_vampire_lord = class({})

function lord_true_vampire_lord:Precache(context)
	PrecacheAbilityResources({
		"particles/generic_gameplay/generic_lifesteal.vpcf",
		"particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_aoe.vpcf",
		"particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf",
	}, {
		"blood_rage",
		"evolution",
		"true",
	}, context)
end


 function lord_true_vampire_lord:CastFilterResult()
        if not (self:GetCaster():HasModifier("modifier_lord_blood_rage")) then
            return UF_FAIL_CUSTOM
        end

        if self:GetCaster():HasModifier("modifier_lord_blood_rage") then
            local modif = self:GetCaster():FindModifierByName("modifier_lord_blood_rage")
            if not (modif:GetStackCount() >= self:GetHealthCost(self:GetLevel())) then 
                return UF_FAIL_CUSTOM
            end
        end
        return UF_SUCCESS
end
  

function lord_true_vampire_lord:GetCustomCastError()
        if not (self:GetCaster():HasModifier("modifier_lord_blood_rage")) then
            return "#dota_hud_error_havent_charges"
        end

        if self:GetCaster():HasModifier("modifier_lord_blood_rage") then
            local modif = self:GetCaster():FindModifierByName("modifier_lord_blood_rage")
            if not (modif:GetStackCount() >= self:GetHealthCost(self:GetLevel())) then 
                return "#dota_hud_error_havent_charges"
            end
        end
        return UF_SUCCESS
end
 
function lord_true_vampire_lord:GetIntrinsicModifierName()
	return "modifier_lord_true_vampire_lord"
end
 

function lord_true_vampire_lord:OnSpellStart()
    local caster = self:GetCaster()
    local healthCost = self:GetHealthCost(self:GetLevel())
    
     local modif = caster:FindModifierByName("modifier_lord_blood_rage")
        modif:SetStackCount(modif:GetStackCount() - healthCost)    
    
     caster:AddNewModifier(caster,self,"modifier_lord_true_vampire_lord_active", {duration = self:GetSpecialValueFor("duration")})
     EmitSoundOn("true", caster)

end


modifier_lord_true_vampire_lord = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        	MODIFIER_EVENT_ON_ATTACK,
            MODIFIER_EVENT_ON_TAKEDAMAGE,
        } end,
})

function modifier_lord_true_vampire_lord:OnCreated()
    self.attack_pct = self:GetAbility():GetSpecialValueFor("attack_pct")
    self.lifesteal_pct = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_resist = self:GetAbility():GetSpecialValueFor("bonus_resist")

    self.interval = self:GetAbility():GetSpecialValueFor("interval")

    self:StartIntervalThink(10)
        EmitSoundOn( "evolution", self:GetParent() )

    local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf"
    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
 

    ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin() )

    InvasionMode:CreateDrop("item_alucard_weapon", self:GetParent():GetAbsOrigin() + RandomVector(RandomFloat(50, 200)) )

     
end 

function modifier_lord_true_vampire_lord:OnIntervalThink()
        local parent = self:GetParent()

        local modif = parent:FindModifierByName("modifier_lord_blood_rage")
        local max_charge =  modif:GetAbility():GetSpecialValueFor("max_blood") + self:GetAbility():GetSpecialValueFor("max_blood")

         local charges = self:GetAbility():GetSpecialValueFor("blood_per_tick") + modif:GetStackCount()
         
        modif:SetStackCount(math.min(charges,max_charge))

end 

 

function modifier_lord_true_vampire_lord:GetModifierPhysicalArmorBonus() 
    return self.bonus_armor
end

function modifier_lord_true_vampire_lord:GetModifierPreAttack_BonusDamage() 
    return self.bonus_damage
end

function modifier_lord_true_vampire_lord:GetModifierIncomingDamage_Percentage()
    return -self.bonus_resist
end

function modifier_lord_true_vampire_lord:OnAttack(keys)
    local caster = EntIndexToHScript(keys.caster_entindex)
    local target = keys.target
     if RollPercentage(self.attack_pct) then
    if caster.__hanadayousei_lock ~= true and caster:IsRangedAttacker() then --是否远程攻击
        caster.__hanadayousei_lock = true
        local targets = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,caster:GetOrigin(),nil,800,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,FIND_CLOSEST,false)
        local count = 0
        for i=1,#targets do
            local unit = targets[i]
            if unit~=nil and unit:IsNull()==false and unit~=target and unit:IsAlive() then
                caster:PerformAttack(unit,true,false,true,false,true,false,true)
                count = count + 1
            end
            if count > 1 then
                break
            end
        end
        caster.__hanadayousei_lock = false
    end
end
   
end
 
function modifier_lord_true_vampire_lord:OnTakeDamage( keys )
    if  keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
        -- Spell lifesteal handler
 
        if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
            -- Heal and fire the particle           
            self.lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
            ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
         
            keys.attacker:Heal(keys.damage * self.lifesteal_pct * 0.01, keys.attacker)
        end
    end
end


modifier_lord_true_vampire_lord_active = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})


 
function modifier_lord_true_vampire_lord_active:OnCreated()
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.interval = self:GetAbility():GetSpecialValueFor("intervall")
    self.damage_percent = self:GetAbility():GetSpecialValueFor("damage_percent")
    self:OnIntervalThink()
    self:StartIntervalThink(self.interval)

    local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_aoe.vpcf"

    -- Create Particle
    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
 

    ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, 0 ) )
 
end

function modifier_lord_true_vampire_lord_active:OnDestroy()
    ParticleManager:DestroyParticle( self.effect_cast, false )
end

function modifier_lord_true_vampire_lord_active:OnIntervalThink()
    local units = FindUnitsInRadius(
            self:GetParent():GetTeam(),
            self:GetParent():GetAbsOrigin(),
            nil,
            self.radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_CLOSEST,
            false
        )
        for _, unit in pairs( units ) do
        local damage = (self.damage + ((self.damage_percent/100) * unit:GetHealth()))*self.interval

        ApplyDamage( { victim = unit, attacker = self:GetParent(), damage = damage,
                        damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility()} )
        end
end