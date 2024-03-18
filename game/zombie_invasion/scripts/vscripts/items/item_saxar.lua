 if item_saxar == nil then
	item_saxar = class({})
 
end

local saxar2 = 1
 function sucka()
 saxar2 = saxar2 + 1
 
end

function item_saxar:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local hItem = self
	local itemName = self:GetAbilityName()
	local newItem = nil
    sucka()
	if saxar2 == 2 then
        GameRules:SendCustomMessage("<font color='#fffacd'>Ты чуть-чуть  рассыпал сахар.</font>", 0, 0)
    end
	if saxar2 == 3 then
        GameRules:SendCustomMessage("<font color='#fffacd'>Ты еще чуть-чуть  рассыпал сахар..</font>", 0, 0)
    end
    if saxar2 == 4 then
 
        GameRules:SendCustomMessage("<font color='#fffacd'>Ты рассыпал сахар...</font>", 0, 0)
		UTIL_Remove(hItem)
    end
 
end
    

