LinkLuaModifier(
	"modifier_invasion_portal_warlock_portal",
	"abilities/portal/warlock/modifier_invasion_portal_warlock_portal",
	LUA_MODIFIER_MOTION_NONE
)

invasion_portal_warlock_portal = {}

function invasion_portal_warlock_portal:OnSpellStart()
	local caster = self:GetCaster()

	CreateModifierThinker(
		caster,
		self,
		"modifier_invasion_portal_warlock_portal",
		nil,
		self:GetCursorPosition(),
		caster:GetTeam(),
		false
	)
end