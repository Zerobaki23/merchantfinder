task.wait(10)
setfpscap(15)
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

if game.PlaceId ~= 3978370137 then
    warn("This script only works in game ID 3978370137. Current game ID: " .. tostring(game.PlaceId))
    return
end

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local dashEvent = ReplicatedStorage.Events.takestam
local merchantEvent = ReplicatedStorage.Events.TravelingMerchentRemote

local webhookUtil = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/discordwebhook/src.lua"))()

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local FLASK_SERVER = "http://192.168.100.96:5000"
local lastStockHash = nil
local flaskConnected = false

game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == "RobloxPromptGui" then
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, player)
    end
end)

Players.PlayerRemoving:Connect(function(removedPlayer)
    if removedPlayer == player then
        task.wait(0.5)
        TeleportService:Teleport(game.PlaceId, player)
    end
end)

local noclipEnabled = true
local noclipConnection = nil

local function enableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
    end
    
    local character = player.Character
    if not character then return end
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Keep noclip active with RunService
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipEnabled then return end
        
        local char = player.Character
        if not char then return end
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end
local character = player.Character or player.CharacterAdded:Wait()
enableNoclip()

player.CharacterAdded:Connect(function(newCharacter)
    task.wait(0.1) 
    enableNoclip()
end)

local tweenEnabled = true
local is3dDisabled = false
local blackScreenGui = nil
local startTime = os.time()
local shopOpened = false
local logMessages = {}

local function formatPlaytime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02dh %02dm %02ds", hours, minutes, secs)
end

local currentStatus = "Idle"
local statusLabel = nil

local function updateStatus(status)
    currentStatus = status
    if statusLabel and statusLabel.Parent then
        statusLabel.Text = "Status: " .. status
    end
end

