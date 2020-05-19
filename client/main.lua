local isLoadoutLoaded, isPaused, pickups = false, false, {}

Citizen.CreateThread(function()

  AddTextEntry('FE_THDR_GTAO', 'ESX')

  local logLoopError = function(err)
    ESX.LogLoopError(name, err)
  end

  local runLoop = function(name, loop)

    local conditionsMet = true

    for j=1, #loop.conditons, 1 do
      if not loop.conditons[j]() then
        conditionsMet = false
        break
      end
    end

    if conditionsMet then

      ESX.LoopsRunning[name] = true

      Citizen.CreateThread(function()
        while true do

          local tests = #loop.conditons

          for i=1, #loop.conditons, 1 do

            if not loop.conditons[i]() then
              break
            end

            tests = tests - 1

          end

          if tests > 0 then
            ESX.LoopsRunning[name] = false
            return
          end

          local status, result = xpcall(loop.func, logLoopError)

          if not status then
            ESX.Loops[name]        = nil
            ESX.LoopsRunning[name] = false
            return
          end

          Citizen.Wait(loop.wait)

        end
      end)

    end

  end

  while true do

    for name, loop in pairs(ESX.Loops) do

      if ESX.LoopsRunning[name] ~= true then
        local status, result = xpcall(runLoop, ESX.LogError, name, loop)
      end

    end

    Citizen.Wait(250)

  end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsPlayerActive(PlayerId()) then
			TriggerServerEvent('esx:onPlayerJoined')
			break
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)

  ESX.PlayerLoaded = true
	ESX.PlayerData = playerData

	local playerPed = PlayerPedId()

	if Config.EnablePvP then
		SetCanAttackFriendly(playerPed, true, false)
		NetworkSetFriendlyFireOption(true)
	end

	if Config.EnableHud then
		for k,v in ipairs(playerData.accounts) do
			local accountTpl = '<div><img src="img/accounts/' .. v.name .. '.png"/>&nbsp;{{money}}</div>'
			ESX.UI.HUD.RegisterElement('account_' .. v.name, k, 0, accountTpl, {money = ESX.Math.GroupDigits(v.money)})
		end

		local jobTpl = '<div>{{job_label}} - {{grade_label}}</div>'

		if playerData.job.grade_label == '' or playerData.job.grade_label == playerData.job.label then
			jobTpl = '<div>{{job_label}}</div>'
		end

		ESX.UI.HUD.RegisterElement('job', #playerData.accounts, 0, jobTpl, {
			job_label = playerData.job.label,
			grade_label = playerData.job.grade_label
		})
	end

	-- Bringing back spawnmanager, see commit of Smallo92 at https://github.com/extendedmode/extendedmode/commit/9979c204f1237091e94fdd46580c9e7ebc79bca7
	exports.spawnmanager:spawnPlayer({
		x        = playerData.coords.x,
		y        = playerData.coords.y,
		z        = playerData.coords.z,
		heading  = playerData.coords.heading,
		model    = 'mp_m_freemode_01',
		skipFade = false
	}, function()

		TriggerServerEvent('esx:onPlayerSpawn')
		TriggerEvent('esx:onPlayerSpawn')
		TriggerEvent('esx:restoreLoadout')

		-- Re add wait so that player is loaded before loading screen shuts down, and support for custom loading screens
		Citizen.Wait(4000)
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()

	end)

	-- Add loading screen off event for when spawning is finished. (ArkSeyonet)
	Citizen.Wait(5000)
	TriggerEvent('esx:loadingScreenOff')

end)

RegisterNetEvent('esx:setMaxWeight')
AddEventHandler('esx:setMaxWeight', function(newMaxWeight) ESX.PlayerData.maxWeight = newMaxWeight end)

AddEventHandler('esx:onPlayerSpawn', function() ESX.IsDead = false end)
AddEventHandler('esx:onPlayerDeath', function() ESX.IsDead = true end)
AddEventHandler('skinchanger:loadDefaultModel', function() isLoadoutLoaded = false end)

