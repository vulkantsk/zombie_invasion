
LinkLuaModifier( "modifier_greevil", "abilities/zombie/greevil", LUA_MODIFIER_MOTION_NONE )

greevil = class ({})

function greevil:GetIntrinsicModifierName()
	return "modifier_greevil"
end


modifier_greevil = class({})

function modifier_greevil:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,

    }
    return funcs
end

function modifier_greevil:RemoveOnDeath()
    return true
end

function modifier_greevil:IsHidden()
    return false
end

function modifier_greevil:OnCreated()
	if IsServer() then
		self:StartIntervalThink(45)
	end
	local caster = self:GetCaster()
	local dick = {
	victim = caster,
	attacker = caster,
	damage = 1000,
	damage_type = DAMAGE_TYPE_PURE,
}
ApplyDamage(dick)
end
function modifier_greevil:OnTakeDamage( params )
	if IsServer() then
		local hUnit = params.unit
		local hAttacker = params.attacker
		local parent = self:GetParent()
		if hAttacker == nil or hAttacker:IsBuilding() then
			return 0
		end
		
		if not parent.damage_cap then
			parent.damage_cap = 0
		end
		
		if hUnit == parent then
			local damage = params.damage
			local ability = self:GetAbility()
			local dmg_proc = 30000 
			local parent_maxhealth = parent:GetMaxHealth()
			if damage >= parent_maxhealth then
				damage = parent_maxhealth
			end

			parent.damage_cap = parent.damage_cap + damage
			local stacks = math.floor(parent.damage_cap/dmg_proc)
			if stacks > 0 then 
				parent.damage_cap = parent.damage_cap - stacks*dmg_proc
				local modifier = "modifier_greevil"
				A = parent:GetModifierStackCount(modifier, ability)
				
				parent:SetModifierStackCount(modifier, ability, (A + stacks))
			end
				
		end
	end
end

function modifier_greevil:OnIntervalThink()
	local caster = self:GetCaster()	
	caster:ForceKill(true)
end

function greevil:OnOwnerDied()
	local caster = self:GetCaster()
	local caster_position = caster:GetAbsOrigin()
		for i = 0, A do
	if RollPercentage(16) then
		item = "item_bonus_health1"
	elseif RollPercentage(20) then
		item = "item_bonus_damage1"
	elseif RollPercentage(25) then
		item = "item_bonus_mana_regen1"
	elseif RollPercentage(33) then
		item = "item_bonus_spell1"
	elseif RollPercentage(50) then
		item = "item_bonus_mana1"
	else
		item = "item_bonus_health_regen1"								
	end
		local newItem = CreateItem( item, nil, nil )	
		local drop = CreateItemOnPositionForLaunch( caster_position, newItem )
		local dropRadius = RandomFloat( 50, 200 )
		newItem:LaunchLootInitialHeight( false, 0, 400, 0.5, caster_position + RandomVector( dropRadius ) )
	end
end