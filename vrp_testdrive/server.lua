local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

MySQL = module("vrp_mysql", "MySQL")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_testdrive")
Gclient = Tunnel.getInterface("vRP_garages","vRP_testdrive")

-- vehicle db / garage and lscustoms compatibility


-- SHOWROOM
RegisterServerEvent('veh_TD:CheckMoneyForVeh')
AddEventHandler('veh_TD:CheckMoneyForVeh', function(vehicle, price ,veh_type)
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  MySQL.query("vRP/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
	if #pvehicle > 0 then
		vRPclient.notify(player,{"~r~You already own this car."})
	else
		if vRP.tryFullPayment({user_id,price}) then
			TriggerEvent('TD:currentlytesting')
			TriggerClientEvent('veh_TD:CloseMenu', player, vehicle, veh_type)
		else
			vRPclient.notify(player,{"~r~Not enough money!"})
		end
	end
	end)
  end)