AddEventHandler('skinchanger:modelLoaded', function()

  while not ESX.PlayerLoaded do
		Citizen.Wait(100)
	end

  TriggerEvent('esx:restoreLoadout')

end)

AddEventHandler('esx:restoreLoadout', function()

  local playerPed = PlayerPedId()
	local ammoTypes = {}

	RemoveAllPedWeapons(playerPed, true)

	for k,v in ipairs(ESX.PlayerData.loadout) do
		local weaponName = v.name
		local weaponHash = GetHashKey(weaponName)

		GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
		SetPedWeaponTintIndex(playerPed, weaponHash, v.tintIndex)

		local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

		for k2,v2 in ipairs(v.components) do
			local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash

			GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
		end

		if not ammoTypes[ammoType] then
			AddAmmoToPed(playerPed, weaponHash, v.ammo)
			ammoTypes[ammoType] = true
		end
	end

	isLoadoutLoaded = true
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for k,v in ipairs(ESX.PlayerData.accounts) do
		if v.name == account.name then
			ESX.PlayerData.accounts[k] = account
			break
		end
	end

	if Config.EnableHud then
		ESX.UI.HUD.UpdateElement('account_' .. account.name, {
			money = ESX.Math.GroupDigits(account.money)
		})
	end
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count, showNotification)

  for k,v in ipairs(ESX.PlayerData.inventory) do
    if v.name == item then

      if v.type == 'item_weapon' then
        ESX.UI.ShowInventoryItemNotification(true, ESX.GetWeaponLabel(v.name), count - v.count)
      else
        ESX.UI.ShowInventoryItemNotification(true, v.label, count - v.count)
      end

			ESX.PlayerData.inventory[k].count = count
			break
		end
	end

	if showNotification then
		ESX.UI.ShowInventoryItemNotification(true, item, count)
	end

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, showNotification)
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item then

      if v.type == 'item_weapon' then
        ESX.UI.ShowInventoryItemNotification(false, ESX.GetWeaponLabel(v.name), count - v.count)
      else
        ESX.UI.ShowInventoryItemNotification(false, v.label, math.abs(count - v.count))
      end

			ESX.PlayerData.inventory[k].count = count
			break
		end
	end

	if showNotification then
		ESX.UI.ShowInventoryItemNotification(false, item, count)
	end

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

  GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)

  ESX.UI.ShowInventoryItemNotification(true, ESX.GetWeaponLabel(weaponName), 1)

end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:setWeaponAmmo')
AddEventHandler('esx:setWeaponAmmo', function(weaponName, weaponAmmo)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	SetPedAmmo(playerPed, weaponHash, weaponAmmo)
end)

RegisterNetEvent('esx:setWeaponTint')
AddEventHandler('esx:setWeaponTint', function(weaponName, weaponTintIndex)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	SetPedWeaponTintIndex(playerPed, weaponHash, weaponTintIndex)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	RemoveWeaponFromPed(playerPed, weaponHash)
  SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo

  ESX.UI.ShowInventoryItemNotification(false, ESX.GetWeaponLabel(weaponName), 1)

end)

RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(coords)
	local playerPed = PlayerPedId()

	-- ensure decmial number
	coords.x = coords.x + 0.0
	coords.y = coords.y + 0.0
	coords.z = coords.z + 0.0

	ESX.Game.Teleport(playerPed, coords)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if Config.EnableHud then
		ESX.UI.HUD.UpdateElement('job', {
			job_label   = job.label,
			grade_label = job.grade_label
		})
	end
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(vehicleName)
	local model = (type(vehicleName) == 'number' and vehicleName or GetHashKey(vehicleName))

	if IsModelInCdimage(model) then
		local playerPed = PlayerPedId()
		local playerCoords, playerHeading = GetEntityCoords(playerPed), GetEntityHeading(playerPed)

		ESX.Game.SpawnVehicle(model, playerCoords, playerHeading, function(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		end)
	else
		TriggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'Invalid vehicle model.'}})
	end
end)

