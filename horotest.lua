local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChildrenDetectorGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 450)
frame.Position = UDim2.new(0.5, -200, 0.5, -225)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Children Detector"
title.TextColor3 = Color3.fromRGB(200, 150, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -40, 0, 35)
tabContainer.Position = UDim2.new(0, 20, 0, 45)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = frame

local detectorTab = Instance.new("TextButton")
detectorTab.Size = UDim2.new(0.31, 0, 1, 0)
detectorTab.Position = UDim2.new(0, 0, 0, 0)
detectorTab.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
detectorTab.Text = "Detector"
detectorTab.TextColor3 = Color3.new(1, 1, 1)
detectorTab.Font = Enum.Font.GothamBold
detectorTab.TextSize = 14
detectorTab.Parent = tabContainer

local detectorCorner = Instance.new("UICorner")
detectorCorner.CornerRadius = UDim.new(0, 6)
detectorCorner.Parent = detectorTab

local savedTab = Instance.new("TextButton")
savedTab.Size = UDim2.new(0.31, 0, 1, 0)
savedTab.Position = UDim2.new(0.345, 0, 0, 0)
savedTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
savedTab.Text = "Saved (0)"
savedTab.TextColor3 = Color3.new(1, 1, 1)
savedTab.Font = Enum.Font.GothamBold
savedTab.TextSize = 14
savedTab.Parent = tabContainer

local savedCorner = Instance.new("UICorner")
savedCorner.CornerRadius = UDim.new(0, 6)
savedCorner.Parent = savedTab

local stackTab = Instance.new("TextButton")
stackTab.Size = UDim2.new(0.31, 0, 1, 0)
stackTab.Position = UDim2.new(0.69, 0, 0, 0)
stackTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
stackTab.Text = "Stack"
stackTab.TextColor3 = Color3.new(1, 1, 1)
stackTab.Font = Enum.Font.GothamBold
stackTab.TextSize = 14
stackTab.Parent = tabContainer

local stackCorner = Instance.new("UICorner")
stackCorner.CornerRadius = UDim.new(0, 6)
stackCorner.Parent = stackTab

local detectorContent = Instance.new("Frame")
detectorContent.Size = UDim2.new(1, 0, 1, -90)
detectorContent.Position = UDim2.new(0, 0, 0, 90)
detectorContent.BackgroundTransparency = 1
detectorContent.Visible = true
detectorContent.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Waiting for Mini Hollow Barrage..."
statusLabel.TextColor3 = Color3.fromRGB(200, 160, 255)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = detectorContent

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -40, 1, -120)
scrollFrame.Position = UDim2.new(0, 20, 0, 40)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = detectorContent

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 8)
corner2.Parent = scrollFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollFrame

