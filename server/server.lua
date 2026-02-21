ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('shop:purchaseItem')
AddEventHandler('shop:purchaseItem', function(itemId, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        xPlayer.addInventoryItem(itemId, 1)
        TriggerClientEvent('esx:showNotification', source, 'Du hast einen Artikel gekauft.')
    else
        TriggerClientEvent('esx:showNotification', source, 'Du hast nicht genug Geld.')
    end
end)
