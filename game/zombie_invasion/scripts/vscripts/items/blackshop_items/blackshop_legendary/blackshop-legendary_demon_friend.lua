LinkLuaModifier( "modifier_blackshop_legendary_demon_friend", "items/blackshop_items/blackshop_legendary/blackshop-legendary_demon_friend", LUA_MODIFIER_MOTION_NONE )
item_blackshop_legendary_demon_friend = class({})
function item_blackshop_legendary_demon_friend:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    
    -- Создаем нового демона
    local demon = CreateUnitByName("npc_dota_demon_friend", self.caster:GetAbsOrigin() + RandomVector(100), true, self.caster, self.caster, self.caster:GetTeamNumber())
    demon:SetOwner(self.caster)
    demon:SetBaseAttackTime(self.caster:GetBaseAttackTime())
    demon:SetBaseDamageMin(self.caster:GetBaseDamageMin() + 550)
    demon:SetBaseDamageMax(self.caster:GetBaseDamageMax() + 550)
    demon:SetBaseMoveSpeed(self.caster:GetBaseMoveSpeed() + 125)

    demon:AddNewModifier(self.caster, nil, "modifier_blackshop_legendary_demon_friend", {})
    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        UTIL_Remove(hItem)
        return
    end
    hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end

-- Модификатор для демона
modifier_blackshop_legendary_demon_friend = class({})

function modifier_blackshop_legendary_demon_friend:OnCreated()
    if IsServer() then
        self:StartIntervalThink(0.1)
        self:OnIntervalThink()
    end
end

function modifier_blackshop_legendary_demon_friend:OnIntervalThink()
    if IsServer() then
        local parent = self:GetParent()
        local caster = self:GetCaster()
        
        -- Проверяем жив ли кастер
        if not caster:IsAlive() then
            parent:AddNoDraw() -- Скрываем демона
            parent:Stop() -- Останавливаем все действия
            parent:MoveToPosition(parent:GetAbsOrigin()) -- Останавливаем движение
            return
        else
            parent:RemoveNoDraw() -- Показываем демона
        end
        
        parent:SetBaseAttackTime(caster:GetBaseAttackTime())
        parent:SetBaseDamageMin(caster:GetBaseDamageMin() + 550)
        parent:SetBaseDamageMax(caster:GetBaseDamageMax() + 550)
        parent:SetBaseMoveSpeed(caster:GetBaseMoveSpeed() + 125)  
        
        -- Следование за владельцем
        local distanceToCaster = (parent:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
        if distanceToCaster > 300 then
            parent:MoveToPosition(caster:GetAbsOrigin() + RandomVector(200))
        end
        
        -- Поиск и атака ближайших врагов только если рядом с кастером и кастер жив
        if distanceToCaster <= 300 and caster:IsAlive() then
            local enemies = FindUnitsInRadius(parent:GetTeamNumber(),
                parent:GetAbsOrigin(),
                nil,
                800,
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
                DOTA_UNIT_TARGET_FLAG_NONE,
                FIND_CLOSEST,
                false)
                
            if #enemies > 0 then
                -- Заставляем врага атаковать владельца
                enemies[1]:MoveToTargetToAttack(caster)
                parent:MoveToTargetToAttack(enemies[1])
            end
        end
    end
end

function modifier_blackshop_legendary_demon_friend:CheckState()
    return {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_INVULNERABLE] = true
    }
end