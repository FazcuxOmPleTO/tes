Starshot = {}

-- Função de utilidade pra criar UI com drag
local function setupDraggable(ui)
    local userInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos
    ui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    ui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragging then
            local delta = input.Position - dragStart
            ui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- CreateTab ajustado
Starshot.CreateTab = function(name, subtitle, password, requirePassword, theme)
    local screenGui = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    local uiCorner = Instance.new("UICorner")
    local title = Instance.new("TextLabel")
    local subtitleLabel = Instance.new("TextLabel")
    local tabHolder = Instance.new("Frame")
    local uiListLayout = Instance.new("UIListLayout") -- Adicionado pra organizar tabs
    local closeButton = Instance.new("TextButton")

    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 300, 0, 400) -- Tamanho base ajustável
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = themes[theme or "Light"].Background
    uiCorner.CornerRadius = UDim.new(0, 12)
    uiCorner.Parent = mainFrame

    title.Parent = mainFrame
    title.Size = UDim2.new(0, 200, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.Text = name
    title.TextColor3 = themes[theme or "Light"].Text
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.Gotham
    title.TextSize = 16

    subtitleLabel.Parent = mainFrame
    subtitleLabel.Size = UDim2.new(0, 200, 0, 20)
    subtitleLabel.Position = UDim2.new(0, 10, 0, 40)
    subtitleLabel.Text = subtitle
    subtitleLabel.TextColor3 = themes[theme or "Light"].Text
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextSize = 12

    tabHolder.Parent = mainFrame
    tabHolder.Size = UDim2.new(0, 280, 0, 30)
    tabHolder.Position = UDim2.new(0, 10, 0, 70)
    tabHolder.BackgroundTransparency = 1
    uiListLayout.Parent = tabHolder
    uiListLayout.FillDirection = Enum.FillDirection.Horizontal
    uiListLayout.Padding = UDim.new(0, 5)

    closeButton.Parent = mainFrame
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.Text = "X"
    closeButton.BackgroundColor3 = Color3.new(1, 0, 0)
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Adiciona drag
    setupDraggable(mainFrame)

    local tabs = {}
    local currentTab = nil

    local function createPasswordPrompt()
        -- [Código original de password prompt permanece igual, só ajusta tamanho pra mobile]
        local prompt = Instance.new("Frame")
        prompt.Size = UDim2.new(0, 250, 0, 150)
        -- ... resto do código de prompt
    end

    if requirePassword and password ~= "" then
        createPasswordPrompt()
    end

    local function addTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Parent = tabHolder
        tabButton.Size = UDim2.new(0, 80, 1, 0) -- Tamanho fixo pra mobile
        tabButton.Text = name
        tabButton.BackgroundColor3 = themes[theme or "Light"].TabInactive
        tabButton.TextColor3 = themes[theme or "Light"].Text
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then currentTab.Visible = false end
            currentTab = tabs[name]
            currentTab.Visible = true
            for _, btn in pairs(tabHolder:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = themes[theme or "Light"].TabInactive
                end
            end
            tabButton.BackgroundColor3 = themes[theme or "Light"].TabActive
        end)
        local content = Instance.new("Frame")
        content.Parent = mainFrame
        content.Size = UDim2.new(0, 280, 0, 300)
        content.Position = UDim2.new(0, 10, 0, 100)
        content.BackgroundTransparency = 1
        content.Visible = false
        local layout = Instance.new("UIListLayout")
        layout.Parent = content
        layout.Padding = UDim.new(0, 10)
        tabs[name] = content
        if not currentTab then
            tabButton.MouseButton1Click:Connect(function() end)()
        end
        return content
    end

    Starshot.AddTab = function(name)
        return addTab(name)
    end

    return {
        AddTab = addTab,
        ScreenGui = screenGui
    }
end

-- CreateSection ajustado
Starshot.CreateSection = function(tabName)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(0, 260, 0, 0) -- Ajuste dinâmico
    section.BackgroundColor3 = Color3.new(0, 0, 0)
    section.BackgroundTransparency = 0.7
    section.BorderSizePixel = 0
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = section
    local title = Instance.new("TextLabel")
    title.Parent = section
    title.Size = UDim2.new(0, 240, 0, 20)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.Text = tabName
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.Gotham
    title.TextSize = 14
    local layout = Instance.new("UIListLayout")
    layout.Parent = section
    layout.Padding = UDim.new(0, 5)
    local content = Instance.new("Frame")
    content.Parent = section
    content.Size = UDim2.new(0, 240, 0, 0)
    content.Position = UDim2.new(0, 10, 0, 30)
    content.BackgroundTransparency = 1
    layout.Parent = content -- Move layout pra content
    for _, tab in pairs(Starshot.CreateTab("temp", "", "", false).AddTab("temp"):GetChildren()) do
        if tab.Name == tabName then
            section.Parent = tab
            break
        end
    end
    return content
end

-- CreateButton ajustado
Starshot.CreateButton = function(section, text, callback)
    local button = Instance.new("TextButton")
    button.Parent = section
    button.Size = UDim2.new(0, 200, 0, 40) -- Maior pra mobile
    button.Text = text
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = button
    button.Activated:Connect(callback) -- Usa Activated pra touch
    return button
end

-- CreateToggle ajustado
Starshot.CreateToggle = function(section, text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Parent = section
    toggleFrame.Size = UDim2.new(0, 200, 0, 40)
    local toggleText = Instance.new("TextLabel")
    toggleText.Parent = toggleFrame
    toggleText.Size = UDim2.new(0, 160, 1, 0)
    toggleText.Position = UDim2.new(0, 0, 0, 0)
    toggleText.Text = text
    toggleText.TextColor3 = Color3.new(1, 1, 1)
    toggleText.BackgroundTransparency = 1
    toggleText.Font = Enum.Font.Gotham
    toggleText.TextSize = 14
    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = toggleFrame
    toggleButton.Size = UDim2.new(0, 30, 0, 20)
    toggleButton.Position = UDim2.new(0, 170, 0, 10)
    toggleButton.Text = default and "On" or "Off"
    toggleButton.BackgroundColor3 = default and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = toggleButton
    toggleButton.Activated:Connect(function()
        local state = not (toggleButton.Text == "On")
        toggleButton.Text = state and "On" or "Off"
        toggleButton.BackgroundColor3 = state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        callback(state)
    end)
    return toggleFrame
end

-- CreateSlider ajustado
Starshot.CreateSlider = function(section, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = section
    sliderFrame.Size = UDim2.new(0, 200, 0, 50)
    local sliderText = Instance.new("TextLabel")
    sliderText.Parent = sliderFrame
    sliderText.Size = UDim2.new(0, 200, 0, 20)
    sliderText.Text = text .. ": " .. default
    sliderText.TextColor3 = Color3.new(1, 1, 1)
    sliderText.BackgroundTransparency = 1
    sliderText.Font = Enum.Font.Gotham
    sliderText.TextSize = 14
    local sliderBar = Instance.new("Frame")
    sliderBar.Parent = sliderFrame
    sliderBar.Size = UDim2.new(0, 200, 0, 10)
    sliderBar.Position = UDim2.new(0, 0, 0, 25)
    sliderBar.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 5)
    uiCorner.Parent = sliderBar
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBar
    sliderFill.Size = UDim2.new(0, (default - min) / (max - min) * 200, 1, 0)
    sliderFill.BackgroundColor3 = Color3.new(1, 0, 0)
    uiCorner:Clone().Parent = sliderFill
    local dragging = false
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    sliderBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragging then
            local sizeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / 200, 0, 1)
            local value = min + (max - min) * sizeX
            sliderFill.Size = UDim2.new(0, sizeX * 200, 1, 0)
            sliderText.Text = text .. ": " .. math.floor(value)
            callback(value)
        end
    end)
    return sliderFrame
