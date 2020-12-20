LinkLuaModifier("modifier_tb_astral", "heroes/hero_tb/tb_astral", LUA_MODIFIER_MOTION_NONE)

tb_astral = class ({})

function tb_astral:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "illusion_duration" )
	local outgoing = self:GetSpecialValueFor( "illusion_outgoing_damage" )
	local incoming = self:GetSpecialValueFor( "illusion_incoming_damage" )
	local distance = 200
	local ability = self
	local illusions = CreateIllusions(
		caster,
		caster,
		{
			outgoing_damage = outgoing,
			incoming_damage = incoming,
			duration = duration,
		},
		1,
		distance,
		false,
		true
		)
	local illusion = illusions[1]
	illusion:SetRenderColor(0, 0, 0)
    caster:AddNewModifier(caster, ability, "modifier_tb_astral", {duration = self:GetSpecialValueFor("buff_duration")})
end

modifier_tb_astral = class({})

function modifier_tb_astral:CheckState() 
  local state = {
      [MODIFIER_STATE_INVULNERABLE] = true,
      [MODIFIER_STATE_DISARMED] = true,
  }

  return state
end

function modifier_tb_astral:IsHidden()
    return false
end
