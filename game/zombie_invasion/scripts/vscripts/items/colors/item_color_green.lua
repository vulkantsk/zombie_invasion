item_color_green = class ({})

function item_color_green:OnSpellStart()
	local caster = self:GetCaster()
	self:SpendCharge()
	caster:SetRenderColor(0, 255 , 0 )
end