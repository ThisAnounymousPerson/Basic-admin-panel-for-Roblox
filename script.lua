-- Function to create the Admin GUI
local function createAdminPanel(player)
    -- Create a ScreenGui
    local adminGUI = Instance.new("ScreenGui")
    adminGUI.Name = "AdminPanel"
    adminGUI.Parent = player.PlayerGui

    -- Create a Frame to hold UI elements
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 200)
    frame.Position = UDim2.new(0.05, 0, 0.05, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.2
    frame.Active = true -- Enable dragging
    frame.Draggable = true -- Enable dragging the frame
    frame.Parent = adminGUI

    -- Create a UICorner to give the frame rounded edges
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10) -- Rounded edges
    corner.Parent = frame

    -- Create a minimize button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 25, 0, 25)
    minimizeButton.Position = UDim2.new(1, -30, 0, 5)
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = Color3.new(1, 1, 1)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 14
    minimizeButton.Parent = frame

    -- Rounded corners for minimize button
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeButton

    -- Create a title label for the Admin Panel
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Text = "Admin Panel"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.BackgroundTransparency = 1 -- Transparent background
    titleLabel.Parent = frame

    -- Helper function to create buttons
    local function createButton(text, position, action)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.8, 0, 0, 30)
        button.Position = UDim2.new(0.1, 0, 0, position)
        button.Text = text
        button.TextColor3 = Color3.new(1, 1, 1)
        button.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
        button.Font = Enum.Font.Gotham
        button.TextSize = 14

        -- Rounded corners for button
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button

        -- Connect action to the button
        button.MouseButton1Click:Connect(action)

        button.Parent = frame
    end

    -- Fly function
    local flying = false
    local function toggleFly()
        if flying then
            flying = false
            player.Character.Humanoid.PlatformStand = false
        else
            flying = true
            player.Character.Humanoid.PlatformStand = true
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 50, 0)
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Parent = player.Character.HumanoidRootPart

            -- Fly loop
            spawn(function()
                while flying do
                    bodyVelocity.Velocity = player.Character.HumanoidRootPart.CFrame.LookVector * 50
                    wait()
                end
                bodyVelocity:Destroy()
            end)
        end
    end

    -- Noclip function
    local noclip = false
    local function toggleNoclip()
        noclip = not noclip
        if noclip then
            game:GetService("RunService").Stepped:Connect(function()
                if noclip then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end

    -- Infinite Jump function
    local infiniteJumpEnabled = false
    local function toggleInfiniteJump()
        infiniteJumpEnabled = not infiniteJumpEnabled
        if infiniteJumpEnabled then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if infiniteJumpEnabled then
                    player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
        end
    end

    -- Teleport Tool function
    local teleportTool = Instance.new("Tool")
    teleportTool.RequiresHandle = false
    teleportTool.Name = "TeleportTool"
    teleportTool.Parent = player.Backpack
    teleportTool.Activated:Connect(function()
        local mouse = player:GetMouse()
        local newPosition = mouse.Hit.p
        player.Character:SetPrimaryPartCFrame(CFrame.new(newPosition))
    end)

    -- Create the buttons
    createButton("Toggle Fly", 40, toggleFly)
    createButton("Toggle Noclip", 80, toggleNoclip)
    createButton("Toggle Infinite Jump", 120, toggleInfiniteJump)
    createButton("Teleport Tool", 160, function() print("Teleport Tool Enabled") end) -- Info that tool is added

    -- Minimize functionality
    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        if minimized then
            frame.Size = UDim2.new(0, 250, 0, 200) -- Restore size
            for _, child in pairs(frame:GetChildren()) do
                if not child:IsA("TextButton") or child ~= minimizeButton then
                    child.Visible = true
                end
            end
            minimizeButton.Text = "-"
            minimized = false
        else
            frame.Size = UDim2.new(0, 250, 0, 30) -- Minimized size
            for _, child in pairs(frame:GetChildren()) do
                if not child:IsA("TextButton") or child ~= minimizeButton then
                    child.Visible = false
                end
            end
            minimizeButton.Text = "+"
            minimized = true
        end
    end)
end

-- Function to trigger the Admin Panel creation when a player joins the game
game.Players.PlayerAdded:Connect(function(player)
    createAdminPanel(player)
end)
