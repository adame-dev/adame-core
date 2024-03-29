local guiEnabled, hasIdentity = false, false
local myIdentity, myIdentifiers = {}, {}

function EnableGui(state)
	SetNuiFocus(state, state)
	guiEnabled = state

	SendNUIMessage({
		type = "enableui",
		enable = state,
	})
end

function showRegisterIdentity()
	EnableGui(true)
end

RegisterNetEvent("adame-identity:identityCheck")
AddEventHandler("adame-identity:identityCheck", function(identityCheck)
	hasIdentity = identityCheck
end)

RegisterNUICallback("escape", function(data, cb)
	if hasIdentity then
		EnableGui(false)
	else
		TriggerEvent("notifications", "#ff4040", "You need a character to play.")
	end
end)

RegisterNUICallback("register", function(data, cb)
	local reason = ""
	myIdentity = data
	for theData, value in pairs(myIdentity) do
		if theData == "firstname" or theData == "lastname" then
			reason = verifyName(value)

			if reason ~= "" then
				break
			end
		elseif theData == "dateofbirth" then
			if value == "invalid" then
				reason = "Invalid date of birth!"
				break
			end
		elseif theData == "height" then
			local height = tonumber(value)
			if height then
				if height > 200 or height < 140 then
					reason = "Unacceptable player height!"
					break
				end
			else
				reason = "Unacceptable player height!"
				break
			end
		end
	end

	if reason == "" then
		TriggerServerEvent("adame-identity:setIdentity", data)
		EnableGui(false)

		print(Server.Spawn.coords.x, Server.Spawn.coords.y, Server.Spawn.coords.z)
		SetEntityCoords(PlayerPedId(), Server.Spawn.coords.x, Server.Spawn.coords.y, Server.Spawn.coords.z)
		SetEntityHeading(PlayerPedId(), Server.Spawn.coords.w)
		Wait(500)

		-- TriggerEvent('esx_skin:openSaveableMenu', myIdentifiers.id)
	else
		print(reason)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if guiEnabled then
			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30, true) -- MoveLeftRight
			DisableControlAction(0, 31, true) -- MoveUpDown
			DisableControlAction(0, 21, true) -- disable sprint
			DisableControlAction(0, 24, true) -- disable attack
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(0, 47, true) -- disable weapon
			DisableControlAction(0, 58, true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75, true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function verifyName(name)
	local nameLength = string.len(name)
	if nameLength > 25 or nameLength < 2 then
		return "Your name is either too long or too short"
	end

	local count = 0
	for i in name:gmatch("[abcdefghijklmnopqrstuvwxyzåäöABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖ0123456789 -]") do
		count = count + 1
	end
	if count ~= nameLength then
		return "Your name contains illegal characters"
	end

	local spacesInName = 0
	local spacesWithUpper = 0
	for word in string.gmatch(name, "%S+") do
		if string.match(word, "%u") then
			spacesWithUpper = spacesWithUpper + 1
		end

		spacesInName = spacesInName + 1
	end

	if spacesInName > 2 then
		return "Your name contains more than one space"
	end

	if spacesWithUpper ~= spacesInName then
		return "Your name must start with a capital letter"
	end

	return ""
end

RegisterNetEvent("adame-identity:showRegisterIdentity", showRegisterIdentity)

RegisterCommand("register", function()
	TriggerEvent("adame-identity:showRegisterIdentity", source)
end)
