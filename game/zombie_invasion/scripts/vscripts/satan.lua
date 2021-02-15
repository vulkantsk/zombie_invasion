 
function StartTouchDamage( trigger )
    local ent = trigger.activator
    local hItem = "item_shield_3" GetItemName()
        if ent:HasItemInInventory(hItem) then   
            ent:RemoveItem(hItem)    
        end

 
end

function EndTouch( trigger )
    local ent = trigger.activator
    ent:RemoveModifierByName("modifier_lava_damage")
end

-----------------------------------------------------------------------------------------

 