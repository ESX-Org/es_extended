-- Copyright (c) Jérémie N'gadi
--
-- All rights reserved.
--
-- Even if 'All rights reserved' is very clear :
--
--   You shall not use any piece of this software in a commercial product / service
--   You shall not resell this software
--   You shall not provide any facility to install this particular software in a commercial product / service
--   If you redistribute this software, you must link to ORIGINAL repository at https://github.com/ESX-Org/es_extended
--   This copyright should appear in every part of the project code

local Command  = M("events")
local migrate  = M('migrate')
local vehicles = M("vehicles")

on("esx:db:ready", function()
	migrate.Ensure("vehicleshop", "base")
end)

onClient('vehicleshop:updateVehicle', function(vehicleProps, plate, model)
  MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate AND model = @model', {
    ['@plate']   = plate,
    ['@model']   = model,
		['@vehicle'] = json.encode(vehicleProps)
	})
end)

onRequest("vehicleshop:checkOwnedVehicle", function(source, cb, plate)
	local player = Player.fromId(source)

	if player then
		MySQL.Async.fetchAll('SELECT model, sell_price FROM owned_vehicles WHERE plate = @plate AND id = @identityId AND owner = @owner', {
      ['@plate']      = plate,
			['@identityId'] = player:getIdentityId(),
			['@owner']      = player.identifier
    }, function(result)
      if result then
        if result[1] then
          local vehicleData = {
            model       = result[1].model,
            resellPrice = result[1].sell_price
          }

				  cb(vehicleData)
				else
					cb(false)
				end
			else
				cb(false)
			end
		end)
	else
		cb(false)
	end
end)

onRequest("vehicleshop:buyVehicle", function(source, cb, model, plate, price, formattedPrice, vehicleName, name, resellPrice)
	local player = Player.fromId(source)
	local playerData = player:getIdentity()
	local foundVehicle = false

	if player then
		MySQL.Async.execute('INSERT INTO owned_vehicles (id, owner, plate, model, sell_price, vehicle) VALUES (@id, @owner, @plate, @model, @sell_price, @vehicle)', {
			['@id']         = player:getIdentityId(),
			['@owner']      = player.identifier,
			['@plate']      = plate,
			['@model']      = model,
			['@sell_price'] = resellPrice,
			['@vehicle']    = json.encode({model = GetHashKey(model), plate = plate}),
		}, function(rowsChanged)
			print("^7[^4" .. player:getIdentityId() .. "^7/^5" .. playerData:getFirstName() .. " " .. playerData:getLastName() .. "^7] ^3bought^7: ^5" .. name .. "^7 with the plates ^3" .. plate .. " ^7for ^2$" .. tostring(formattedPrice) .. "^7")
			cb(true)
		end)
	else
		cb(false)
	end
end)

onRequest("vehicleshop:sellVehicle", function(source, cb, plate, name, resellPrice, formattedPrice)
	local player = Player.fromId(source)
	local playerData = player:getIdentity()

	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
  }, function(rowsChanged)
    print("^7[^4" .. player:getIdentityId() .. "^7/^5" .. playerData:getFirstName() .. " " .. playerData:getLastName() .. "^7] ^3sold^7: ^5" .. name .. "^7 with the plates ^3" .. plate .. " ^7for ^2$" .. tostring(formattedPrice) .. "^7")
		cb(true)
	end)
end)

onRequest("vehicleshop:isPlateTaken", function(source, cb, plate, plateUseSpace, plateLetters, plateNumbers)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
  }, function(result)

    if result[1] then
      print(true)
      cb(true)
    else
      if module.excessPlateLength(plate, plateUseSpace, plateLetters, plateNumbers) then
        cb(true)
      else
        cb(false)
      end
    end
	end)
end)

onRequest("vehicleshop:getCategories", function(source, cb)
  module.cache.categories = vehicles.getCategories()

  cb(module.cache.categories)
end)

onRequest("vehicleshop:getVehicles", function(source, cb)
  module.cache.vehicles   = vehicles.getVehicles()

  cb(module.cache.vehicles)
end)