end

-- [Resto das funções (Dropdown, TextLabel, Divider, Paragraph) seguem o mesmo padrão, ajustando Size pra 200x40 e usando Activated onde aplicável]
Starshot.CreateDropdown = function(section, text, options, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Parent = section
    dropdownFrame.Size = UDim2.new(0, 200, 0, 40)
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Parent = dropdownFrame
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.Text = text
    dropdownButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownButton.TextColor3 = Color3.new(1, 1, 1)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = dropdownButton
    -- [Código original de dropdown menu, ajusta tamanho dos itens pra 200x30]
    dropdownButton.Activated:Connect(function() end) -- Placeholder pra abrir
    return dropdownFrame
end

Starshot.CreateTextLabel = function(section, text)
    local label = Instance.new("TextLabel")
    label.Parent = section
    label.Size = UDim2.new(0, 200, 0, 30)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    return label
end

Starshot.CreateDivider = function(section)
    local divider = Instance.new("Frame")
    divider.Parent = section
    divider.Size = UDim2.new(0, 200, 0, 2)
    divider.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    return divider
end

Starshot.CreateParagraph = function(section, text)
    local para = Instance.new("TextLabel")
    para.Parent = section
    para.Size = UDim2.new(0, 200, 0, 60)
    para.Text = text
    para.TextColor3 = Color3.new(1, 1, 1)
    para.BackgroundTransparency = 1
    para.Font = Enum.Font.Gotham
    para.TextSize = 12
    para.TextWrapped = true
    return para
end
