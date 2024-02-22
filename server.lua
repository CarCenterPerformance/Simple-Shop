local ESX <const> = exports["es_extended"]:getSharedObject()

RegisterServerEvent('shop:purchaseItem', function(itemId, price)
    local xPlayer <const> = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() < price then
        TriggerClientEvent('esx:showNotification', source, 'Du hast nicht genug Geld.')
        return
    end

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem(itemId, 1)
    TriggerClientEvent('esx:showNotification', source, 'Du hast einen Artikel gekauft.')
end)
