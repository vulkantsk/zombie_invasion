
function OnAttacked( event )
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	
	if not attacker:IsRealHero() then
		return
	end
	
	ability.attacks_need = ability.attacks_need - 1
	if ability.attacks_need == 0 then
		caster:ForceKill(false)
	else
		caster:SetHealth(ability.attacks_need)
	end
	
end

function OnCreated( event )
	local caster = event.caster
	local ability = event.ability
	local name = caster:GetUnitName()

	if name == "npc_tombstone1" then 
		ability:SetLevel(1)
	elseif name == "npc_tombstone2" then
		ability:SetLevel(2)
	elseif name == "npc_tombstone3" then
		ability:SetLevel(3)
	elseif name == "npc_tombstone4" then
		ability:SetLevel(4)
	elseif name == "npc_tombstone_flash_1" then
		ability:SetLevel(5)
	elseif name == "npc_tombstone_flash_2" then
		ability:SetLevel(5)
	elseif name == "npc_tombstone_flash_3" then
		ability:SetLevel(5)
	elseif name == "npc_tombstone_flash_4" then
		ability:SetLevel(5)
	end


	ability.attacks_need = ability:GetSpecialValueFor("attacks_need") * (Difficulter + 1)
	caster:SetBaseMaxHealth(ability.attacks_need)
	caster:SetMaxHealth(ability.attacks_need)
	caster:SetHealth(ability.attacks_need)
end