RegisterNetEvent('esx:createPickup')
AddEventHandler('esx:createPickup', function(pickupId, label, playerId, type, name, components, tintIndex)

	local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
	local entityCoords, forwardVector = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
	local objectCoords = (entityCoords + forwardVector * 1.0)

	local function setupPickup(obj)

		SetEntityAsMissionEntity(obj, true, false)
		PlaceObjectOnGroundProperly(obj)
		FreezeEntityPosition(obj, true)
		SetEntityCollision(obj, false, true)

		pickups[pickupId] = {
      id      = pickupId,
			obj     = obj,
			label   = label,
			inRange = false,
			coords  = objectCoords
		}

	end

	if type == 'item_weapon' then

		Citizen.CreateThread(function()

			local weaponHash = GetHashKey(name)

			ESX.Streaming.RequestWeaponAsset(weaponHash)
			local pickupObject = CreateWeaponObject(weaponHash, 50, objectCoords, true, 1.0, 0)
			SetWeaponObjectTintIndex(pickupObject, tintIndex)

			for k,v in ipairs(components) do
				local component = ESX.GetWeaponComponent(name, v)
				GiveWeaponComponentToWeaponObject(pickupObject, component.hash)
			end

			setupPickup(pickupObject)

		end)

	else

		ESX.Game.SpawnLocalObject('prop_money_bag_01', objectCoords, function(obj)
			setupPickup(obj)
		end)
	end
end)


RegisterNetEvent('esx:createMissingPickups')
AddEventHandler('esx:createMissingPickups', function(missingPickups)
	for pickupId,pickup in pairs(missingPickups) do
		local pickupObject = nil

		if pickup.type == 'item_weapon' then
			ESX.Streaming.RequestWeaponAsset(GetHashKey(pickup.name))
			pickupObject = CreateWeaponObject(GetHashKey(pickup.name), 50, pickup.coords.x, pickup.coords.y, pickup.coords.z, true, 1.0, 0)
			SetWeaponObjectTintIndex(pickupObject, pickup.tintIndex)

			for k,componentName in ipairs(pickup.components) do
				local component = ESX.GetWeaponComponent(pickup.name, componentName)
				GiveWeaponComponentToWeaponObject(pickupObject, component.hash)
			end
		else
			ESX.Game.SpawnLocalObject('prop_money_bag_01', pickup.coords, function(obj)
				pickupObject = obj
			end)

			while not pickupObject do
				Citizen.Wait(10)
			end
		end

		SetEntityAsMissionEntity(pickupObject, true, false)
		PlaceObjectOnGroundProperly(pickupObject)
		FreezeEntityPosition(pickupObject, true)
		SetEntityCollision(pickupObject, false, true)

		pickups[pickupId] = {
			obj = pickupObject,
			label = pickup.label,
			inRange = false,
			coords = vector3(pickup.coords.x, pickup.coords.y, pickup.coords.z)
		}
	end
end)

RegisterNetEvent('esx:registerSuggestions')
AddEventHandler('esx:registerSuggestions', function(registeredCommands)
	for name,command in pairs(registeredCommands) do
		if command.suggestion then
			TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.suggestion.help, command.suggestion.arguments)
		end
	end
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(pickupId)
	if pickups[pickupId] and pickups[pickupId].obj then
		ESX.Game.DeleteObject(pickups[pickupId].obj)
		pickups[pickupId] = nil
	end
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function(radius)
	local playerPed = PlayerPedId()

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)

		for k,entity in ipairs(vehicles) do
			local attempt = 0

			while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
				Citizen.Wait(100)
				NetworkRequestControlOfEntity(entity)
				attempt = attempt + 1
			end

			if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
				ESX.Game.DeleteVehicle(entity)
			end
		end
	else
		local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

		if IsPedInAnyVehicle(playerPed, true) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		end

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			ESX.Game.DeleteVehicle(vehicle)
		end
	end
end)

