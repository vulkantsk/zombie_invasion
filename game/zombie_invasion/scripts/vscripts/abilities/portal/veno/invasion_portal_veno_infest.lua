LinkLuaModifier(
	"modifier_invasion_portal_veno_infest",
	"abilities/portal/veno/modifier_invasion_portal_veno_infest",
	LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
	"modifier_invasion_portal_veno_infest_caster",
	"abilities/portal/veno/modifier_invasion_portal_veno_infest_caster",
	LUA_MODIFIER_MOTION_NONE
)

invasion_portal_veno_infest = {}

function invasion_portal_veno_infest:OnSpellStart()
	local caster = self:GetCaster()

	self:GetCursorTarget():AddNewModifier( caster, self, "modifier_invasion_portal_veno_infest", {
		duration = 12
	} )
	caster:AddNewModifier( caster, self, "modifier_invasion_portal_veno_infest_caster", nil )
end