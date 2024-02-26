local _menuPool <const> = NativeUI.CreatePool()
local isNearShop = false

local function createShopBlips()
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

local function openShop()
    local shopMenu = NativeUI.CreateMenu('Shop', 'Kaufe Artikel')
    _menuPool:Add(shopMenu)

    for k, item in pairs(Config.shopItems) do
        local menuItem = NativeUI.CreateItem(item.name, 'Preis: ~g~$' .. item.price)
        shopMenu:AddItem(menuItem)

        menuItem.Activated = function()
            TriggerServerEvent('shop:purchaseItem', item.id, item.price)
        end
    end

    shopMenu:Visible(true)
    _menuPool:MouseEdgeEnabled(false)
end

local function showInfobar(msg)
    CurrentActionMsg  = msg
    SetTextComponentFormat('STRING')
    AddTextComponentString(CurrentActionMsg)
    DisplayHelpTextFromStringLabel(0, false, true, -1)
end

local function spawnShopNPC(shop)
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
end

local function deleteShopNPC(shop)
    DeleteEntity(shop.ped)
    shop.spawned = false
end

local function processShopSpawning()
    local playerCoords = GetEntityCoords(PlayerPedId())

    for k, shop in pairs(Config.shops) do
        local shopCoords = vector3(shop.position.x, shop.position.y, shop.position.z)
        local dist = #(playerCoords - shopCoords)

        if dist < 100.0 and not shop.spawned then
            spawnShopNPC(shop)
        elseif dist >= 100.0 and shop.spawned then
            deleteShopNPC(shop)
        end
    end
end

local function processMenuInteraction()
    _menuPool:ProcessMenus()

    if isNearShop then
        showInfobar('Drücke ~g~E~s~, um den Shop zu öffnen')

        if IsControlJustReleased(0, 38) then
            openShop()
        end
    elseif _menuPool:IsAnyMenuOpen() then
        _menuPool:CloseAllMenus()
    end
end

local function checkPlayerProximity()
    local playerCoords = GetEntityCoords(PlayerPedId())
    isNearShop = false

    for k, v in pairs(Config.shops) do
        ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
        local dist = Vdist(playerCoords, v.position.x, v.position.y, v.position.z)
        if dist < 1.5 then
            isNearShop = true
        end
    end
end


createShopBlips()

CreateThread(function()
    while true do
        processShopSpawning()
        processMenuInteraction() ---@todo: testen ob sich die Funktionen gegenseitig behindern oder nicht
        Wait(1)
    end
end)

-- CreateThread(function ()
--     while true do
--         Wait(1)
--         processMenuInteraction()
--     end
-- end)

CreateThread(function ()
    while true do
        checkPlayerProximity()
        Wait(300)
    end
end)