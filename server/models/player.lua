Adame.Players = {}
local player = {}
setmetatable(Adame.Players, player)

player.__index = player

-- Creates player metadata

player.setData = function(source, identifier, chardid, jobs, group, accounts, inventory, status, appearance)
	local self = {}
	self.source = source
	self.identifier = identifier
	self.charid = chardid
	self.jobs = jobs
	self.group = group
	self.accounts = accounts
	self.inventory = inventory
	self.status = status
	self.appearance = appearance

	Players[self.source] = self
	return setmetatable(self, getmetatable(Players))
end

-- Return source
function player:getSource()
	return self.source
end

---Returns the identifier from argument
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

exports("get", function()
	return Adame
end)