-- Pause menu disables HUD display
if Config.EnableHud then

	-- Temp Fix For GTA Cash and Bank showing behind ESX HUD until more permanent solution is made? (ArkSeyonet)
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)

			-- Hide GTA Cash
			HideHudComponentThisFrame(3)
			-- Hide GTA Bank
			HideHudComponentThisFrame(4)
		
		end
	end)

	-- Set ESX HUD display to 1.0 once loading screen is off (ArkSeyonet)
	AddEventHandler('esx:loadingScreenOff', function()
		ESX.UI.HUD.SetDisplay(1.0)
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(300)

			if IsPauseMenuActive() and not isPaused then
				isPaused = true
				ESX.UI.HUD.SetDisplay(0.0)
			elseif not IsPauseMenuActive() and isPaused then
				isPaused = false
				ESX.UI.HUD.SetDisplay(1.0)
			end
		end
	end)
end

ESX.Loop('server-sync-ammo', function()

  local playerPed = PlayerPedId()

  if IsPedShooting(playerPed) then
    local _,weaponHash = GetCurrentPedWeapon(playerPed, true)
    local weapon = ESX.GetWeaponFromHash(weaponHash)

    if weapon then
      local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
      TriggerServerEvent('esx:updateWeaponAmmo', weapon.name, ammoCount)
    end
  end

end, 250, {
  function() return ESX.PlayerLoaded and (not ESX.IsDead) end
})

local previousCoords

ESX.Loop('server-sync-coords', function()

  local playerPed = PlayerPedId()

  if DoesEntityExist(playerPed) then

    local playerCoords = GetEntityCoords(playerPed)
    previousCoords     = previousCoords or playerCoords
    local distance     = #(playerCoords - previousCoords)

    if distance > 1 then
      previousCoords = playerCoords
      local playerHeading = ESX.Math.Round(GetEntityHeading(playerPed), 1)
      local formattedCoords = {x = ESX.Math.Round(playerCoords.x, 1), y = ESX.Math.Round(playerCoords.y, 1), z = ESX.Math.Round(playerCoords.z, 1), heading = playerHeading}
      TriggerServerEvent('esx:updateCoords', formattedCoords)
    end

  end

end, 1000, {
  function() return ESX.PlayerLoaded and (not ESX.IsDead) end
})

-- Disable wanted level
if Config.DisableWantedLevel then

  ESX.Loop('disable-wanted-level', function()

    local playerId = PlayerId()

    if GetPlayerWantedLevel(playerId) ~= 0 then
      SetPlayerWantedLevel(playerId, 0, false)
      SetPlayerWantedLevelNow(playerId, false)
    end

  end, 0)

end

-- Pickups
local pickupsInRange      = {}
local closestUsablePickup = nil

ESX.Loop('get-pickups-in-range', function()

  local playerPed    = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)

  pickupsInRange      = {}
  closestUsablePickup = nil

  for pickupId, pickup in pairs(pickups) do

    local distance = #(playerCoords - pickup.coords)

    if distance < 5.0 then

      pickupsInRange[#pickupsInRange + 1] = pickup

      if distance < 1.0 then
        closestUsablePickup = pickup
      end

    end

  end

end, 500)

ESX.Loop('draw-pickups', function()

  local playerPed    = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)

  for i=1, #pickupsInRange, 1 do

    local pickup = pickupsInRange[i]

    ESX.ShowFloatingHelpNotification(pickup.label, {
      x = pickup.coords.x,
      y = pickup.coords.y,
      z = pickup.coords.z + 0.25
    }, 100)

  end

end, 0)

ESX.Loop('pickup-actions', function()

  local playerPed = PlayerPedId()
  local pickup    = closestUsablePickup

  if IsControlJustReleased(0, 38) then
    if IsPedOnFoot(playerPed) then

      Citizen.CreateThread(function()

        local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
        ESX.Streaming.RequestAnimDict(dict)
        TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
        Citizen.Wait(1000)
        TriggerServerEvent('esx:onPickup', pickup.id)
        PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)

      end)

    end
  end

end, 0, {
  function() return closestUsablePickup ~= nil end
})

AddEventHandler('luaconsole:getHandlers', function(cb)

  local name = GetCurrentResourceName()

  cb(name, function(code, env)
    if env ~= nil then
      for k,v in pairs(env) do _ENV[k] = v end
      return load(code, 'lc:' .. name, 'bt', _ENV)
    else
      return load(code, 'lc:' .. name, 'bt')
    end
  end)

end)
