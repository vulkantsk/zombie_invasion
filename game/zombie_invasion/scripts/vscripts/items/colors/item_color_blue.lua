item_color_blue = class ({})

function item_color_blue:OnSpellStart()
	local caster = self:GetCaster()
	self:SpendCharge()
	caster:SetRenderColor(0, 0 , 255 )
end