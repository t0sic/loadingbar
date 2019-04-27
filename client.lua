local Cooldowns = {}

RegisterNUICallback("event_handler", callback)

RegisterNetEvent("t0sic_progressbar:delayedFunctionComplete")
AddEventHandler("t0sic_progressbar:delayedFunctionComplete", function(data)
    if Cooldowns[data["id"]] then
        Cooldowns[data["id"]]["data"]["cb"]()

        Cooldowns[data["id"]] = nil
    end
end)

StartDelayedFunction = function(title, time, cb)
    local uniqueID = GenerateUniqueId()

    Citizen.CreateThread(function()
        while TableLength(Cooldowns) > 0 do
            Citizen.Wait(0)
        end

        Cooldowns[uniqueID] = {}
        Cooldowns[uniqueID]["data"] = {
            ["title"] = title,
            ["time"] = time,
            ["cb"] = cb,
            ["id"] = uniqueID
        }
    
        SendNUIMessage({
            ["Action"] = "SHOW_DELAYED_FUNCTION",
            ["Data"] = {
                ["title"] = title,
                ["time"] = time,
                ["id"] = uniqueID
            }
        })
    end)
end

TableLength = function(table)
    local length = 0

    for _, _ in pairs(table) do
        length = length + 1
    end

    return length
end

GenerateUniqueId = function()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'

    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

RegisterCommand("takebandage", function()
    StartDelayedFunction("Dödar sig själv", 10000, function(data)
        SetEntityHealth(PlayerPedId(), 0)
    end)
end)