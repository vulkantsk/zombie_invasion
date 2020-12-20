item_color_yellow = class ({})

function item_color_yellow:OnSpellStart()
	local caster = self:GetCaster()
	self:SpendCharge()
	caster:SetRenderColor(255, 255 , 0 )
end