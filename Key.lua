local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

-- ═══════════════════════════════════════════════════════════════
-- CONFIGURATION
-- ═══════════════════════════════════════════════════════════════
local PROJECT_ID = "95431ca7-0628-4202-a3d8-aa2892879f77"
local SUPABASE_BASE = "https://rpjnutqxvaysvznofseg.supabase.co/rest/v1"
local ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwam51dHF4dmF5c3Z6bm9mc2VnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjcxMDI4MzcsImV4cCI6MjA4MjY3ODgzN30.Wt3cX0b7Ytqxj4X5LjW02G3H-xwDKTGepUVftffxbjU"
local BASE_URL = "https://perfectuskey.vercel.app" -- Production URL
local KEY_FILE = "PerfectusKey.txt"

-- ═══════════════════════════════════════════════════════════════
-- GAME SCRIPTS MAPPING
-- ═══════════════════════════════════════════════════════════════
local DesteklenenScriptler = {
    [90462358603255] = "https://raw.githubusercontent.com/jokerbiel13/FourHub/refs/heads/main/FHAE.lua",
}

local function loadGameScript()
    local placeId = game.PlaceId
    local scriptURL = DesteklenenScriptler[placeId]
    
    if scriptURL then
        local success, err = pcall(function()
            loadstring(game:HttpGet(scriptURL, true))()
        end)
        if not success then
            Fluent:Notify({Title = "Script Error", Content = "Failed to load script: " .. tostring(err), Duration = 5})
        end
    else
        Fluent:Notify({Title = "Not Supported", Content = "This game is not supported by our system. ID: " .. tostring(placeId), Duration = 5})
    end
end

-- Security: Get HWID (ClientId / UserId)
local function getHWID()
    local success, result = pcall(function() return RbxAnalyticsService:GetClientId() end)
    return (success and result) or tostring(Player.UserId)
end

local HWID = getHWID()
local SITE_URL = BASE_URL .. "/system?rid=" .. HWID .. "&pid=" .. PROJECT_ID

-- Executor-Safe Request Function
local function safeRequest(options)
    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not requestFunc then return nil end
    local success, result = pcall(function() return requestFunc(options) end)
    return success and result or nil
end

