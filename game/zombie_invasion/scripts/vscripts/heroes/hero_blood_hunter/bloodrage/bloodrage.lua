LinkLuaModifier( "modifier_bloodrage_buff", "heroes/hero_blood_hunter/bloodrage/bloodrage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bloodrage_count", "heroes/hero_blood_hunter/bloodrage/bloodrage", LUA_MODIFIER_MOTION_NONE )

bloodrage = class({})

function bloodrage:Precache(context)
	PrecacheAbilityResources({
		"particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf",
		"particles/generic_gameplay/generic_lifesteal.vpcf",
	}, {
		"hero_bloodseeker.bloodRage",
	}, context)
end


function bloodrage:OnSpellStart()
     local caster = self:GetCaster()

     caster:AddNewModifier(caster, self, "modifier_bloodrage_buff", { duration =  self:GetSpecialValueFor("duration")})
     caster:EmitSound("hero_bloodseeker.bloodRage")

end 


modifier_bloodrage_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    GetEffectName           = function(self) return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
    DeclareFunctions        = function(self) return 
            {
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
            MODIFIER_EVENT_ON_TAKEDAMAGE,
            } end,
})


function modifier_bloodrage_buff:OnCreated( kv )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.stack_damage = self:GetAbility():GetSpecialValueFor("stack_damage")
    self.stack_attackspeed = self:GetAbility():GetSpecialValueFor("stack_attackspeed")

    self:StartIntervalThink(0.25)
    self:OnIntervalThink()
    
end

function modifier_bloodrage_buff:OnTakeDamage(params)
    if not IsServer() then return end
    if self:GetParent() ~= params.attacker then return end
    if self:GetParent() == params.unit then return end
    if params.unit:IsBuilding() then return end
    if params.unit:IsWard() then return end
    if params.inflictor == nil and not self:GetParent():IsIllusion() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then 
        local heal = self:GetAbility():GetSpecialValueFor("lifesteal") / 100 * params.damage
        self:GetParent():Heal(heal, self:GetAbility())

        local particle = "particles/generic_gameplay/generic_lifesteal.vpcf"

       

        local effect_cast = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, params.attacker )
        ParticleManager:ReleaseParticleIndex( effect_cast )
    end
end

function modifier_bloodrage_buff:OnRefresh( kv )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.stack_damage = self:GetAbility():GetSpecialValueFor("stack_damage")
    self.stack_attackspeed = self:GetAbility():GetSpecialValueFor("stack_attackspeed")

    self:StartIntervalThink(0.25)
    self:OnIntervalThink()


end

function modifier_bloodrage_buff:OnIntervalThink()
    if not IsServer() then return end
    self:GetParent():SetHealth(math.max( self:GetParent():GetHealth() - (100 * 0.10), 1))
end


function modifier_bloodrage_buff:GetModifierProcAttack_Feedback( params )
    if IsServer() then
        local parent = self:GetParent()

        if self:GetCaster():HasAbility("blood_buff_1") then 


            if parent:HasScepter() then
                local target = params.target   
    
                self:AddStack( 60, 10 )
            else
                local target = params.target   
    
                self:AddStack( 40, 4 )
            end

        else
            if parent:HasScepter() then
                local target = params.target   
    
                self:AddStack( 40, 5 )
            else
                local target = params.target   
    
                self:AddStack( 20, 2 )
            end
        end
    end
end

    function modifier_bloodrage_buff:GetModifierPreAttack_BonusDamage()
        return self.bonus_damage + (self:GetStackCount() * self.stack_damage)
    end

    function modifier_bloodrage_buff:GetModifierAttackSpeedBonus_Constant()
        return self.bonus_attack_speed + (self:GetStackCount() * self.stack_attackspeed)
    end

    -- Helper
function modifier_bloodrage_buff:AddStack( duration, count )
    -- Add counter
    local mod = self:GetParent():AddNewModifier(
        self:GetParent(),
        self:GetAbility(),
        "modifier_bloodrage_count",
        {
            duration = duration,
        }
    )
    mod.modifier = self
    mod.bonus = count
    self:SetStackCount(self:GetStackCount() + count)
 
end

function modifier_bloodrage_buff:RemoveStack( value )
    self:SetStackCount( self:GetStackCount() - value )
end

modifier_bloodrage_count = class({
    IsHidden                 = function(self) return true end,
    IsPurgable                 = function(self) return false end,
    IsDebuff                 = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath             = function(self) return false end,
    GetAttributes                = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
})


 
function modifier_bloodrage_count:OnRemoved()
        self.modifier:RemoveStack(self.bonus)
end
 
