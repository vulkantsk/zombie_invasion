LinkLuaModifier( "modifier_main_pumpkin", "abilities/halloween/main_pumpkin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_main_pumpkin_2", "abilities/halloween/main_pumpkin", LUA_MODIFIER_MOTION_NONE )

 LinkLuaModifier( "modifier_halloween_experience", "modifiers/halloween/modifier_halloween", LUA_MODIFIER_MOTION_NONE )
 LinkLuaModifier( "modifier_halloween_spell", "modifiers/halloween/modifier_halloween", LUA_MODIFIER_MOTION_NONE )
 LinkLuaModifier( "modifier_halloween_damage", "modifiers/halloween/modifier_halloween", LUA_MODIFIER_MOTION_NONE )
 LinkLuaModifier( "modifier_halloween_health", "modifiers/halloween/modifier_halloween", LUA_MODIFIER_MOTION_NONE )
 LinkLuaModifier( "modifier_halloween_magic_resist", "modifiers/halloween/modifier_halloween", LUA_MODIFIER_MOTION_NONE )
 LinkLuaModifier( "modifier_halloween_gold", "modifiers/halloween/modifier_halloween", LUA_MODIFIER_MOTION_NONE )

 
main_pumpkin = {}

function main_pumpkin:GetIntrinsicModifierName()
    return "modifier_main_pumpkin"
end

 

modifier_main_pumpkin = {}

--------------------------------------------------------------------------------
-- Classifications
 function modifier_main_pumpkin:IsHidden()
    return true
 end

 
      local canmod = 0
 
   local modifier_list = {

         ["expmodifier"] = 0,
         ["goldmodifier"] = 0,
         ["healthmodifier"] = 0,
         ["magicmodifier"] = 0,
         ["damagemodifier"] = 0,                                             
         ["magdamagemodifier"] = 0,     
    };

function modifier_main_pumpkin:OnIntervalThink(enemy)

if not IsServer() then return end
        
    local modifier = self:GetCaster():FindModifierByName("modifier_item_candy")
    local candy = modifier:GetStackCount()

 
 
 local keys = {} 
for k,_ in pairs(modifier_list) do
table.insert(keys, k)
end
local random_key = keys[RandomInt(1, #keys)]
 
        -- perform attack
 
        if candy%15 == 0 and canmod == 0 then 
                 modifier_list[random_key] = modifier_list[random_key] + 1
                 canmod = canmod + 1
        elseif candy%15 > 0 and canmod == 1 then 
            canmod = canmod - 1
        end 
 
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_main_pumpkin:OnCreated( kv )
    -- references

        self:StartIntervalThink( 0.02 )

end

 
modifier_main_pumpkin_2 = {}

--------------------------------------------------------------------------------
-- Classifications
 function modifier_main_pumpkin_2:IsHidden()
    return true
 end


function modifier_main_pumpkin_2:OnIntervalThink(enemy)

if not IsServer() then return end
      
            local units = FindUnitsInRadius(
            DOTA_TEAM_GOODGUYS,
            self:GetCaster():GetAbsOrigin(),
            nil,
            -1,
            DOTA_UNIT_TARGET_TEAM_BOTH,
            DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_DEAD  + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
            FIND_CLOSEST,
            false
        )
     local  unit = units[1]
     
 
 
                  
           
 
    local modifier = self:GetCaster():FindModifierByName("modifier_item_candy")
    local candy = modifier:GetStackCount()


 
 

        for _,unit in pairs(units) do

        -- perform attack
            if modifier_list.expmodifier > 0 then 
                if not unit:HasModifier("modifier_halloween_experience") then 
                      unit:AddNewModifier(self:GetCaster(), self, "modifier_halloween_experience", {  })
                      unit:SetModifierStackCount("modifier_halloween_experience", self, (modifier_list.expmodifier))
                 else 
                      unit:SetModifierStackCount("modifier_halloween_experience", self, (modifier_list.expmodifier))
                end
            end

            if modifier_list.goldmodifier > 0 then 
                if not unit:HasModifier("modifier_halloween_gold") then 
                      unit:AddNewModifier(self:GetCaster(), self, "modifier_halloween_gold", {  })
                      unit:SetModifierStackCount("modifier_halloween_gold", self, (modifier_list.goldmodifier))
                 else 
                      unit:SetModifierStackCount("modifier_halloween_gold", self, (modifier_list.goldmodifier))
                end
            end

            if modifier_list.healthmodifier > 0 then 
                if not unit:HasModifier("modifier_halloween_health") then 
                      unit:AddNewModifier(self:GetCaster(), self, "modifier_halloween_health", {  })
                      unit:SetModifierStackCount("modifier_halloween_health", self, (modifier_list.healthmodifier))
                 else 
                      unit:SetModifierStackCount("modifier_halloween_health", self, (modifier_list.healthmodifier))
                end
            end

            if modifier_list.magicmodifier > 0 then 
                if not unit:HasModifier("modifier_halloween_magic_resist") then 
                      unit:AddNewModifier(self:GetCaster(), self, "modifier_halloween_magic_resist", {  })
                      unit:SetModifierStackCount("modifier_halloween_magic_resist", self, (modifier_list.magicmodifier))
                 else 
                      unit:SetModifierStackCount("modifier_halloween_magic_resist", self, (modifier_list.magicmodifier))
                end
            end

            if modifier_list.damagemodifier > 0 then 
                if not unit:HasModifier("modifier_halloween_damage") then 
                      unit:AddNewModifier(self:GetCaster(), self, "modifier_halloween_damage", {  })
                      unit:SetModifierStackCount("modifier_halloween_damage", self, (modifier_list.damagemodifier))
                 else 
                      unit:SetModifierStackCount("modifier_halloween_damage", self, (modifier_list.damagemodifier))
                end
            end

            if modifier_list.magdamagemodifier > 0 then 
                if not unit:HasModifier("modifier_halloween_spell") then 
                      unit:AddNewModifier(self:GetCaster(), self, "modifier_halloween_spell", {  })
                      unit:SetModifierStackCount("modifier_halloween_spell", self, (modifier_list.magdamagemodifier))
                 else 
                      unit:SetModifierStackCount("modifier_halloween_spell", self, (modifier_list.magdamagemodifier))
                end
            end
       end
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_main_pumpkin_2:OnCreated( kv )
    -- references

        self:StartIntervalThink( 0.2 )

end
 
 
modifier_main_pumpkin_hero = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
 
       
        } end,

})
--------------------------------------------------------------------------------
-- Classifications

function modifier_main_pumpkin_hero:OnIntervalThink(enemy)

if not IsServer() then return end
if Halloween_boss == 1 then 
     if not self:GetParent():HasModifier("modifier_sumon_boss_fight") then 
   local unit = self:GetParent()
   local ent= Entities:FindByName( nil, "skelet_boss_sumon") -- вот та сама точка, куда мы будем телепортировать героя, мы её указали в скрипте

   local point = ent:GetAbsOrigin() --эта строка выясняет где находится pnt1 и получает её координаты
   self:GetParent():SetAbsOrigin( point ) -- получили координаты, теперь меняем место героя на pnt1
   FindClearSpaceForUnit(self:GetParent(), point, false) --нужно чтобы герой не застрял
   self:GetParent():Stop() --приказываем ему остановиться, иначе он побежит назад к предыдущей точке
    end 
end
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_main_pumpkin_hero:OnCreated( kv )
    -- references

        self:StartIntervalThink( 0.2 )

end

 
 
