include("autorun/brohud.lua")

if SERVER then
    util.AddNetworkString("UpdateHungerThirst")

    local function initializePlayer(ply)
        ply:SetNWInt("Hunger", 100)
        ply:SetNWInt("Thirst", 100)
    end

    hook.Add("PlayerInitialSpawn", "SetupPlayerHungerThirst", function(ply)
        initializePlayer(ply)

        timer.Create("HungerThirstTimer" .. ply:SteamID(), 5, 0, function()
            if IsValid(ply) then
                hunger = math.max(ply:GetNWInt("Hunger") - 1, 0)
                thirst = math.max(ply:GetNWInt("Thirst") - 1, 0)

                ply:SetNWInt("Hunger", hunger)
                ply:SetNWInt("Thirst", thirst)

                net.Start("UpdateHungerThirst")
                net.WriteInt(hunger, 8)
                net.WriteInt(thirst, 8)
                net.Send(ply)
            else
                timer.Remove("HungerThirstTimer" .. ply:SteamID())
            end
        end)
    end)

    hook.Add("PlayerDisconnected", "StopHungerThirstTimer", function(ply)
        timer.Remove("HungerThirstTimer" .. ply:SteamID())
    end)
end

if CLIENT then
    net.Receive("UpdateHungerThirst", function()
        local hunger = net.ReadInt(8)
        local thirst = net.ReadInt(8)

        print("Голод: " .. hunger .. " Жажда: " .. thirst)

    end)
end

if CLIENT then
    net.Receive("UpdateHungerThirst", function()
        local hunger = net.ReadInt(8)
        local thirst = net.ReadInt(8)
    end)
end