ESX = exports["es_extended"]:getSharedObject()

_menuPool = NativeUI.CreatePool()

local isNearShop = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for k, shop in pairs(Config.shops) do
            local shopCoords = vector3(shop.position.x, shop.position.y, shop.position.z)
            local dist = #(playerCoords - shopCoords)

            if dist < 100.0 and not shop.spawned then
                local npc = shop.npc
                RequestModel(GetHashKey(npc.model))
                
                while not HasModelLoaded(GetHashKey(npc.model)) do
                    Wait(1)
                end

                shop.ped = CreatePed(4, GetHashKey(npc.model), npc.position.x, npc.position.y, npc.position.z, npc.position.h, false, true)
                SetPedFleeAttributes(shop.ped, 0, 0)
                SetPedDropsWeaponsWhenDead(shop.ped, false)
                SetPedDiesWhenInjured(shop.ped, false)
                SetEntityInvincible(shop.ped, true)
                FreezeEntityPosition(shop.ped, true)
                SetBlockingOfNonTemporaryEvents(shop.ped, true)

                shop.spawned = true
            elseif dist >= 100.0 and shop.spawned then
                DeletePed(shop.ped)
                shop.spawned = false
            end
        end
    end
end)

-- Funktion, um Blips für Shops zu erstellen
function createShopBlips()
    for k, shop in pairs(Config.shops) do
        local blip = AddBlipForCoord(shop.position.x, shop.position.y, shop.position.z)
        SetBlipSprite(blip, 52) -- 52 ist das Blip-Symbol für Shops, ändern Sie es nach Bedarf
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 2) -- Blip-Farbe, ändern Sie es nach Bedarf
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(shop.name)
        EndTextCommandSetBlipName(blip)
    end
end

Citizen.CreateThread(function ()
    while true do 
        _menuPool:ProcessMenus()

        if isNearShop then
            showInfobar('Drücke ~g~E~s~, um den Shop zu öffnen')

            if IsControlJustReleased(0, 38) then
                --open shop menu
                openShop()
            end
        elseif _menuPool:IsAnyMenuOpen() then 
            _menuPool:CloseAllMenus()
        end

        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function ()
    while true do 
        local playerCoords = GetEntityCoords(PlayerPedId())
        isNearShop = false 

        for k, v in pairs(Config.shops) do 
            local dist = Vdist(playerCoords, v.position.x, v.position.y, v.position.z)
            if dist < 1.5 then
                isNearShop = true 
            end 
        end 

        Citizen.Wait(300)
    end
end)

function openShop()
    local shopMenu = NativeUI.CreateMenu('Shop', 'Kaufe Artikel')
    _menuPool:Add(shopMenu)

    for k, item in pairs(Config.shopItems) do
        local menuItem = NativeUI.CreateItem(item.name, 'Preis: ~g~$' .. item.price)
        shopMenu:AddItem(menuItem)

        menuItem.Activated = function (sender, index)
            -- Logic to purchase item
            TriggerServerEvent('shop:purchaseItem', item.id, item.price)
        end
    end

    shopMenu:Visible(true)
    _menuPool:MouseEdgeEnabled(false)
end

function showInfobar(msg)
    CurrentActionMsg  = msg
    SetTextComponentFormat('STRING')
    AddTextComponentString(CurrentActionMsg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
    Wait(500)
    createShopBlips()
end)
