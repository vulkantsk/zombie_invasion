
--------------------------------------------------------------------------------
slark_fish_bait_lua = class({})
LinkLuaModifier( "modifier_slark_fish_bait", "heroes/hero_slark/slark_fish_bait/slark_fish_bait_lua", LUA_MODIFIER_MOTION_BOTH )
 

--------------------------------------------------------------------------------
-- Ability Start
function slark_fish_bait_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
	-- pounce
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_slark_fish_bait", -- modifier name
		{duration = duration} -- kv
	)

	-- play effects
	local sound_cast = "murloc"
	EmitSoundOn( sound_cast, caster )
	local sound_cast = "Hero_Undying.Tombstone"
	EmitSoundOn( sound_cast, caster )
end
 
--------------------------------------------------------------------------------
modifier_slark_fish_bait = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
         MODIFIER_EVENT_ON_TAKEDAMAGE,
         MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        } end,
})

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_fish_bait:OnCreated( kv )
	self.parent = self:GetParent()
    
    self.damage_roof = self:GetAbility():GetSpecialValueFor("damage_roof")
    self.stack_count = self:GetAbility():GetSpecialValueFor("stack_count")
 
	self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_fg_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( 300, 0, 300 ) )
	self:AddParticle( self.nFXIndex, false, false, -1, false, false )

    self.damage_count = 0
end
  
function modifier_slark_fish_bait:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("incom_damage")
end

function modifier_slark_fish_bait:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker
            local unit = params.unit
            self.damage_count = self.damage_count + params.damage
            local modif = self:GetParent():FindModifierByName("modifier_slark_essence_shift_lua")
             
            if self.damage_count >= self.damage_roof then 
            	self.damage_count = 0
            	local modif_stc = self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_slark_essence_shift_lua_stack", {duration = 60})
                modif_stc.modifier = modif
                modif_stc.bonus = self.stack_count

            	modif:SetStackCount(modif:GetStackCount() + self.stack_count)
            end
 
        end
    end
end