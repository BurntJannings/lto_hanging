local PenduActif = false
local TextePendu = false

RegisterCommand('hang', function(source, args, rawCommand)
    local pos = GetEntityCoords(PlayerPedId())
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    if (Vdist(pos.x, pos.y, pos.z, -314.49, 728.94, 120.1) < 5.0) then
	local target_id = args[1]
    TriggerServerEvent("lto_pendu:sherif", target_id)

    else
	TriggerEvent("vorp:TipRight", Config.TooFar, 7000)
	end
end)

RegisterNetEvent("lto_pendu:go")
AddEventHandler("lto_pendu:go", function(target_id)
    TriggerServerEvent("lto_pendu:pendre", target_id)
end)

RegisterNetEvent("lto_pendu:joueur")
AddEventHandler("lto_pendu:joueur", function()
    local ped = PlayerPedId()

    for k, v in pairs(Config.Prison) do
        if not PenduActif then
            SetEntityCoords(ped, v.x+0.3, v.y-0.1, v.z-1.5, v.heading)
            FreezeEntityPosition(ped, true)
			SetEnableHandcuffs(ped, true)
			PlayAnimationM(ped, "script_re@public_hanging@criminal_male", "death_a")

            PenduActif = true
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent("lto_pendu:AnimLevier")
AddEventHandler("lto_pendu:AnimLevier", function()
    local ped = PlayerPedId()
	PlayAnimationL(ped, "mech_doors@locked@1handed", "knob_r_kick_fail")
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()

		if isHandcuffed or isHandcuffed2 or isHandcuffed3 then
		
			DisableControlAction(0, 0xB2F377E8, true) -- Attack
			DisableControlAction(0, 0xC1989F95, true) -- Attack 2
			DisableControlAction(0, 0x07CE1E61, true) -- Melee Attack 1
			DisableControlAction(0, 0xF84FA74F, true) -- MOUSE2
			DisableControlAction(0, 0xCEE12B50, true) -- MOUSE3
			DisableControlAction(0, 0x8FFC75D6, true) -- Shift
			DisableControlAction(0, 0xD9D0E1C0, true) -- SPACE
            DisableControlAction(0, 0xCEFD9220, true) -- E
            DisableControlAction(0, 0xF3830D8E, true) -- J
            DisableControlAction(0, 0x760A9C6F, true) -- G
            DisableControlAction(0, 0x80F28E95, true) -- L
            DisableControlAction(0, 0xDB096B85, true) -- CTRL
            DisableControlAction(0, 0xE30CD707, true) -- R
		    DisablePlayerFiring(ped, true)
			SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(ped, false)
			DisplayRadar(false)
			
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        if PenduActif then
            local ped = PlayerPedId()
            local local_player = PlayerId()
            local player_coords = GetEntityCoords(ped, true)

            if not GetPlayerInvincible(local_player) then
            SetPlayerInvincible(local_player, true)
            end

            local player_server_id = GetPlayerServerId(PlayerId())
            TriggerServerEvent("lto_pendu:tuer", player_server_id)
            Citizen.Wait(1000)
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("lto_pendu:gotuer")
AddEventHandler("lto_pendu:gotuer", function(target_id)
    local local_ped = PlayerPedId()
    local local_player = PlayerId()
	
	DoScreenFadeOut(11000)
	Citizen.Wait(12000) -- temps avant la mort
	DoScreenFadeIn(1000)
    PenduActif = false
    FreezeEntityPosition(local_ped, false)
	SetPlayerInvincible(local_player, false)

    ApplyDamageToPed(local_ped, 500000, false, true, true)
end)

Citizen.CreateThread(function ()
    while true do
        if PenduActif then
            DrawTxt(Config.Hang, 0.3, 0.85, 0.5, 0.5, true, 255, 255, 255, 150, false)
        end
        Citizen.Wait(0)
    end
end)

function PlayAnimationM(ped, dict, name)
    if not DoesAnimDictExist(dict) then
      return
    end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
    Citizen.Wait(0)
    end
    TaskPlayAnim(ped, dict, name, -1.0, -0.5, -1, 1, 0, true, 0, false, 0, false)
    RemoveAnimDict(dict)
end

function PlayAnimationL(ped, dict, name)
    if not DoesAnimDictExist(dict) then
      return
    end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
    Citizen.Wait(0)
    end
    TaskPlayAnim(ped, dict, name, -1.0, -0.5, 1500, 1, 0, true, 0, false, 0, false)
    RemoveAnimDict(dict)
end

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end