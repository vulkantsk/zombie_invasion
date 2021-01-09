item_midas = class({})

function item_midas:OnSpellStart()
	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin()
	CreateUnitByName("npc_medas", point, true, nil, nil, DOTA_TEAM_BADGUYS)
end
