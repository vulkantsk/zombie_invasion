ability_quill_spray = class({})

function ability_quill_spray:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf",
	}, {
		"Hero_Bristleback.QuillSpray.Cast",
	}, context)
end

LinkLuaModifier('modifier_ability_quill_spray_debuff_active', 'heroes/hero_brist/quill_spray', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_ability_quill_spray_debuff', 'heroes/hero_brist/quill_spray', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_bristleback_quill_spray_autocast', 'heroes/hero_brist/quill_spray', LUA_MODIFIER_MOTION_NONE)

function ability_quill_spray:OnSpellStart()
	self.caster	= self:GetCaster()
	
	local radius					= self:GetSpecialValueFor("radius")
    local projectile_speed		= self:GetSpecialValueFor("projectile_speed")
    local duration = self:GetSpecialValueFor("quill_stack_duration")
    local quill_stack_damage = self:GetSpecialValueFor("quill_stack_damage")
    local quill_base_damage = self:GetSpecialValueFor("quill_base_damage")
    local caster = self:GetCaster()
		
	if not IsServer() then return end
	
    local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
    ParticleManager:ReleaseParticleIndex(nfx)

    for k,v in pairs(FindUnitsInRadius(self:GetCaster():GetTeam(), 
    self:GetCaster():GetOrigin(), 
    nil, 
    radius,
    DOTA_UNIT_TARGET_TEAM_ENEMY, 
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
    FIND_ANY_ORDER, 
    false)) do 
        local amount = v:AddStackModifier({
            ability = self, 
            modifier = 'modifier_ability_quill_spray_debuff',
            duration = duration,
            updateStack = true,
            caster = caster,
        })

        v:AddNewModifier(caster, self, 'modifier_ability_quill_spray_debuff_active', {duration = duration})

        ApplyDamage({
            victim = v,
            attacker = caster,
            damage = quill_base_damage + amount * quill_stack_damage,
            damage_type = self:GetAbilityDamageType(),
            ability = self,
        })

        if self:GetAutoCastState() then
            caster:AddNewModifier( caster, self, "modifier_bristleback_quill_spray_autocast", {} )
        else

            caster:RemoveModifierByName("modifier_bristleback_quill_spray_autocast")
        end
    end 
	
    self.caster:EmitSound("Hero_Bristleback.QuillSpray.Cast")
end

modifier_ability_quill_spray_debuff_active = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return true end,
    GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
})


function modifier_ability_quill_spray_debuff_active:OnDestroy()
    if IsClient() then return end
    self:GetParent():AddStackModifier({
        ability = self:GetAbility(), 
        modifier = 'modifier_ability_quill_spray_debuff',
        caster = self:GetCaster(),
        count = -1,
    })
end 

modifier_ability_quill_spray_debuff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return true end,
})


modifier_bristleback_quill_spray_autocast = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
})


function modifier_bristleback_quill_spray_autocast:OnCreated()
    if IsServer() then
        local ability = self:GetAbility()
        self:StartIntervalThink(0.2)
        ability:OnSpellStart()
    end
end

function modifier_bristleback_quill_spray_autocast:OnIntervalThink()
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    local current_mana  = caster:GetMana()
    local mana_required = ability:GetManaCost(-1)

    if not ability:GetAutoCastState() then
        caster:RemoveModifierByName("modifier_bristleback_quill_spray_autocast")
    end
    if current_mana > mana_required and ability:IsFullyCastable() and caster:IsAlive() and not caster:IsStunned() and not caster:IsMuted() and not caster:IsHexed()  then
 
                    self:GetParent():CastAbilityNoTarget( ability, self:GetParent():GetPlayerID() )
 
    end
end

 