LinkLuaModifier("modifier_cemetry","triggers/cemetry.lua", LUA_MODIFIER_MOTION_NONE)
function StartTouch( trigger )
    local ent = trigger.activator

    ent:AddNewModifier(ent, self, "modifier_cemetry", {})
end

function EndTouch( trigger )
    local ent = trigger.activator
    ent:RemoveModifierByName("modifier_cemetry")
end

-----------------------------------------------------------------------------------------

modifier_cemetry = modifier_cemetry or class({})

function modifier_cemetry:IsHidden()
    return false
end
 
function modifier_cemetry:IsPurgable()
    return false
end

function modifier_cemetry:IsDebuff()
    return true
end

 

function modifier_cemetry:OnCreated()
    if not IsServer() then return end
    self.parent = self:GetParent()
    self.duration = 60 
    self.min = 1
    self.max = 3


 
    self:StartIntervalThink( 8.0 )
end

function modifier_cemetry:OnIntervalThink()
    if IsServer() then
 
    
    local point = self.parent:GetAbsOrigin()
    local random = RandomInt(self.min,self.max)
 for i = 1,random do
        local unit = CreateUnitByName("npc_classic_half_zombie", point + RandomVector(30), true, nil, nil, DOTA_TEAM_BADGUYS)
        unit:AddNewModifier(unit, self, "modifier_kill", {duration = self.duration})
        
        unit:SetContextThink( "Think", function()
             return AttackMove( unit, self.parent ) end,
         0.1 )  
         local particle = ParticleManager:CreateParticle("particles/econ/events/ti9/shovel_dig_start.vpcf", PATTACH_ABSORIGIN, unit)
 end
 
 
    end
end
 

 function modifier_cemetry:GetTexture()
    return "night_stalker_darkness"
end  


 function AttackMove( unit, enemy )
    if enemy == nil then
        return
    end

    if not enemy:IsAlive() then 
        return 
    end
--  print("ATTACK MOVE")
    ExecuteOrderFromTable({
        UnitIndex = unit:entindex(),                --индекс кастера
        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,    -- тип приказа атака
        Position = enemy:GetOrigin(),               -- пощиция врага
        Queue = false,
    })

    return 1
end