--[My First Lua Expirience]
function SetCamera(keys)
	local caster = keys.caster
	local target = keys.target
	local targetID = target:GetPlayerID()
	PlayerResource:SetCameraTarget(targetID, caster)
end

function UnsetCamera(keys)
	local caster = keys.caster
	local target = keys.target
	local targetID = target:GetPlayerID()
	PlayerResource:SetCameraTarget(targetID, nil)
end