local function create3dDisabledScreen()
  
    local gui = Instance.new("ScreenGui")
    gui.Name = "3dDisabledScreen"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 2147483647
    
    
    pcall(function()
        syn.protect_gui(gui)
    end)
    
    gui.Parent = game:GetService("CoreGui")
    
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BorderSizePixel = 0
    background.ZIndex = 2147483647
    background.Parent = gui
    
    local discordLabel = Instance.new("TextLabel")
    discordLabel.Name = "DiscordLabel"
    discordLabel.Size = UDim2.new(0, 500, 0, 60)
    discordLabel.Position = UDim2.new(0.5, -250, 0.35, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "Children Farm"
    discordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordLabel.TextSize = 48
    discordLabel.Font = Enum.Font.GothamBold
    discordLabel.TextXAlignment = Enum.TextXAlignment.Center
    discordLabel.ZIndex = 2147483647
    discordLabel.Parent = gui
    
    local playtimeLabel = Instance.new("TextLabel")
    playtimeLabel.Name = "PlaytimeLabel"
    playtimeLabel.Size = UDim2.new(0, 500, 0, 40)
    playtimeLabel.Position = UDim2.new(0.5, -250, 0.5, 0)
    playtimeLabel.BackgroundTransparency = 1
    playtimeLabel.Text = "Play Time: 00h 00m 00s"
    playtimeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    playtimeLabel.TextSize = 28
    playtimeLabel.Font = Enum.Font.Gotham
    playtimeLabel.TextXAlignment = Enum.TextXAlignment.Center
    playtimeLabel.ZIndex = 2147483647
    playtimeLabel.Parent = gui
    
    statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(0, 500, 0, 40)
    statusLabel.Position = UDim2.new(0.5, -250, 0.58, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: " .. currentStatus
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 28
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.ZIndex = 2147483647
    statusLabel.Parent = gui
    
    RunService.RenderStepped:Connect(function()
        if playtimeLabel and playtimeLabel.Parent then
            local elapsed = os.time() - startTime
            playtimeLabel.Text = "Play Time: " .. formatPlaytime(elapsed)
        end
    end)
    
    return gui
end

local function toggle3dDisabled()
    is3dDisabled = not is3dDisabled
    
    if is3dDisabled then
        blackScreenGui = create3dDisabledScreen()
        
      
        task.spawn(function()
            while is3dDisabled do
                task.wait(0.5)
                if blackScreenGui and not blackScreenGui.Parent then
                    log("Black screen was removed - recreating...", "warning")
                    blackScreenGui = create3dDisabledScreen()
                end
            end
        end)
    else
        if blackScreenGui then
            blackScreenGui:Destroy()
            blackScreenGui = nil
            statusLabel = nil
        end
    end
end

local function checkFlaskConnection()
    local success, result = pcall(function()
        return HttpService:GetAsync(FLASK_SERVER .. "/ping", true)
    end)
    
    if success then
        flaskConnected = true
        return true
    else
        flaskConnected = false
        return false
    end
end

local function sendToFlask(endpoint, data)
    if not flaskConnected then
        return false
    end
    
    local success, result = pcall(function()
        return HttpService:PostAsync(
            FLASK_SERVER .. endpoint,
            HttpService:JSONEncode(data),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    
    return success
end

local function sendFlaskMessage(message)
    return sendToFlask("/message", {message = message})
end

local function generateStockHash(prices)
    local stockString = ""
    
    if type(prices) == "table" then
        local sortedKeys = {}
        for k in pairs(prices) do
            table.insert(sortedKeys, k)
        end
        table.sort(sortedKeys)
        
        for _, itemName in ipairs(sortedKeys) do
            local itemData = prices[itemName]
            local price = itemData
            
            if type(itemData) == "table" then
                price = itemData.price or itemData.Price or itemData.cost or itemData.Cost or 0
            end
            
            stockString = stockString .. itemName .. ":" .. tostring(price) .. ";"
        end
    else
        stockString = tostring(prices)
    end
    
    local hash = 0
    for i = 1, #stockString do
        hash = (hash * 31 + string.byte(stockString, i)) % 2147483647
    end
    
    return tostring(hash)
end

local function countStock(prices)
    local count = 0
    if type(prices) == "table" then
        for _ in pairs(prices) do
            count = count + 1
        end
    end
    return count
end

local Window = Fluent:CreateWindow({
    Title = "⚡ Merchant Bot Terminal",
    SubTitle = "Automated Merchant Farming",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Logs = Window:AddTab({ Title = "Logs", Icon = "file-text" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

Tabs.Main:AddParagraph({
    Title = "Status",
    Content = "Merchant bot is running. Use the toggles below to control the bot."
})

local StatusParagraph = Tabs.Main:AddParagraph({
    Title = "Connection Status",
    Content = "Checking Flask connection..."
})

local TweenToggle = Tabs.Main:AddToggle("TweenToggle", {
    Title = "Enable Tweening",
    Description = "Automatically tween to merchant location",
    Default = true
})

TweenToggle:OnChanged(function()
    tweenEnabled = Options.TweenToggle.Value
    Fluent:Notify({
        Title = "Tweening",
        Content = tweenEnabled and "Tweening enabled" or "Tweening disabled",
        Duration = 3
    })
end)

local DisableRenderToggle = Tabs.Main:AddToggle("DisableRender", {
    Title = "Disable 3D Rendering",
    Description = "Show black screen to reduce lag",
    Default = false
})

DisableRenderToggle:OnChanged(function()
    toggle3dDisabled()
    Fluent:Notify({
        Title = "3D Rendering",
        Content = is3dDisabled and "3D rendering disabled" or "3D rendering enabled",
        Duration = 3
    })
end)

Tabs.Main:AddButton({
    Title = "Reconnect to Flask",
    Description = "Attempt to reconnect to Flask server",
    Callback = function()
        Fluent:Notify({
            Title = "Flask",
            Content = "Attempting to reconnect...",
            Duration = 3
        })
        local success = checkFlaskConnection()
        StatusParagraph:SetDesc(
            "Flask Server: " .. (flaskConnected and "✓ Connected" or "✗ Disconnected") .. "\n" ..
            "Tweening: " .. (tweenEnabled and "✓ Enabled" or "✗ Disabled") .. "\n" ..
            "3D Disabled: " .. (is3dDisabled and "✓ Enabled" or "✗ Disabled")
        )
    end
})

Tabs.Main:AddButton({
    Title = "Send Test Stock",
    Description = "Send test stock data to Flask server",
    Callback = function()
        local testStock = {
            ["Apple"] = 50,
            ["Banana"] = 75,
            ["Orange"] = 100,
            ["Mythical Fruit Chest"] = 5000,
            ["Golden Diamond"] = 2500
        }
        
        local testData = {
            timestamp = os.time(),
            prices = testStock,
            formatted = "**TEST STOCK:**\n```\nApple - 50\nBanana - 75\nOrange - 100\n```"
        }
        
        if sendToFlask("/stock", testData) then
            Fluent:Notify({
                Title = "Success",
                Content = "Test stock sent to Flask!",
                Duration = 3
            })
            sendFlaskMessage("📊 TEST STOCK SENT")
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Failed to send test stock",
                Duration = 3
            })
        end
    end
})

Tabs.Main:AddButton({
    Title = "Send Test Embed to Discord",
    Description = "Send a test embed to Discord webhook",
    Callback = function()
        local testStock = {
            ["Thrilled Ship"] = {price = 140256, stock = 1},
            ["Fishing RodMerchants Banana Rod"] = {price = 116880, stock = 1},
            ["P Reset Essence"] = {price = 2338, stock = 3},
            ["Dark Root"] = {price = 4676, stock = 2},
            ["Mythical Fruit Chest"] = {price = 935040, stock = 1},
            ["Karoo Mount"] = {price = 32727, stock = 1}
        }
        
        log("Sending test embed to Discord...", "info")
        
        -- Build stock text
        local stockText = ""
        local purchasedText = ""
        
        for itemName, itemData in pairs(testStock) do
            local price = itemData.price
            local stock = itemData.stock
            
            if itemName == "Mythical Fruit Chest" then
                purchasedText = string.format("%s x%d (0 left)", itemName, stock)
            else
                stockText = stockText .. string.format("%s x%d - %s\n", itemName, stock, tostring(price))
            end
        end
        
        local description = ""
        if purchasedText ~= "" then
            description = description .. "**Purchased:**\n" .. purchasedText .. "\n\n"
        end
        if stockText ~= "" then
            description = description .. "**Stock:**\n" .. stockText
        end
        
        local testEmbed = {
            {
                title = "Merchant Report",
                description = description,
                color = 3092790,
                thumbnail = {
                    url = "https://i.namu.wiki/i/MsnyhXXd6SH-eF6bBlJ4LCld2E4w-kwp-9NIOdQYcitoNp06tdwDFGxEAU0ka4kUpGcPt5uLbDKLnrBpesZVdJ1nKKyqnZvnZyfHhryjNerns67c6FRCj7qrD3Ro22QtkRcNh0kCMWxEJUPJksU0dQ.webp"
                },
                footer = {
                    text = os.date("%I:%M %p") .. " | ZeroHUB"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
            }
        }
        
        local webhookBody = HttpService:JSONEncode({
            username = "Merchant Shop Monitor",
            content = "**User:** " .. player.Name,
            embeds = testEmbed
        })
        
        local success, response = pcall(function()
            return request({
                Url = "https://discord.com/api/webhooks/1265355595582537809/rAYW0kkZl4MnKE6Q-TcHPvncwdXJDY39y6d9nYcy54JUlmN8BCJXgxKGKKk3lKj8hPPe",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = webhookBody
            })
        end)
        
        if success then
            log("Test embed sent successfully!", "success")
            Fluent:Notify({
                Title = "Success!",
                Content = "Test embed sent to Discord!",
                Duration = 3
            })
        else
            log("Failed to send test embed: " .. tostring(response), "error")
            Fluent:Notify({
                Title = "Error",
                Content = "Failed to send test embed",
                Duration = 3
            })
        end
    end
})

local LogContent = Tabs.Logs:AddParagraph({
    Title = "Recent Logs",
    Content = "No logs yet..."
})

local function updateLogDisplay()
    local logText = ""
    local maxLogs = 20
    local startIndex = math.max(1, #logMessages - maxLogs + 1)
    
    for i = startIndex, #logMessages do
        logText = logText .. logMessages[i] .. "\n"
    end
    
    LogContent:SetDesc(logText)
end

local function log(message, logType)
    logType = logType or "info"
    
    local prefixes = {
        info = "[•]",
        success = "[✓]",
        warning = "[!]",
        error = "[✗]"
    }
    
    local timestamp = os.date("%H:%M:%S")
    local prefix = prefixes[logType] or prefixes.info
    local logMessage = string.format("[%s] %s %s", timestamp, prefix, message)
    
    table.insert(logMessages, logMessage)
    updateLogDisplay()
end

Tabs.Logs:AddButton({
    Title = "Clear Logs",
    Description = "Clear all log messages",
    Callback = function()
        logMessages = {}
        updateLogDisplay()
        Fluent:Notify({
            Title = "Logs Cleared",
            Content = "All logs have been cleared",
            Duration = 2
        })
    end
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("MerchantBot")
SaveManager:SetFolder("MerchantBot/configs")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Merchant Bot",
    Content = "Script loaded successfully!",
    Duration = 5
})

log("Terminal initialized", "success")
log("Collision disabled - noclip enabled", "success")

checkFlaskConnection()
StatusParagraph:SetDesc(
    "Flask Server: " .. (flaskConnected and "✓ Connected" or "✗ Disconnected") .. "\n" ..
    "Tweening: " .. (tweenEnabled and "✓ Enabled" or "✗ Disabled") .. "\n" ..
    "3D Disabled: " .. (is3dDisabled and "✓ Enabled" or "✗ Disabled")
)

log("Auto-dash, merchant interaction, and webhook monitor enabled", "info")

if flaskConnected then
    sendFlaskMessage("hi")
end

local function getPricesFromShop(merchantShop)
    local pricesData = {}
    
    if merchantShop:GetAttribute("Prices") then
        local pricesAttr = merchantShop:GetAttribute("Prices")
        if type(pricesAttr) == "string" then
            local success, result = pcall(function()
                return HttpService:JSONDecode(pricesAttr)
            end)
            if success then
                return result
            end
        end
        return pricesAttr
    end
    
    for _, descendant in pairs(merchantShop:GetDescendants()) do
        if descendant.Name == "Prices" then
            if descendant:IsA("Configuration") or descendant:IsA("Folder") then
                for _, item in pairs(descendant:GetChildren()) do
                    if item:IsA("IntValue") or item:IsA("NumberValue") then
                        pricesData[item.Name] = item.Value
                    elseif item:IsA("StringValue") then
                        pricesData[item.Name] = item.Value
                    end
                end
            elseif descendant:IsA("IntValue") or descendant:IsA("NumberValue") then
                return descendant.Value
            elseif descendant:IsA("StringValue") then
                return descendant.Value
            end
        end
    end
    
    return pricesData
end

local function sendPriceWebhook(prices)
    local currentHash = generateStockHash(prices)
    
    if currentHash == lastStockHash then
        log("Stock unchanged - skipping webhook and Flask update", "info")
        return
    end
    
    lastStockHash = currentHash
    log("New stock detected - sending updates", "success")
    
    local hasMythicalFruitChest = false
    local mythicalChestName = nil
    
    local stockCount = countStock(prices)
    sendToFlask("/ping", {stock = stockCount})
    log("Stock count sent to /ping: " .. stockCount, "success")
    
    -- Build stock text
    local stockText = ""
    local purchasedText = ""
    
    if type(prices) == "table" then
        for itemName, itemData in pairs(prices) do
            local price = itemData
            local quantity = 1
            
            if type(itemData) == "table" then
                price = itemData.price or itemData.Price or itemData.cost or itemData.Cost
                quantity = itemData.quantity or itemData.Quantity or itemData.stock or itemData.Stock or 1
            end
            
            local lowerName = string.lower(itemName)
            if lowerName:find("mythical") and lowerName:find("fruit") and lowerName:find("chest") then
                hasMythicalFruitChest = true
                mythicalChestName = itemName
                purchasedText = string.format("%s x%d (0 left)", itemName, quantity)
            else
                stockText = stockText .. string.format("%s x%d - %s\n", itemName, quantity, tostring(price))
            end
        end
    end
    
    -- Build description
    local description = ""
    if purchasedText ~= "" then
        description = description .. "**Purchased:**\n" .. purchasedText .. "\n\n"
    end
    if stockText ~= "" then
        description = description .. "**Stock:**\n" .. stockText
    end
    
    local stockData = {
        timestamp = os.time(),
        prices = prices,
        formatted = "Stock updated"
    }
    sendToFlask("/stock", stockData)
    
    if hasMythicalFruitChest then
        log("Mythical Fruit Chest detected! Pinging user.", "success")
        sendFlaskMessage("🎁 MYTHICAL FRUIT CHEST DETECTED!")
        
        Fluent:Notify({
            Title = "Mythical Chest Found!",
            Content = "Attempting to purchase...",
            Duration = 5
        })
        
        task.spawn(function()
            task.wait(1)
            log("Attempting to purchase Mythical Fruit Chest...", "info")
            
            local success, result = pcall(function()
                return merchantEvent:InvokeServer(mythicalChestName)
            end)
            
            if success then
                log("Successfully purchased Mythical Fruit Chest!", "success")
                sendFlaskMessage("✅ Purchased Mythical Fruit Chest!")
                Fluent:Notify({
                    Title = "Purchase Success!",
                    Content = "Mythical Fruit Chest purchased!",
                    Duration = 5
                })
            else
                log("Failed to purchase: " .. tostring(result), "error")
                sendFlaskMessage("❌ Failed to purchase chest: " .. tostring(result))
            end
        end)
    end
    
    local embed = {
        {
            title = "Merchant Report",
            description = description,
            color = 3092790,
            thumbnail = {
                url = "https://i.namu.wiki/i/MsnyhXXd6SH-eF6bBlJ4LCld2E4w-kwp-9NIOdQYcitoNp06tdwDFGxEAU0ka4kUpGcPt5uLbDKLnrBpesZVdJ1nKKyqnZvnZyfHhryjNerns67c6FRCj7qrD3Ro22QtkRcNh0kCMWxEJUPJksU0dQ.webp"
            },
            footer = {
                text = os.date("%I:%M %p") .. " |  ZeroHUB"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
        }
    }
    
    local content = "**User:** " .. player.Name
    if hasMythicalFruitChest then
        content = "<@832942242498084888> " .. content
    end
    
    local webhookBody = HttpService:JSONEncode({
        username = "Kid Finder",
        content = content,
        embeds = embed
    })
    
    log("Sending embed...", "info")
    
    local success, response = pcall(function()
        return request({
            Url = "https://discord.com/api/webhooks/1265355595582537809/rAYW0kkZl4MnKE6Q-TcHPvncwdXJDY39y6d9nYcy54JUlmN8BCJXgxKGKKk3lKj8hPPe",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = webhookBody
        })
    end)
    
    if success then
        log("Embed sent to Discord successfully!", "success")
    else
        log("Webhook error: " .. tostring(response), "error")
    end
end

local function findProximityPrompt(npc)
    for _, descendant in pairs(npc:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            return descendant
        end
    end
    return nil
end

local function onMerchantShopAdded(child)
    if child.Name == "MerchentShop" and not shopOpened then
        shopOpened = true
        updateStatus("Scanning Stock")
        log("Childrens detected! Getting prices...", "success")
        sendFlaskMessage("Eipsten shop opened - scanning stock...")
        task.wait(0.5)
        
        local prices = getPricesFromShop(child)
        
        if prices and (type(prices) == "table" and next(prices) ~= nil or type(prices) ~= "table") then
            sendPriceWebhook(prices)
        else
            log("No prices found in EipstenShop", "warning")
            sendFlaskMessage("⚠️ No prices found in merchant shop")
        end
        updateStatus("Idle")
    end
end

playerGui.ChildAdded:Connect(onMerchantShopAdded)

local function waitForMerchantAndInteract()
    updateStatus("Waiting for Childrens")
    log("Waiting for Traveling Childrens to load...", "info")
    
    local waitTime = 0
    local maxWait = 30
    local npc = nil
    
    while waitTime < maxWait do
        npc = workspace.NPCs:FindFirstChild("Traveling Merchant")
        if npc then
            log("Traveling Childrens found!", "success")
            break
        end
        task.wait(0.5)
        waitTime = waitTime + 0.5
    end
    
    if not npc then
        log("Traveling Childrens didn't load in time!", "error")
        updateStatus("Idle")
        return false
    end
    
    task.wait(1)
    
    local proximityPrompt = findProximityPrompt(npc)
    if proximityPrompt then
        updateStatus("Interacting")
        log("Activating proximity prompt...", "info")
        task.wait(0.1)
        fireproximityprompt(proximityPrompt)
        
        task.wait(0.2)
        merchantEvent:InvokeServer("OpenShop")
        log("Traveling Eipsten shop opened!", "success")
        
        task.wait(2)
        return true
    else
        log("No ProximityPrompt found in Traveling Merchant!", "error")
        updateStatus("Idle")
        return false
    end
end

local function tweenToMerchant()
    if not tweenEnabled then
        log("Tweening is disabled. Skipping tween.", "warning")
        updateStatus("Idle - Tweening Disabled")
        return false
    end
    
    shopOpened = false
    
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    local compassGuider = ReplicatedStorage:WaitForChild("CompassGuider")
    
    updateStatus("Searching for Childrens")
    log("Waiting for Traveling Childrens to appear in CompassGuider...", "info")
    sendFlaskMessage("Searching for Traveling Childrens...")
    local merchantGuider = nil
    local waitTime = 0
    local maxWait = 60
    
    while waitTime < maxWait do
        merchantGuider = compassGuider:FindFirstChild("Traveling Merchant")
        if merchantGuider then
            log("Traveling to Eipsten found in CompassGuider!", "success")
            sendFlaskMessage("Merchant located - preparing to travel")
            break
        end
        task.wait(1)
        waitTime = waitTime + 1
    end
    
    if not merchantGuider then
        log("Traveling Merchant guider not found in CompassGuider after waiting!", "error")
        updateStatus("Idle")
        return false
    end
    
    local targetPosition
    if merchantGuider:IsA("Vector3Value") then
        targetPosition = merchantGuider.Value
    elseif merchantGuider:IsA("CFrameValue") then
        targetPosition = merchantGuider.Value.Position
    elseif merchantGuider:FindFirstChild("Position") then
        targetPosition = merchantGuider.Position.Value
    else
        targetPosition = merchantGuider.Value
    end
    
    if not targetPosition then
        log("Could not get position from Traveling Merchant guider!", "error")
        updateStatus("Idle")
        return false
    end
    
    log("Target position: " .. tostring(targetPosition), "info")
    
    if targetPosition == Vector3.new(0, 0, 0) or targetPosition.Magnitude < 1 then
        log("Target position is 0,0,0 - merchant not spawned yet. Skipping tween.", "warning")
        updateStatus("Idle")
        return false
    end
    
    local targetCFrame = CFrame.new(targetPosition)
    
    local distance = (targetPosition - humanoidRootPart.Position).Magnitude
    local speed = 100
    local tweenTime = distance / speed
    
    updateStatus("Tweening to Eipsten")
    log("Tweening to Eipsten location...", "info")
    log("Distance: " .. string.format("%.1f", distance) .. " studs | Time: " .. string.format("%.1f", tweenTime) .. " seconds", "info")
    sendFlaskMessage(string.format("Traveling %.0f studs to merchant (ETA: %.0fs)", distance, tweenTime))
    
    local dashLoop = coroutine.create(function()
        while true do
            dashEvent:FireServer(0.5, "dash")
            task.wait(0.2)
        end
    end)
    coroutine.resume(dashLoop)
    
    local tweenInfo = TweenInfo.new(
        tweenTime,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut,
        0,
        false,
        0
    )
    
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    tween.Completed:Wait()
    log("Arrived at Eipsten Island!", "success")
    sendFlaskMessage("Arrived at merchant - interacting...")
    
    task.wait(1)
    
    return waitForMerchantAndInteract()
end

log("Script initialized successfully", "success")

-- Independent 15-minute teleport timer (runs regardless of any conditions)
task.spawn(function()
    while true do
        local elapsed = os.time() - startTime
        
        -- Check if playtime reached 15 minutes (900 seconds)
        if elapsed >= 900 then
            log("Playtime reached 15 minutes - teleporting to game 1730877806", "warning")
            task.wait(1)
            TeleportService:Teleport(1730877806, player)
            break -- Exit loop after teleport
        end
        
        task.wait(1) -- Check every second
    end
end)

-- Main loop
while true do
    local success = tweenToMerchant()
    
    if success then
        log("Successfully interacted with merchant! Waiting before next loop...", "success")
        wait(5)
    else
        log("Failed to interact with merchant. Retrying in 3 seconds...", "warning")
        wait(3)
    end
end
