item_color_fuchsia = class ({})

function item_color_fuchsia:OnSpellStart()
	local caster = self:GetCaster()
	self:SpendCharge()
	caster:SetRenderColor(255, 0 , 255 )
end