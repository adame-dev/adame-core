Adame.Players = {}
local player = {}
setmetatable(Adame.Players, player)

local encode = json.encode

player.__index = player

-- Creates player metadata

Adame.SetData = function(source, identifier, jobs, group, accounts, inventory, status, appearance, char_data)
	local self = {}
	self.source = source
	self.identifier = identifier
	self.jobs = jobs
	self.group = group
	self.accounts = accounts
	self.inventory = inventory
	self.status = status
	self.appearance = appearance
	self.char_data = char_data

	Adame.Players[self.source] = self
	return setmetatable(self, getmetatable(Adame.Players))
end

function player:getSource()
	return self.source
end

function player:savePlayer()
	local ped = GetPlayerPed(self.source)

	local coords, heading = GetEntityCoords(ped), GetEntityHeading(ped)
	self:updateCoords(vector4(coords, heading))

	Adame.Database.updateOne(true, "users", { license = self.identifier }, {
		["$set"] = {
			accounts = encode(self.Accounts),
			appearance = encode(self.appearance),
			status = encode(self.status),
			inventory = encode(self.inventory),
			job_data = encode(self.jobs),
			char_data = encode(self.char_data),
		},
	})
end

function player:getIdentifier(identifier)
	local identifiers = self.identifiers
	local matchingIdentifier = not not identifier and identifier or "license:"
	for i = 1, #identifiers do
		if identifiers[i]:match(matchingIdentifier) then
			return identifiers[i]
		end
	end
	return "No matching identifier: " .. tostring(matchingIdentifier)
end

function player:setGroup(group)
	if not group then
		return
	end
	self.group = group
end

function player:updateCoords(coords, now)
	if type(coords) ~= "vector4" then
		return false
	end
	if now then
		local ped = GetPlayerPed(self.source)
		SetEntityCoords(ped, coords.x, coords.y, coords.z)
		SetEntityHeading(ped, coords.w)
	end

	self.char_data.coords = vec4(coords)
	return true
end

exports("get", function()
	return Adame
end)