local detectorBtnContainer = Instance.new("Frame")
detectorBtnContainer.Size = UDim2.new(1, -40, 0, 40)
detectorBtnContainer.Position = UDim2.new(0, 20, 1, -50)
detectorBtnContainer.BackgroundTransparency = 1
detectorBtnContainer.Parent = detectorContent

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(1, 0, 1, 0)
saveBtn.Position = UDim2.new(0, 0, 0, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
saveBtn.Text = "Save Selected"
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 14
saveBtn.Parent = detectorBtnContainer

local saveBtnCorner = Instance.new("UICorner")
saveBtnCorner.CornerRadius = UDim.new(0, 8)
saveBtnCorner.Parent = saveBtn

local savedContent = Instance.new("Frame")
savedContent.Size = UDim2.new(1, 0, 1, -90)
savedContent.Position = UDim2.new(0, 0, 0, 90)
savedContent.BackgroundTransparency = 1
savedContent.Visible = false
savedContent.Parent = frame

local savedInfoLabel = Instance.new("TextLabel")
savedInfoLabel.Size = UDim2.new(1, -40, 0, 30)
savedInfoLabel.Position = UDim2.new(0, 20, 0, 0)
savedInfoLabel.BackgroundTransparency = 1
savedInfoLabel.Text = "Select remotes to fire (0 selected)"
savedInfoLabel.TextColor3 = Color3.fromRGB(200, 160, 255)
savedInfoLabel.Font = Enum.Font.Gotham
savedInfoLabel.TextSize = 14
savedInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
savedInfoLabel.Parent = savedContent

local savedScrollFrame = Instance.new("ScrollingFrame")
savedScrollFrame.Size = UDim2.new(1, -40, 1, -170)
savedScrollFrame.Position = UDim2.new(0, 20, 0, 40)
savedScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
savedScrollFrame.BorderSizePixel = 0
savedScrollFrame.ScrollBarThickness = 6
savedScrollFrame.Parent = savedContent

local savedCorner2 = Instance.new("UICorner")
savedCorner2.CornerRadius = UDim.new(0, 8)
savedCorner2.Parent = savedScrollFrame

local savedListLayout = Instance.new("UIListLayout")
savedListLayout.Padding = UDim.new(0, 5)
savedListLayout.Parent = savedScrollFrame

local savedBtnContainer = Instance.new("Frame")
savedBtnContainer.Size = UDim2.new(1, -40, 0, 90)
savedBtnContainer.Position = UDim2.new(0, 20, 1, -100)
savedBtnContainer.BackgroundTransparency = 1
savedBtnContainer.Parent = savedContent

local selectAllBtn = Instance.new("TextButton")
selectAllBtn.Size = UDim2.new(1, 0, 0, 35)
selectAllBtn.Position = UDim2.new(0, 0, 0, 0)
selectAllBtn.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
selectAllBtn.Text = "Select All"
selectAllBtn.TextColor3 = Color3.new(1, 1, 1)
selectAllBtn.Font = Enum.Font.GothamBold
selectAllBtn.TextSize = 14
selectAllBtn.Parent = savedBtnContainer

local selectAllCorner = Instance.new("UICorner")
selectAllCorner.CornerRadius = UDim.new(0, 8)
selectAllCorner.Parent = selectAllBtn

local fireSelectedBtn = Instance.new("TextButton")
fireSelectedBtn.Size = UDim2.new(0.48, 0, 0, 35)
fireSelectedBtn.Position = UDim2.new(0, 0, 0, 45)
fireSelectedBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
fireSelectedBtn.Text = "Fire Selected"
fireSelectedBtn.TextColor3 = Color3.new(1, 1, 1)
fireSelectedBtn.Font = Enum.Font.GothamBold
fireSelectedBtn.TextSize = 14
fireSelectedBtn.Parent = savedBtnContainer

local fireSelectedCorner = Instance.new("UICorner")
fireSelectedCorner.CornerRadius = UDim.new(0, 8)
fireSelectedCorner.Parent = fireSelectedBtn

local clearAllBtn = Instance.new("TextButton")
clearAllBtn.Size = UDim2.new(0.48, 0, 0, 35)
clearAllBtn.Position = UDim2.new(0.52, 0, 0, 45)
clearAllBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
clearAllBtn.Text = "Clear All"
clearAllBtn.TextColor3 = Color3.new(1, 1, 1)
clearAllBtn.Font = Enum.Font.GothamBold
clearAllBtn.TextSize = 14
clearAllBtn.Parent = savedBtnContainer

local clearBtnCorner = Instance.new("UICorner")
clearBtnCorner.CornerRadius = UDim.new(0, 8)
clearBtnCorner.Parent = clearAllBtn

local stackContent = Instance.new("Frame")
stackContent.Size = UDim2.new(1, 0, 1, -90)
stackContent.Position = UDim2.new(0, 0, 0, 90)
stackContent.BackgroundTransparency = 1
stackContent.Visible = false
stackContent.Parent = frame

local stackInfoLabel = Instance.new("TextLabel")
stackInfoLabel.Size = UDim2.new(1, -40, 0, 50)
stackInfoLabel.Position = UDim2.new(0, 20, 0, 10)
stackInfoLabel.BackgroundTransparency = 1
stackInfoLabel.Text = "Auto-stack Mini Hollow Barrage\nWill auto-fire at 5 saved remotes"
stackInfoLabel.TextColor3 = Color3.fromRGB(200, 160, 255)
stackInfoLabel.Font = Enum.Font.Gotham
stackInfoLabel.TextSize = 13
stackInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
stackInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
stackInfoLabel.Parent = stackContent

local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(1, -40, 0, 60)
toggleFrame.Position = UDim2.new(0, 20, 0, 80)
toggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
toggleFrame.BorderSizePixel = 0
toggleFrame.Parent = stackContent

local toggleFrameCorner = Instance.new("UICorner")
toggleFrameCorner.CornerRadius = UDim.new(0, 8)
toggleFrameCorner.Parent = toggleFrame

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
toggleLabel.Position = UDim2.new(0, 15, 0, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "Auto-Stack Toggle"
toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
toggleLabel.Font = Enum.Font.GothamBold
toggleLabel.TextSize = 16
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.Parent = toggleFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 80, 0, 40)
toggleButton.Position = UDim2.new(1, -95, 0.5, -20)
toggleButton.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.Parent = toggleFrame

local toggleButtonCorner = Instance.new("UICorner")
toggleButtonCorner.CornerRadius = UDim.new(0, 8)
toggleButtonCorner.Parent = toggleButton

local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, -40, 0, 180)
statusFrame.Position = UDim2.new(0, 20, 0, 160)
statusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = stackContent

