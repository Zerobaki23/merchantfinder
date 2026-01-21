task.wait(10)
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Check if game ID matches
if game.PlaceId ~= 3978370137 then
    warn("This script only works in game ID 3978370137. Current game ID: " .. tostring(game.PlaceId))
    return
end

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local dashEvent = ReplicatedStorage.Events.takestam
local merchantEvent = ReplicatedStorage.Events.TravelingMerchentRemote

local webhookUtil = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/discordwebhook/src.lua"))()

-- Flask server configuration
local FLASK_SERVER = "http://192.168.100.96:5000"
local lastStockHash = nil
local flaskConnected = false

-- Auto rejoin if kicked
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

-- Disable collision for character parts
local function disableCollision(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Apply to current character
local character = player.Character or player.CharacterAdded:Wait()
disableCollision(character)

-- Apply to future characters (if player respawns)
player.CharacterAdded:Connect(function(newCharacter)
    disableCollision(newCharacter)
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MerchantTerminal"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 450)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = mainFrame

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

local headerBottom = Instance.new("Frame")
headerBottom.Size = UDim2.new(1, 0, 0, 8)
headerBottom.Position = UDim2.new(0, 0, 1, -8)
headerBottom.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
headerBottom.BorderSizePixel = 0
headerBottom.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Merchant Bot Terminal"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 14
title.Font = Enum.Font.Code
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 2.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.Code
minimizeBtn.Parent = header

local minimizeBtnCorner = Instance.new("UICorner")
minimizeBtnCorner.CornerRadius = UDim.new(0, 4)
minimizeBtnCorner.Parent = minimizeBtn

local logFrame = Instance.new("ScrollingFrame")
logFrame.Name = "LogFrame"
logFrame.Size = UDim2.new(1, -20, 1, -95)
logFrame.Position = UDim2.new(0, 10, 0, 45)
logFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
logFrame.BorderSizePixel = 0
logFrame.ScrollBarThickness = 6
logFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
logFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
logFrame.Parent = mainFrame

local logFrameCorner = Instance.new("UICorner")
logFrameCorner.CornerRadius = UDim.new(0, 4)
logFrameCorner.Parent = logFrame

local logLayout = Instance.new("UIListLayout")
logLayout.Padding = UDim.new(0, 2)
logLayout.SortOrder = Enum.SortOrder.LayoutOrder
logLayout.Parent = logFrame

local inputFrame = Instance.new("Frame")
inputFrame.Name = "InputFrame"
inputFrame.Size = UDim2.new(1, -20, 0, 35)
inputFrame.Position = UDim2.new(0, 10, 1, -45)
inputFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
inputFrame.BorderSizePixel = 0
inputFrame.Parent = mainFrame

local inputFrameCorner = Instance.new("UICorner")
inputFrameCorner.CornerRadius = UDim.new(0, 4)
inputFrameCorner.Parent = inputFrame

local inputBox = Instance.new("TextBox")
inputBox.Name = "InputBox"
inputBox.Size = UDim2.new(1, -10, 1, -10)
inputBox.Position = UDim2.new(0, 5, 0, 5)
inputBox.BackgroundTransparency = 1
inputBox.Text = ""
inputBox.PlaceholderText = "Type 'toggle' to enable/disable tweening..."
inputBox.TextColor3 = Color3.fromRGB(200, 200, 200)
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
inputBox.TextSize = 12
inputBox.Font = Enum.Font.Code
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.ClearTextOnFocus = false
inputBox.Parent = inputFrame

local logCount = 0
local isMinimized = false
local tweenEnabled = true
local is3dDisabled = false
local blackScreenGui = nil
local startTime = os.time()

local function formatPlaytime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02dh %02dm %02ds", hours, minutes, secs)
end

local function create3dDisabledScreen()
    local gui = Instance.new("ScreenGui")
    gui.Name = "3dDisabledScreen"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999999
    gui.Parent = playerGui
    
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BorderSizePixel = 0
    background.Parent = gui
    
    local discordLabel = Instance.new("TextLabel")
    discordLabel.Name = "DiscordLabel"
    discordLabel.Size = UDim2.new(0, 500, 0, 60)
    discordLabel.Position = UDim2.new(0.5, -250, 0.35, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "Merchant Farm"
    discordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordLabel.TextSize = 48
    discordLabel.Font = Enum.Font.GothamBold
    discordLabel.TextXAlignment = Enum.TextXAlignment.Center
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
    playtimeLabel.Parent = gui
    
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "UsernameLabel"
    usernameLabel.Size = UDim2.new(0, 500, 0, 40)
    usernameLabel.Position = UDim2.new(0.5, -250, 0.58, 0)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Text = "Name: " .. player.Name
    usernameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    usernameLabel.TextSize = 28
    usernameLabel.Font = Enum.Font.Gotham
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Center
    usernameLabel.Parent = gui
    
    RunService.RenderStepped:Connect(function()
        if is3dDisabled and playtimeLabel and playtimeLabel.Parent then
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
        log("3D Disabled mode ENABLED", "success")
    else
        if blackScreenGui then
            blackScreenGui:Destroy()
            blackScreenGui = nil
        end
        log("3D Disabled mode DISABLED", "warning")
    end
end

local function log(message, logType)
    logType = logType or "info"
    
    local colors = {
        info = Color3.fromRGB(200, 200, 200),
        success = Color3.fromRGB(100, 255, 100),
        warning = Color3.fromRGB(255, 200, 100),
        error = Color3.fromRGB(255, 100, 100)
    }
    
    local prefixes = {
        info = "[•]",
        success = "[✓]",
        warning = "[!]",
        error = "[✗]"
    }
    
    local timestamp = os.date("%H:%M:%S")
    local color = colors[logType] or colors.info
    local prefix = prefixes[logType] or prefixes.info
    
    local logLabel = Instance.new("TextLabel")
    logLabel.Name = "Log_" .. logCount
    logLabel.Size = UDim2.new(1, -10, 0, 18)
    logLabel.BackgroundTransparency = 1
    logLabel.Text = string.format("[%s] %s %s", timestamp, prefix, message)
    logLabel.TextColor3 = color
    logLabel.TextSize = 12
    logLabel.Font = Enum.Font.Code
    logLabel.TextXAlignment = Enum.TextXAlignment.Left
    logLabel.TextWrapped = true
    logLabel.AutomaticSize = Enum.AutomaticSize.Y
    logLabel.LayoutOrder = logCount
    logLabel.Parent = logFrame
    
    logCount = logCount + 1
    
    task.wait()
    logFrame.CanvasPosition = Vector2.new(0, logFrame.AbsoluteCanvasSize.Y)
end

-- Flask server communication functions
local function checkFlaskConnection()
    log("Attempting to connect to Flask server...", "info")
    
    local success, result = pcall(function()
        return HttpService:GetAsync(FLASK_SERVER .. "/ping", true)
    end)
    
    if success then
        flaskConnected = true
        log("Connected to Flask server!", "success")
        return true
    else
        flaskConnected = false
        log("Failed to connect to Flask server: " .. tostring(result), "error")
        log("Flask server may not be running on " .. FLASK_SERVER, "warning")
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
    
    if success then
        log("Sent to Flask: " .. endpoint, "success")
        return true
    else
        log("Failed to send to Flask: " .. tostring(result), "error")
        flaskConnected = false
        return false
    end
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

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame:TweenSize(UDim2.new(0, 600, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        minimizeBtn.Text = "□"
    else
        mainFrame:TweenSize(UDim2.new(0, 600, 0, 450), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        minimizeBtn.Text = "_"
    end
end)

inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local command = string.lower(string.gsub(inputBox.Text, "^%s*(.-)%s*$", "%1"))
        
        if command == "toggle" then
            tweenEnabled = not tweenEnabled
            if tweenEnabled then
                log("Tweening ENABLED", "success")
            else
                log("Tweening DISABLED", "warning")
            end
        elseif command == "toggle.3ddisabled" then
            toggle3dDisabled()
        elseif command == "status" then
            log("Tween Status: " .. (tweenEnabled and "ENABLED" or "DISABLED"), "info")
            log("Flask Status: " .. (flaskConnected and "CONNECTED" or "DISCONNECTED"), "info")
            log("3D Disabled: " .. (is3dDisabled and "ENABLED" or "DISABLED"), "info")
        elseif command == "reconnect" then
            checkFlaskConnection()
        elseif command == "toggle.flasktest" then
            local testStock = {
                ["Apple"] = 50,
                ["Banana"] = 75,
                ["Orange"] = 100,
                ["Mythical Fruit Chest"] = 5000,
                ["Golden Diamond"] = 2500,
                ["Silver Ingot"] = 350,
                ["Copper Ore"] = 25,
                ["Iron Bar"] = 150
            }
            
            local testData = {
                timestamp = os.time(),
                prices = testStock,
                formatted = "**TEST STOCK:**\n```\nApple - 50\nBanana - 75\nOrange - 100\nMythical Fruit Chest - 5000\nGolden Diamond - 2500\nSilver Ingot - 350\nCopper Ore - 25\nIron Bar - 150\n```"
            }
            
            if sendToFlask("/stock", testData) then
                log("Test stock sent to Flask successfully!", "success")
                sendFlaskMessage("📊 TEST STOCK SENT - Check localhost:5000")
            else
                log("Failed to send test stock to Flask", "error")
            end
        elseif command == "help" then
            log("Available commands:", "info")
            log("  toggle - Enable/disable tweening", "info")
            log("  toggle.3ddisabled - Toggle black screen mode", "info")
            log("  toggle.flasktest - Send test stock to Flask server", "info")
            log("  status - Check tween and Flask status", "info")
            log("  reconnect - Reconnect to Flask server", "info")
            log("  help - Show this message", "info")
        elseif command ~= "" then
            log("Unknown command: " .. command, "error")
            log("Type 'help' for available commands", "info")
        end
        
        inputBox.Text = ""
    end
end)

log("Terminal initialized", "success")
log("Collision disabled - noclip enabled", "success")

checkFlaskConnection()

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
                return game:GetService("HttpService"):JSONDecode(pricesAttr)
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

local function formatPrices(prices)
    local formatted = "**STOCK:**\n```\n"
    
    if type(prices) == "table" then
        for itemName, itemData in pairs(prices) do
            local price = itemData
            local quantity = 1
            
            if type(itemData) == "table" then
                price = itemData.price or itemData.Price or itemData.cost or itemData.Cost
                quantity = itemData.quantity or itemData.Quantity or itemData.stock or itemData.Stock or 1
            end
            
            formatted = formatted .. string.format("[-] %s - %s (x%d)\n", itemName, tostring(price), quantity)
        end
    else
        formatted = formatted .. "Price: " .. tostring(prices) .. "\n"
    end
    
    formatted = formatted .. "```"
    return formatted
end

local function sendPriceWebhook(prices)
    local currentHash = generateStockHash(prices)
    
    if currentHash == lastStockHash then
        log("Stock unchanged - skipping webhook and Flask update", "info")
        return
    end
    
    lastStockHash = currentHash
    log("New stock detected - sending updates", "success")
    
    local priceText = formatPrices(prices)
    local hasMythicalFruitChest = false
    local mythicalChestName = nil
    
    -- Count and send stock to /ping endpoint
    local stockCount = countStock(prices)
    sendToFlask("/ping", {stock = stockCount})
    log("Stock count sent to /ping: " .. stockCount, "success")
    
    -- Send full stock data to /stock endpoint
    local stockData = {
        timestamp = os.time(),
        prices = prices,
        formatted = priceText
    }
    sendToFlask("/stock", stockData)
    
    if type(prices) == "table" then
        for itemName, _ in pairs(prices) do
            local lowerName = string.lower(itemName)
            
            if lowerName:find("mythical") and lowerName:find("fruit") and lowerName:find("chest") then
                hasMythicalFruitChest = true
                mythicalChestName = itemName
                break
            end
        end
    end
    
    local content = priceText
    
    if hasMythicalFruitChest then
        content = "<@832942242498084888> " .. priceText
        log("Mythical Fruit Chest detected! Pinging user.", "success")
        sendFlaskMessage("🎁 MYTHICAL FRUIT CHEST DETECTED!")
        
        task.spawn(function()
            task.wait(1)
            log("Attempting to purchase Mythical Fruit Chest...", "info")
            
            local success, result = pcall(function()
                return merchantEvent:InvokeServer(mythicalChestName)
            end)
            
            if success then
                log("Successfully purchased Mythical Fruit Chest!", "success")
                sendFlaskMessage("✅ Purchased Mythical Fruit Chest!")
            else
                log("Failed to purchase: " .. tostring(result), "error")
                sendFlaskMessage("❌ Failed to purchase chest: " .. tostring(result))
            end
        end)
    end
    
    local myMessage = webhookUtil.createMessage({
        Url = "https://discord.com/api/webhooks/1265355595582537809/rAYW0kkZl4MnKE6Q-TcHPvncwdXJDY39y6d9nYcy54JUlmN8BCJXgxKGKKk3lKj8hPPe",
        username = "Merchant Shop Monitor",
        content = content
    })
    
    local response = myMessage.sendMessage()
    log("Webhook response: " .. tostring(response), "info")
    log("Prices sent to Discord!", "success")
end

local function findProximityPrompt(npc)
    for _, descendant in pairs(npc:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            return descendant
        end
    end
    return nil
end

local shopOpened = false

local function onMerchantShopAdded(child)
    if child.Name == "MerchentShop" and not shopOpened then
        shopOpened = true
        log("MerchentShop detected! Getting prices...", "success")
        sendFlaskMessage("Merchant shop opened - scanning stock...")
        task.wait(0.5)
        
        local prices = getPricesFromShop(child)
        
        if prices and (type(prices) == "table" and next(prices) ~= nil or type(prices) ~= "table") then
            sendPriceWebhook(prices)
        else
            log("No prices found in MerchentShop", "warning")
            sendFlaskMessage("⚠️ No prices found in merchant shop")
        end
    end
end

playerGui.ChildAdded:Connect(onMerchantShopAdded)

local function waitForMerchantAndInteract()
    log("Waiting for Traveling Merchant to load...", "info")
    
    local waitTime = 0
    local maxWait = 30
    local npc = nil
    
    while waitTime < maxWait do
        npc = workspace.NPCs:FindFirstChild("Traveling Merchant")
        if npc then
            log("Traveling Merchant found!", "success")
            break
        end
        task.wait(0.5)
        waitTime = waitTime + 0.5
    end
    
    if not npc then
        log("Traveling Merchant didn't load in time!", "error")
        return false
    end
    
    task.wait(1)
    
    local proximityPrompt = findProximityPrompt(npc)
    if proximityPrompt then
        log("Activating proximity prompt...", "info")
        task.wait(0.1)
        fireproximityprompt(proximityPrompt)
        
        task.wait(0.2)
        merchantEvent:InvokeServer("OpenShop")
        log("Traveling Merchant shop opened!", "success")
        
        task.wait(2)
        return true
    else
        log("No ProximityPrompt found in Traveling Merchant!", "error")
        return false
    end
end

local function tweenToMerchant()
    if not tweenEnabled then
        log("Tweening is disabled. Skipping tween.", "warning")
        return false
    end
    
    shopOpened = false
    
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    local compassGuider = ReplicatedStorage:WaitForChild("CompassGuider")
    
    log("Waiting for Traveling Merchant to appear in CompassGuider...", "info")
    sendFlaskMessage("Searching for Traveling Merchant...")
    local merchantGuider = nil
    local waitTime = 0
    local maxWait = 60
    
    while waitTime < maxWait do
        merchantGuider = compassGuider:FindFirstChild("Traveling Merchant")
        if merchantGuider then
            log("Traveling Merchant found in CompassGuider!", "success")
            sendFlaskMessage("Merchant located - preparing to travel")
            break
        end
        task.wait(1)
        waitTime = waitTime + 1
    end
    
    if not merchantGuider then
        log("Traveling Merchant guider not found in CompassGuider after waiting!", "error")
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
        return false
    end
    
    log("Target position: " .. tostring(targetPosition), "info")
    
    if targetPosition == Vector3.new(0, 0, 0) or targetPosition.Magnitude < 1 then
        log("Target position is 0,0,0 - merchant not spawned yet. Skipping tween.", "warning")
        return false
    end
    
    local targetCFrame = CFrame.new(targetPosition)
    
    local distance = (targetPosition - humanoidRootPart.Position).Magnitude
    local speed = 100
    local tweenTime = distance / speed
    
    log("Tweening to merchant location...", "info")
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
    log("Arrived at merchant location!", "success")
    sendFlaskMessage("Arrived at merchant - interacting...")
    
    task.wait(1)
    
    return waitForMerchantAndInteract()
end

log("Script initialized successfully", "success")
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
