LinkLuaModifier( "modifier_invasion_portal_necr_leader", "abilities/portal/necr/modifier_invasion_portal_necr_leader", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invasion_portal_necr_leader_aura", "abilities/portal/necr/modifier_invasion_portal_necr_leader_aura", LUA_MODIFIER_MOTION_NONE )

invasion_portal_necr_leader = {}

function invasion_portal_necr_leader:GetIntrinsicModifierName()
	return "modifier_invasion_portal_necr_leader"
end