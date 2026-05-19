item_book_of_heroes = class({})

function item_book_of_heroes:Precache(context)
	PrecacheAbilityResources({
	}, {
		"DOTA_Item.Cheese.Activate",
	}, context)
end


function item_book_of_heroes:OnSpellStart()
     local caster = self:GetCaster()
     local hero = caster:GetUnitName()
     local hItem = self
     if caster:GetLevel() >= 25 then
         caster:EmitSound("DOTA_Item.Cheese.Activate")
         caster:AddItemByName("item_"..hero)
         if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
            UTIL_Remove(hItem)
            return
         end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
     end
end 

function item_book_of_heroes:CastFilterResult()
    --print("Error")
    if IsServer() then

        
        if (self:GetCaster():GetLevel() < 25) then
            return UF_FAIL_CUSTOM
        end


        return UF_SUCCESS
    end
end

function item_book_of_heroes:GetCustomCastError()
    --print("Error")
    if IsServer() then
        


        if (self:GetCaster():GetLevel() < 25) then
            return "#dota_hud_error_not_your_level"
        end

        return UF_SUCCESS
    end
end