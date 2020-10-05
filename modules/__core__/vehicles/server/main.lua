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

M('command')

local reloadVehiclesCommand = Command("reloadVehicles", "admin", "Reload the vehicle server cache")

reloadVehiclesCommand:setHandler(function(player, args, baseArgs)
  module.reloadVehicles()
end)
    
reloadVehiclesCommand:setRconAllowed(true)
    
reloadVehiclesCommand:register()