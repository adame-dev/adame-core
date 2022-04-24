Adame.Database = {}


Adame.Database.findOne = function(wait, c, q, cb)
    if not wait then
        exports.mongodb:findOne({ collection=c, query = q }, cb)
    end

    if wait then
        exports.mongodb:findOne({ collection=c, query = q }, cb)
        
        Citizen.Wait(5)
    end
end

Adame.Database.insertOne = function(wait, c, q, cb)
    if not wait then
        exports.mongodb:insertOne({ collection=c, document = q }, cb)
    end

    if wait then
        exports.mongodb:insertOne({ collection=c, document = q }, cb)
        
        Citizen.Wait(5)
    end
end


Adame.Database.deleteOne = function(wait, c, q, cb)
    if not wait then
        exports.mongodb:deleteOne({ collection=c, document = q }, cb)
    end

    if wait then
        exports.mongodb:deleteOne({ collection=c, document = q }, cb)
        
        Citizen.Wait(5)
    end
end

Adame.Database.updateOne = function(wait, c, q, cb)
    if not wait then
        exports.mongodb:updateOne({ collection=c, query = q, update = cb })
    end
    if wait then
        exports.mongodb:updateOne({ collection=c, query = q, update = cb })
        
        Citizen.Wait(5)
    end
end