LinkLuaModifier( "modifier_gold_attack_buff", "items/new_items/item_midas_boots", LUA_MODIFIER_MOTION_NONE )

item_midas_boots = class({})

function item_midas_boots:OnSpellStart()
 	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local gold = self:GetSpecialValueFor("gold")
	caster:EmitSound("DOTA_Item.ArcaneBoots.Activate")
	local pfx = ParticleManager:CreateParticle("particles/midas_boots.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)  
	ParticleManager:ReleaseParticleIndex(pfx)
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(allies) do
		ally:SetGold(caster:GetGold() + gold, false )
        --ally:AddNewModifier(caster, self, "modifier_gold_attack_buff",  {duration = self:GetSpecialValueFor( "duration" )})
		ParticleManager:CreateParticle("particles/midas_boots_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
	end


end

modifier_gold_attack_buff = class({})

function modifier_gold_attack_buff:IsDebuff() return false end
function modifier_gold_attack_buff:IsHidden() return true end
function modifier_gold_attack_buff:IsPurgable() return false end
function modifier_gold_attack_buff:RemoveOnDeath() 	return true end

function modifier_gold_attack_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_gold_attack_buff:OnAttackLanded()
	local parent = self:GetParent()
		if params.attacker == parent and ( not caster:IsIllusion() ) then return 
			parent:SetGold(parent:GetGold() + 45, false )
			end
end