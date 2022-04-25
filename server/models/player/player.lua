Adame.Players = {}
local player = {}
setmetatable(Adame.Players, player)

local encode = json.encode

player.__index = player

-- Creates player metadata

Adame.SetData = function(
	source,
	identifier,
	name,
	jobs,
	group,
	accounts,
	inventory,
	status,
	appearance,
	char_data,
	char_name,
	char_sex,
	char_date,
	char_height
)
	local self = {}
	self.source = source
	self.identifier = identifier
	self.name = name
	self.jobs = jobs
	self.group = group
	self.accounts = accounts
	self.inventory = inventory
	self.status = status
	self.appearance = appearance
	self.char_data = char_data
	self.char_name = char_name
	self.char_sex = char_sex
	self.char_date = char_date
	self.char_height = char_height

	Adame.Players[self.source] = self
	return setmetatable(self, getmetatable(Adame.Players))
end

-- @Getters

function player:getSource()
	return self.source
end

function player:getName()
	return self.name
end

function player:getCharacterName()
	return {
		self.char_name.firstname,
		self.char_name.lastname,
	}
end

function player:hasPermission(group)
	if not Server.Groups[group] then
		return false
	end
	return Server.Groups[self.group] >= Server.Groups[group]
end

function player:savePlayer()
	local ped = GetPlayerPed(self.source)

	local coords, heading = GetEntityCoords(ped), GetEntityHeading(ped)
	self:updateCoords(vector4(coords, heading))

	Adame.Database.updateOne(true, "users", { license = self.identifier }, {
		["$set"] = {
			accounts = encode(self.accounts),
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

-- @Setters

function player:setGroup(group)
	if not group then
		return
	end
	self.group = group
end

function player:updateCharacter(char_data)
	self.char_name = char_data.char_name
	self.char_sex = char_data.char_sex
	self.char_date = char_data.char_date
	self.char_height = char_data.char_height
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
