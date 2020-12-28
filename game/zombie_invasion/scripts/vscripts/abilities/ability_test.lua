ability_test_1=class({})

function ability_test_1:OnSpellStart()
	EndGame:GoodEnd()
end

ability_test_2=class({})

function ability_test_2:OnSpellStart()
	Sounds:CreateGlobalLoopingSound("C418 - Sweden")
end

ability_test_3=class({})

function ability_test_3:OnSpellStart()
	EmitGlobalSound("Ability.GushCast")
end

ability_test_4=class({})

function ability_test_4:OnSpellStart()
	Sounds:CreateGlobalSound("Ability.GushCast")
end

ability_test_5=class({})

function ability_test_5:OnSpellStart()
	EndGame:GoodEnd()
end

ability_test_6=class({})

function ability_test_6:OnSpellStart()
	EndGame:GoodEnd()
end

ability_test_7=class({})

function ability_test_7:OnSpellStart()
	local caster = self:GetCaster()
	local position = caster:GetAbsOrigin() + RandomVector(100)	
	CreateUnitByName("npc_greevil", position, true, nil, nil, DOTA_TEAM_BADGUYS)
end