local statusFrameCorner = Instance.new("UICorner")
statusFrameCorner.CornerRadius = UDim.new(0, 8)
statusFrameCorner.Parent = statusFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 1, -20)
statusText.Position = UDim2.new(0, 10, 0, 10)
statusText.BackgroundTransparency = 1
statusText.Text = "Status: Idle\nSaved Remotes: 0 / 5\nNext stack in: --"
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.Font = Enum.Font.GothamMedium
statusText.TextSize = 14
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.TextYAlignment = Enum.TextYAlignment.Top
statusText.Parent = statusFrame

local detectedChildren = {}
local selectedRemote = nil
local savedRemotes = {}
local selectedSavedRemotes = {}
local beforeChildren = {}
local skillUsed = false
local lastUpdateTime = 0
local currentTab = "detector"
local stackEnabled = false
local stackCoroutine = nil

local function getLeftFootCFrame()
    local success, result = pcall(function()
        local neptune = game.Workspace.NPCs:FindFirstChild("Neptune")
        if neptune then
            local leftFoot = neptune:FindFirstChild("LeftFoot")
            if leftFoot then
                return leftFoot.CFrame
            end
        end
        return nil
    end)
    
    if success and result then
        return result
    else
        warn("Could not find Neptune's LeftFoot, using default CFrame")
        return CFrame.new(7701.2685546875, -2120.7578125, -17487.412109375, 0.97690010070801, -0.11853301525116, 0.17780967056751, -7.4505814851022e-09, 0.83206498622894, 0.55467826128006, -0.21369689[...]
    end
end

local function fireAllSavedRemotes()
    if #savedRemotes == 0 then
        return
    end
    
    local wasStackEnabled = stackEnabled
    if stackEnabled then
        stackEnabled = false
        if stackCoroutine then
            task.cancel(stackCoroutine)
            stackCoroutine = nil
        end
        toggleButton.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
        toggleButton.Text = "OFF"
    end
    
    local leftFootCFrame = getLeftFootCFrame()
    local cfData = {
        cf = leftFootCFrame
    }
    
    local firedCount = 0
    local remotesToFire = {}
    
    for _, remote in ipairs(savedRemotes) do
        table.insert(remotesToFire, remote)
    end
    
    savedRemotes = {}
    selectedSavedRemotes = {}
    refreshSavedList()
    updateSelectedCount()
    
    if stackContent.Visible then
        statusText.Text = string.format("Status: Firing %d remotes...\nAuto-stack paused", #remotesToFire)
    end
    
    task.spawn(function()
        for i, remote in ipairs(remotesToFire) do
            local success = pcall(function()
                remote:InvokeServer(cfData)
            end)
            
            if success then
                firedCount = firedCount + 1
            end
            
            if stackContent.Visible then
                statusText.Text = string.format("Status: Firing remotes...\nFired: %d / %d", firedCount, #remotesToFire)
            end
            
            if i < #remotesToFire then
                local delay = math.random(30, 50) / 10
                task.wait(delay)
            end
        end
        
        if wasStackEnabled then
            stackEnabled = true
            toggleButton.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
            toggleButton.Text = "ON"
            
            stackCoroutine = task.spawn(function()
                while stackEnabled do
                    task.wait(5)
                    if stackEnabled then
                        local success = pcall(function()
                            local Event = game:GetService("ReplicatedStorage").Events.Skill
                            Event:InvokeServer("Mini Hollow Barrage")
                        end)
                        
                        if success and stackContent.Visible then
                            statusText.Text = string.format("Status: Running\nSaved Remotes: %d / 5\nNext stack in: 5s", #savedRemotes)
                        end
                    end
                end
            end)
        end
        
        if stackContent.Visible then
            statusText.Text = string.format("Status: %s\nFired all %d remotes!\nSaved Remotes: 0 / 5", 
                stackEnabled and "Running" or "Idle", firedCount)
            task.wait(2)
            updateSavedTabCount()
        end
    end)
end

local function updateSavedTabCount()
    savedTab.Text = "Saved (" .. #savedRemotes .. ")"
    
    if stackContent.Visible then
        local statusLines = {
            "Status: " .. (stackEnabled and "Running" or "Idle"),
            "Saved Remotes: " .. #savedRemotes .. " / 5",
            stackEnabled and "Next stack in: 5s" or "Next stack in: --"
        }
        statusText.Text = table.concat(statusLines, "\n")
    end
    
    if #savedRemotes >= 5 and stackEnabled then
        fireAllSavedRemotes()
    end
end

local function updateSelectedCount()
    local count = 0
    for _ in pairs(selectedSavedRemotes) do
        count = count + 1
    end
    savedInfoLabel.Text = string.format("Select remotes to fire (%d selected)", count)
end

local function createChildButton(child, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = string.format("[%d] %s", index, child.Name)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = scrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        selectedRemote = child
        for _, button in pairs(scrollFrame:GetChildren()) do
            if button:IsA("TextButton") then
                button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
        statusLabel.Text = "Selected: " .. child.Name
    end)
    
    return btn
end

local function createSavedButton(remote, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = string.format("[%d] %s", index, remote.Name)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = savedScrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = btn
    
    if selectedSavedRemotes[remote] then
        btn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    end
    
    btn.MouseButton1Click:Connect(function()
        if selectedSavedRemotes[remote] then
            selectedSavedRemotes[remote] = nil
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        else
            selectedSavedRemotes[remote] = true
            btn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
        end
        updateSelectedCount()
    end)
    
    return btn
end

local function refreshSavedList()
    for _, child in pairs(savedScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for i, r in ipairs(savedRemotes) do
        createSavedButton(r, i)
    end
    
    savedScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #savedRemotes * 40)
    updateSavedTabCount()
end

local function getCurrentChildren()
    local children = {}
    for _, child in pairs(ReplicatedStorage:GetChildren()) do
        children[child] = true
    end
    return children
end

beforeChildren = getCurrentChildren()

detectorTab.MouseButton1Click:Connect(function()
    currentTab = "detector"
    detectorContent.Visible = true
    savedContent.Visible = false
    stackContent.Visible = false
    detectorTab.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
    savedTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    stackTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
end)

savedTab.MouseButton1Click:Connect(function()
    currentTab = "saved"
    detectorContent.Visible = false
    savedContent.Visible = true
    stackContent.Visible = false
    detectorTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    savedTab.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
    stackTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
end)

stackTab.MouseButton1Click:Connect(function()
    currentTab = "stack"
    detectorContent.Visible = false
    savedContent.Visible = false
    stackContent.Visible = true
    detectorTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    savedTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    stackTab.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
    updateSavedTabCount()
end)

saveBtn.MouseButton1Click:Connect(function()
    if selectedRemote and selectedRemote:IsA("RemoteEvent") then
        local alreadySaved = false
        for _, r in ipairs(savedRemotes) do
            if r == selectedRemote then
                alreadySaved = true
                break
            end
        end
        
        if not alreadySaved then
            table.insert(savedRemotes, selectedRemote)
            refreshSavedList()
            
            statusLabel.Text = "Remote saved!"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            task.wait(2)
            statusLabel.TextColor3 = Color3.fromRGB(200, 160, 255)
            statusLabel.Text = "Selected: " .. selectedRemote.Name
        else
            statusLabel.Text = "Remote already saved!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
            task.wait(2)
            statusLabel.TextColor3 = Color3.fromRGB(200, 160, 255)
            statusLabel.Text = "Selected: " .. selectedRemote.Name
        end
    else
        statusLabel.Text = "No remote selected!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(2)
        statusLabel.TextColor3 = Color3.fromRGB(200, 160, 255)
        statusLabel.Text = "Waiting for Mini Hollow Barrage..."
    end
end)

selectAllBtn.MouseButton1Click:Connect(function()
    local allSelected = true
    
    for _, remote in ipairs(savedRemotes) do
        if not selectedSavedRemotes[remote] then
            allSelected = false
            break
        end
    end
    
    if allSelected then
        selectedSavedRemotes = {}
        selectAllBtn.Text = "Select All"
    else
        for _, remote in ipairs(savedRemotes) do
            selectedSavedRemotes[remote] = true
        end
        selectAllBtn.Text = "Deselect All"
    end
    
    refreshSavedList()
    updateSelectedCount()
end)

fireSelectedBtn.MouseButton1Click:Connect(function()
    local remotesToFire = {}
    for remote in pairs(selectedSavedRemotes) do
        table.insert(remotesToFire, remote)
    end
    
    if #remotesToFire == 0 then
        savedInfoLabel.Text = "No remotes selected!"
        savedInfoLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(2)
        savedInfoLabel.TextColor3 = Color3.fromRGB(200, 160, 255)
        updateSelectedCount()
        return
    end
    
    local leftFootCFrame = getLeftFootCFrame()
    local cfData = {
        cf = leftFootCFrame
    }
    
    selectedSavedRemotes = {}
    
    savedInfoLabel.Text = string.format("Firing %d remotes chronologically...", #remotesToFire)
    savedInfoLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    
    task.spawn(function()
        local firedCount = 0
        local failedCount = 0
        
        for i, remote in ipairs(remotesToFire) do
            local success, err = pcall(function()
                remote:InvokeServer(cfData)
            end)
            
            if success then
                firedCount = firedCount + 1
                
                for j, r in ipairs(savedRemotes) do
                    if r == remote then
                        table.remove(savedRemotes, j)
                        break
                    end
                end
            else
                failedCount = failedCount + 1
            end
            
            savedInfoLabel.Text = string.format("Firing: %d / %d (Success: %d, Failed: %d)", 
                i, #remotesToFire, firedCount, failedCount)
            
            if i < #remotesToFire then
                local delay = math.random(30, 50) / 10
                task.wait(delay)
            end
        end
        
        refreshSavedList()
        updateSelectedCount()
        
        savedInfoLabel.Text = string.format("Fired: %d | Failed: %d | Cleared after firing", firedCount, failedCount)
        savedInfoLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(3)
        savedInfoLabel.TextColor3 = Color3.fromRGB(200, 160, 255)
        updateSelectedCount()
    end)
end)

clearAllBtn.MouseButton1Click:Connect(function()
    savedRemotes = {}
    selectedSavedRemotes = {}
    refreshSavedList()
    updateSelectedCount()
    
    savedInfoLabel.Text = "All remotes cleared!"
    savedInfoLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    task.wait(2)
    savedInfoLabel.TextColor3 = Color3.fromRGB(200, 160, 255)
    updateSelectedCount()
end)

toggleButton.MouseButton1Click:Connect(function()
    stackEnabled = not stackEnabled
    
    if stackEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
        toggleButton.Text = "ON"
        
        if stackCoroutine then
            task.cancel(stackCoroutine)
        end
        
        stackCoroutine = task.spawn(function()
            while stackEnabled do
                task.wait(5)
                if stackEnabled then
                    local success = pcall(function()
                        local Event = game:GetService("ReplicatedStorage").Events.Skill
                        Event:InvokeServer("Mini Hollow Barrage")
                    end)
                    
                    if success and stackContent.Visible then
                        statusText.Text = string.format("Status: Running\nSaved Remotes: %d / 5\nNext stack in: 5s", #savedRemotes)
                    end
                end
            end
        end)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
        toggleButton.Text = "OFF"
        
        if stackCoroutine then
            task.cancel(stackCoroutine)
            stackCoroutine = nil
        end
    end
    
    updateSavedTabCount()
end)

local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "InvokeServer" and args[1] == "Mini Hollow Barrage" then
        skillUsed = true
        statusLabel.Text = "Detected! Monitoring for new children..."
    end
    
    return originalNamecall(self, ...)
end)

game:GetService("RunService").Heartbeat:Connect(function()
    local currentTime = tick()
    
    if currentTime - lastUpdateTime >= 1 then
        lastUpdateTime = currentTime
        
        if skillUsed then
            local afterChildren = getCurrentChildren()
            local newChildren = {}
            
            local usernamePattern = player.Name .. "|ServerScriptService.Skills.Skills.SkillContainer.Horo-Horo.Mini Hollow Barrage"
            
            for child in pairs(afterChildren) do
                if not beforeChildren[child] and child:IsA("RemoteEvent") and child.Name == usernamePattern then
                    table.insert(newChildren, child)
                end
            end
            
            if #newChildren ~= #detectedChildren then
                if #newChildren > 0 then
                    for _, newRemote in ipairs(newChildren) do
                        local alreadySaved = false
                        for _, r in ipairs(savedRemotes) do
                            if r == newRemote then
                                alreadySaved = true
                                break
                            end
                        end
                        
                        if not alreadySaved then
                            table.insert(savedRemotes, newRemote)
                        end
                    end
                    
                    refreshSavedList()
                end
                
                for _, child in pairs(scrollFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                detectedChildren = newChildren
                
                if #newChildren > 0 then
                    statusLabel.Text = string.format("Found %d new children! (Auto-updating...)", #newChildren)
                    
                    for i, child in ipairs(newChildren) do
                        createChildButton(child, i)
                    end
                    
                    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #newChildren * 40)
                else
                    statusLabel.Text = "No new children detected (Monitoring...)"
                end
            end
            
            beforeChildren = afterChildren
        end
    end
end)

print("Children Detector GUI loaded!")
