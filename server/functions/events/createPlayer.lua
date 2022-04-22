local function createPlayer()
    local src <const> = source 
    Adame.GetLicense(src, function (license)
        TriggerClientEvent("adame:client:spawnPlayer", src)
    end)
end


RegisterNetEvent("adame:server:createPlayer", createPlayer)