LinkLuaModifier("modifier_sell", "vscripts/blackshop/blackshop", LUA_MODIFIER_MOTION_NONE)



item_for_sell = class({})

function modifier_sell:IsHidden() return false end
function modifier_sell:IsPurgable() return false end
function modifier_sell:RemoveOnDeath() return false end

sell_uncommon = class({})

function sell_uncommon:IsHidden() return false end
function sell_uncommon:IsPurgable() return false end
function sell_uncommon:RemoveOnDeath() return false end


function sell_uncommon:OnSpellStart()
	caster = self:GetCaster()
	gold = caster:GetGold()
	if gold == HasGoldUncommon() then
		
	end

end

