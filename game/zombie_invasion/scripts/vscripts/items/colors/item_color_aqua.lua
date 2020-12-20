item_color_aqua = class ({})

function item_color_aqua:OnSpellStart()
	local caster = self:GetCaster()
	self:SpendCharge()
	caster:SetRenderColor(0, 255 , 255 )
end