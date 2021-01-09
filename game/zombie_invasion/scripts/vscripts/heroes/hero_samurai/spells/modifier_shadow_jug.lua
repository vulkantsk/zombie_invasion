modifier_shadow_jug = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_shadow_jug:IsHidden()
	return false
end

function modifier_shadow_jug:IsDebuff()
	return false
end

function modifier_shadow_jug:IsPurgable()
	return false
end

--------------------------------------------------------------------------------  
-- Initializations
function modifier_shadow_jug:OnCreated( kv )
	-- references
	self.delay = kv.delay or 0
	self.attack_reveal = kv.attack_reveal or true
	self.ability_reveal = kv.ability_reveal or true

	self.hidden = false

	if IsServer() then
		-- Start interval
		self:StartIntervalThink( self.delay )
	end
end

function modifier_shadow_jug:OnRefresh( kv )
	-- references
	self.delay = kv.delay or 0
	self.attack_reveal = kv.attack_reveal or true
	self.ability_reveal = kv.ability_reveal or true

	self.hidden = false

	if IsServer() then
		-- Start interval
		self:StartIntervalThink( self.delay )
	end
end

function modifier_shadow_jug:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_shadow_jug:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
 
	}

	return funcs
end

function modifier_shadow_jug:GetModifierInvisibilityLevel()
	return 1
end

 
--------------------------------------------------------------------------------
-- Status Effects
function modifier_shadow_jug:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = self.hidden,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_shadow_jug:OnIntervalThink()
	self.hidden = true
end

function modifier_shadow_jug:GetEffectName()
	return "particles/econ/items/phantom_assassin/pa_fall20_immortal_shoulders/pa_fall20_blur_ambient.vpcf"
end
 