VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

RegisterServerEvent("lto_pendu:sherif")
AddEventHandler("lto_pendu:sherif", function(target_id)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local job = Character.job
    if job == 'police' or job == 'marshal' then
	
        TriggerClientEvent('lto_pendu:AnimLevier', _source)
        TriggerClientEvent('lto_pendu:go', _source, target_id)
    end
end)

RegisterServerEvent("lto_pendu:pendre")
AddEventHandler("lto_pendu:pendre", function(target_id)
    local _source = source

    local user_name = GetPlayerName(target_id)
    local steam_id = GetPlayerIdentifiers(target_id)[1]

    local admin_name = GetPlayerName(_source)
    local admin_steam = GetPlayerIdentifiers(_source)[1]

    TriggerClientEvent("lto_pendu:joueur", target_id)

end)

RegisterServerEvent("lto_pendu:tuer")
AddEventHandler("lto_pendu:tuer", function(target_id)

    TriggerClientEvent("lto_pendu:gotuer", target_id)
end)