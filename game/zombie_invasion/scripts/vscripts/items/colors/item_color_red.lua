item_color_red = class ({})

function item_color_red:OnSpellStart()
	local caster = self:GetCaster()
	self:SpendCharge()
	caster:SetRenderColor(255, 62 , 67 )
end