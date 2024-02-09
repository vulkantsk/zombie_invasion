LinkLuaModifier("modifier_item_blood_keeper", "items/carry/item_blood_keeper", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_blood_keeper_shield", "items/carry/item_blood_keeper", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lifesteal", "modifiers/modifier_lifesteal", LUA_MODIFIER_MOTION_NONE)

item_blood_keeper = class({})

function item_blood_keeper:GetIntrinsicModifierName()
return "modifier_item_blood_keeper"
end

function item_blood_keeper:Precache(context)
    PrecacheResource("particle", "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf", context)
end

function item_blood_keeper:OnSpellStart()
    local charges = self:GetCurrentCharges()
    if charges <= 0 then 
        return 
    end
    local caster = self:GetCaster()
    local healing = charges * self:GetSpecialValueFor("heal_per_charge")
    caster:Heal(healing, self)
    self:SetCurrentCharges(0)

    SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster, healing, nil)

    local particle = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "", caster:GetAbsOrigin(), true)
 
    EmitSoundOn("hero_bloodseeker.bloodRite.silence", caster)
end



modifier_item_blood_keeper = class({})

function modifier_item_blood_keeper:IsHidden() return true end
function modifier_item_blood_keeper:IsPurgable() return false end
function modifier_item_blood_keeper:DeclareFunctions()
return
{
 
  MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
  MODIFIER_EVENT_ON_ATTACK_LANDED,

}
end

function modifier_item_blood_keeper:GetModifierPhysicalArmorBonus() 
  return self:GetAbility():GetSpecialValueFor("bonus_armor")
end


function modifier_item_blood_keeper:GetModifierExtraHealthPercentage()
    return self:GetAbility():GetSpecialValueFor("health_debuff")
end


 function modifier_item_blood_keeper:GetModifierProcAttack_Feedback( params )
  if not IsServer() then return end 
  if self:GetParent():HasModifier("modifier_item_pavise_custom_shield") then return end 
  if self:GetParent():HasModifier("modifier_item_battle_shield") then return end 
  
  local duration = self:GetAbility():GetSpecialValueFor("duration")
  local chance =  self:GetAbility():GetSpecialValueFor("chance")
  local random = RollPseudoRandomPercentage(chance,76,self:GetParent())

 if not random then return end
   
 self:GetCaster():AddNewModifier(self:GetCaster (), self:GetAbility(), "modifier_item_blood_keeper_shield", { duration = duration})
end

function modifier_item_blood_keeper:RollChance( chance )
  local rand = math.random()
  if rand<chance/100 then
    return true
  end
  return false
end


function modifier_item_blood_keeper:AddShield()
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_item_pavise_custom_shield") then return end 
if self:GetParent():HasModifier("modifier_item_battle_shield") then return end 

 local shield = self:GetParent():GetMaxHealth()*self:GetAbility().shield_health

 self:SetStackCount(shield )
 self.shield = self:GetStackCount()

end

function modifier_item_blood_keeper:OnCreated()
    self.parent = self:GetParent()
    self.modif_lif = self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_lifesteal", {})
 self.bonusDamage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self:OnRefresh()
end

function modifier_item_blood_keeper:OnRefresh(table)
    self.ability = self:GetAbility()
    if(not self.ability or self.ability:IsNull()) then
        return
    end
    self.bonus_str     = self.ability:GetSpecialValueFor("bonus_str")
    self.bonusDamage = self.ability:GetSpecialValueFor("bonus_damage")
    self.lifesteal    = self.ability:GetSpecialValueFor("lifesteal")
    self.chargesPerBossAttack    = self.ability:GetSpecialValueFor("charges_for_attack_boss")
    self.chargesPerCreepAttack    = self.ability:GetSpecialValueFor("charges_for_attack_creep")
    self.maxCharges    = self.ability:GetSpecialValueFor("max_charges")
    if not IsServer() then return end
    self:AddShield()
end

function modifier_item_blood_keeper:GetModifierPreAttack_BonusDamage()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("bonus_damage")
    end
end

function modifier_item_blood_keeper:GetModifierBonusStats_Strength()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("bonus_str")
    end
end



function modifier_item_blood_keeper:OnDestroy()
    self.parent = self:GetParent()
            self.modif_lif:Destroy()
end

function modifier_item_blood_keeper:OnAttackLanded(kv)
    self.ability = self:GetAbility()
    if(kv.attacker ~= self.parent) then
        return
    end
     
    local currentCharges = self.ability:GetCurrentCharges()

    local bonusChargesPerAttack = self.chargesPerCreepAttack
 

    self.ability:SetCurrentCharges(math.min(currentCharges + bonusChargesPerAttack, self.maxCharges))
end


modifier_item_blood_keeper_shield = class({})

function modifier_item_blood_keeper_shield:IsHidden() return false end
function modifier_item_blood_keeper_shield:IsPurgable() return false end

function modifier_item_blood_keeper_shield:OnCreated(table)
if not IsServer() then return end
 self:AddShield()
end


function modifier_item_blood_keeper_shield:AddShield()
if not IsServer() then return end
 local shield = self:GetAbility():GetSpecialValueFor("block") + self:GetCaster():GetMaxHealth() * 10 / 100
 local max_block = self:GetAbility():GetSpecialValueFor("max_block") + self:GetCaster():GetMaxHealth() * 40 / 100

 self:SetStackCount(math.min(self:GetStackCount() + shield,max_block) )
 self.shield = self:GetStackCount()
end

function modifier_item_blood_keeper_shield:OnRefresh(table)
if not IsServer() then return end
 self:AddShield()
end



function modifier_item_blood_keeper_shield:DeclareFunctions()
return
{
   MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
   MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}

end

function modifier_item_blood_keeper_shield:GetModifierStatusResistanceStacking() 
  return self:GetAbility().shield_status
end


function modifier_item_blood_keeper_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
    return self:GetStackCount()
end

if not IsServer() then return end
if params.inflictor and params.inflictor == self:GetAbility() then 
  return
end

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)
    self:Destroy()
    return -i
end

end


function modifier_item_blood_keeper_shield:GetTexture()
    return "blood_keeper"
end

 