-- Helper: Link Roblox ID
local function updateRobloxId()
    safeRequest({
        Url = SUPABASE_BASE .. "/key_system?hwid=eq." .. HWID,
        Method = "PATCH",
        Headers = {
            ["apikey"] = ANON_KEY,
            ["Authorization"] = "Bearer " .. ANON_KEY,
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({ roblox_id = Player.UserId })
    })
end

-- UI Setup (Fluent)
local Fluent = loadstring(game:HttpGet("https://github.com/1dontgiveaf/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "PERFECTUS",
    SubTitle = "Security Protocol v4.0",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 350),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = { Main = Window:AddTab({ Title = "Verification", Icon = "shield-check" }) }

Tabs.Main:AddParagraph({
    Title = "Welcome, " .. Player.DisplayName,
    Content = "Your hardware ID has been registered. Please complete the checkpoints on our website to generate an access key."
})

local KeyInput = Tabs.Main:AddInput("KeyInput", {
    Title = "Redeem Key",
    Default = "",
    Placeholder = "PER-XXXX-XXXX...",
    Numeric = false,
    Finished = false,
    Callback = function(Value) end
})

Tabs.Main:AddButton({
    Title = "Authenticate Session",
    Description = "Verify your key against our cloud database",
    Callback = function()
        local Value = Fluent.Options.KeyInput.Value
        if not authenticate(Value, false) then
            Fluent:Notify({Title = "Invalid", Content = "The key you entered is invalid or already used.", Duration = 5})
        end
    end
})

-- Define authenticate function
function authenticate(Value, isAuto)
    if not Value or Value == "" then
        if not isAuto then
            Fluent:Notify({Title = "Error", Content = "Please enter your key!", Duration = 3})
        end
        return false
    end

    -- 1. Ban Check
    local banCheck = safeRequest({
        Url = SUPABASE_BASE .. "/key_system?hwid=eq." .. HWID .. "&select=is_banned",
        Method = "GET",
        Headers = {["apikey"] = ANON_KEY, ["Authorization"] = "Bearer " .. ANON_KEY}
    })

    if banCheck and banCheck.StatusCode == 200 then
        local banData = HttpService:JSONDecode(banCheck.Body)
        if #banData > 0 and banData[1].is_banned then
            Player:Kick("\n[PERFECTUS SECURITY]\nThis device is blacklisted from our services.")
            return false
        end
    end

    -- 2. Validate Generated Key
    local response = safeRequest({
        Url = SUPABASE_BASE .. "/user_generated_keys?key_content=eq." .. tostring(Value) .. "&select=*",
        Method = "GET",
        Headers = {["apikey"] = ANON_KEY, ["Authorization"] = "Bearer " .. ANON_KEY}
    })

    if response and response.StatusCode == 200 then
        local data = HttpService:JSONDecode(response.Body)
        if #data > 0 then
            local keyData = data[1]
            local expiresAt = keyData.expires_at and (DateTime.fromIsoDate(keyData.expires_at).UnixTimestamp) or 0
            
            if os.time() > expiresAt then
                if not isAuto then
                    Fluent:Notify({Title = "Expired", Content = "This key has already expired!", Duration = 5})
                end
                return false
            end

            if keyData.hwid == HWID then
                updateRobloxId()
                if not isAuto then
                    pcall(function() writefile(KEY_FILE, Value) end)
                end
                Fluent:Notify({Title = "Success", Content = "Authentication successful! Enjoy your script.", Duration = 5})
                task.wait(1)
                Window:Destroy()
                loadGameScript()
                return true
            else
                if not isAuto then
                    Fluent:Notify({Title = "Security Alert", Content = "This key is bound to another hardware profile.", Duration = 5})
                end
                return false
            end
        end
    end

    -- 3. Check for Pre-generated Keys (Redemption)
    local preCheck = safeRequest({
        Url = SUPABASE_BASE .. "/pre_generated_keys?key_content=eq." .. tostring(Value) .. "&is_redeemed=eq.false&select=*",
        Method = "GET",
        Headers = {["apikey"] = ANON_KEY, ["Authorization"] = "Bearer " .. ANON_KEY}
    })

    if preCheck and preCheck.StatusCode == 200 then
        local preData = HttpService:JSONDecode(preCheck.Body)
        if #preData > 0 then
            local preKey = preData[1]
            local expiryDate = DateTime.fromUnixTimestamp(os.time() + (preKey.duration_hours * 3600)):ToIsoDate()
            
            local redeemRes = safeRequest({
                Url = SUPABASE_BASE .. "/user_generated_keys",
                Method = "POST",
                Headers = {
                    ["apikey"] = ANON_KEY,
                    ["Authorization"] = "Bearer " .. ANON_KEY,
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode({
                    hwid = HWID,
                    project_id = PROJECT_ID,
                    key_content = tostring(Value),
                    expires_at = expiryDate
                })
            })

            if redeemRes and (redeemRes.StatusCode == 201 or redeemRes.StatusCode == 200) then
                safeRequest({
                    Url = SUPABASE_BASE .. "/pre_generated_keys?id=eq." .. preKey.id,
                    Method = "PATCH",
                    Headers = {["apikey"] = ANON_KEY, ["Authorization"] = "Bearer " .. ANON_KEY, ["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({ is_redeemed = true, redeemed_by_hwid = HWID })
                })

                pcall(function() writefile(KEY_FILE, Value) end)
                Fluent:Notify({Title = "Success", Content = "Premium key redeemed successfully!", Duration = 5})
                task.wait(1)
                Window:Destroy()
                loadGameScript()
                return true
            end
        end
    end

    return false
end

Tabs.Main:AddButton({
    Title = "Get Key",
    Description = "Open our verification portal in your browser",
    Callback = function()
        setclipboard(SITE_URL)
        Fluent:Notify({Title = "Link Copied!", Content = "Verification link has been copied to your clipboard.", Duration = 4})
    end
})

Window:SelectTab(1)
Fluent:Notify({ Title = "System Initialized", Content = "Perfectus Key System is ready.", Duration = 3 })

-- ═══════════════════════════════════════════════════════════════
-- AUTO LOGIN CHECK
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    local success, savedKey = pcall(function() return readfile(KEY_FILE) end)
    if success and savedKey and savedKey ~= "" then
        Fluent:Notify({Title = "Auto Login", Content = "Checking saved key...", Duration = 3})
        task.wait(0.5)
        local authSuccess = authenticate(savedKey, true)
        if not authSuccess then
            Fluent:Notify({Title = "Auto Login Failed", Content = "Saved key is expired or invalid.", Duration = 5})
        end
    end
end)
