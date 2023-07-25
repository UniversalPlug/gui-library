-- GuiLibrary.lua

local GuiLibrary = {}

local defaultGuiSize = UDim2.new(0, 400, 0, 300) -- Default size for the main GUI
local defaultGuiPosition = UDim2.new(0.5, -200, 0.5, -150) -- Default position for the main GUI

local menuVisible = true -- Variable to track the visibility of the GUI menu
local blurEffect = nil -- Variable to store the BlurEffect object

-- Keybinds table to store the created keybinds
local keybinds = {}

-- Create a new frame
function GuiLibrary.CreateFrame(name, parent, size, position, backgroundColor)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size or defaultGuiSize -- Use the default size if not provided
    frame.Position = position or defaultGuiPosition -- Use the default position if not provided
    frame.BackgroundColor3 = backgroundColor or Color3.new(1, 1, 1)
    frame.Parent = parent or nil

    return frame
end

-- Function to toggle the blur effect
function GuiLibrary.ToggleBlurEffect()
    local guiMenu = game.Players.LocalPlayer.PlayerGui.ExampleGui -- Update 'ExampleGui' with the name of your GUI

    if menuVisible then
        -- Enable blur effect
        if not blurEffect then
            blurEffect = Instance.new("BlurEffect")
            blurEffect.Parent = game.Lighting
            blurEffect.Size = 10
        end
    else
        -- Disable blur effect
        if blurEffect then
            blurEffect:Destroy()
            blurEffect = nil
        end
    end
end

-- Create a new dropdown
function GuiLibrary.CreateDropdown(name, parent, size, position, options, defaultOption, callback)
    local dropdown = Instance.new("Frame")
    dropdown.Name = name
    dropdown.Size = size or UDim2.new(0, 150, 0, 30)
    dropdown.Position = position or UDim2.new(0, 0, 0, 0)
    dropdown.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
    dropdown.BorderSizePixel = 1
    dropdown.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
    dropdown.Parent = parent or nil

    local dropdownLabel = Instance.new("TextLabel")
    dropdownLabel.Name = "Label"
    dropdownLabel.Size = UDim2.new(1, -20, 1, 0)
    dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Text = defaultOption or "Select an option"
    dropdownLabel.TextColor3 = Color3.new(0, 0, 0)
    dropdownLabel.Font = Enum.Font.SourceSans
    dropdownLabel.TextSize = 14
    dropdownLabel.Parent = dropdown

    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(0, 0, 0)
    arrow.Font = Enum.Font.SourceSans
    arrow.TextSize = 14
    arrow.Parent = dropdown

    local optionList = Instance.new("Frame")
    optionList.Name = "OptionList"
    optionList.Size = UDim2.new(1, 0, 0, 0)
    optionList.Position = UDim2.new(0, 0, 1, 0)
    optionList.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
    optionList.BorderSizePixel = 1
    optionList.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
    optionList.Visible = false
    optionList.Parent = dropdown

    local optionHeight = 25

    for _, optionText in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = optionText
        optionButton.Size = UDim2.new(1, 0, 0, optionHeight)
        optionButton.BackgroundTransparency = 1
        optionButton.Text = optionText
        optionButton.TextColor3 = Color3.new(0, 0, 0)
        optionButton.Font = Enum.Font.SourceSans
        optionButton.TextSize = 14
        optionButton.Parent = optionList

        optionHeight = optionHeight + 25

        -- Handle option selection
        optionButton.MouseButton1Click:Connect(function()
            dropdownLabel.Text = optionText
            optionList.Visible = false
            if callback then
                callback(optionText)
            end
        end)
    end

    -- Toggle the option list visibility when the arrow is clicked
    arrow.MouseButton1Click:Connect(function()
        optionList.Visible = not optionList.Visible
    end)

    -- Close the option list when clicking outside the dropdown
    game:GetService("UserInputService").InputBegan:Connect(function(input, isProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and optionList.Visible and not dropdown:IsAncestorOf(input.Target) then
            optionList.Visible = false
        end
    end)

    return dropdown
end

-- Function to create a new keybind
function GuiLibrary.CreateKeybind(name, keyCode, callback)
    local keybind = {
        Name = name,
        KeyCode = keyCode,
        Callback = callback,
        Enabled = true
    }

    table.insert(keybinds, keybind)

    return keybind
end

-- Function to enable or disable a keybind
function GuiLibrary.SetKeybindEnabled(keybind, isEnabled)
    if keybind and type(isEnabled) == "boolean" then
        keybind.Enabled = isEnabled
    end
end

-- Function to handle key press events
local function onKeyDown(input, gameProcessedEvent)
    if not gameProcessedEvent then
        for _, keybind in ipairs(keybinds) do
            if keybind.Enabled and input.KeyCode == keybind.KeyCode then
                keybind.Callback()
            end
        end
    end
end

-- Bind the key press event
game:GetService("UserInputService").InputBegan:Connect(onKeyDown)

-- Create a new button
function GuiLibrary.CreateButton(name, parent, size, position, text)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size or UDim2.new(0, 100, 0, 50)
    button.Position = position or UDim2.new(0, 0, 0, 0)
    button.Text = text or "Button"
    button.Parent = parent or nil

    return button
end

-- Create a new text label
function GuiLibrary.CreateTextLabel(name, parent, size, position, text)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = size or UDim2.new(0, 100, 0, 50)
    label.Position = position or UDim2.new(0, 0, 0, 0)
    label.Text = text or "Label"
    label.Parent = parent or nil

    return label
end

-- Create a new slider
function GuiLibrary.CreateSlider(name, parent, size, position, min, max, defaultValue)
    local slider = Instance.new("Frame")
    slider.Name = name
    slider.Size = size or UDim2.new(0, 200, 0, 20)
    slider.Position = position or UDim2.new(0, 0, 0, 0)
    slider.BackgroundColor3 = Color3.new(0, 0, 0)
    slider.BorderSizePixel = 1
    slider.BorderColor3 = Color3.new(1, 1, 1)
    slider.Parent = parent or nil

    local sliderHandle = Instance.new("Frame")
    sliderHandle.Name = "Handle"
    sliderHandle.Size = UDim2.new(0, 20, 0, 20)
    sliderHandle.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    sliderHandle.Parent = slider

    local sliderValue = Instance.new("NumberValue")
    sliderValue.Name = "Value"
    sliderValue.Value = defaultValue or 0
    sliderValue.Parent = slider

    -- Function to update the slider value based on the handle's position
    local function updateSliderValue()
        local percentage = (sliderHandle.Position.X.Offset - slider.Position.X.Offset) / (slider.Size.X.Offset - sliderHandle.Size.X.Offset)
        local value = min + (max - min) * percentage
        sliderValue.Value = value
    end

    -- Function to handle the mouse dragging on the slider handle
    local function onDrag(input)
        local relativeX = input.Position.X - slider.AbsolutePosition.X
        relativeX = math.clamp(relativeX, 0, slider.Size.X.Offset - sliderHandle.Size.X.Offset)
        sliderHandle.Position = UDim2.new(0, relativeX, 0, 0)
        updateSliderValue()
    end

    -- Bind mouse events for slider interaction
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            onDrag(input)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    input = sliderHandle.InputChanged:Connect(onDrag)
                end
            end)
        end
    end)

    sliderHandle.InputChanged:Connect(onDrag)

    return slider, sliderValue
end

-- Create a new input box
function GuiLibrary.CreateInputBox(name, parent, size, position)
    local inputBox = Instance.new("TextBox")
    inputBox.Name = name
    inputBox.Size = size or UDim2.new(0, 150, 0, 20)
    inputBox.Position = position or UDim2.new(0.5, -75, 0.5, -10)
    inputBox.BackgroundColor3 = Color3.new(1, 1, 1)
    inputBox.TextColor3 = Color3.new(0, 0, 0)
    inputBox.Font = Enum.Font.SourceSans
    inputBox.TextSize = 14
    inputBox.PlaceholderText = "Enter text..."
    inputBox.Parent = parent or nil

    -- Function to handle the user confirming their input
    local function onInputConfirmed()
        return inputBox.Text
    end

    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            -- The user confirmed their input
            local inputValue = onInputConfirmed()
            print("Input Value:", inputValue) -- You can use this value as needed (e.g., save it, display it, etc.)
        end
    end)

    return inputBox
end

-- Create a new image label
function GuiLibrary.CreateImageLabel(name, parent, size, position, image)
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Name = name
    imageLabel.Size = size or UDim2.new(0, 100, 0, 100)
    imageLabel.Position = position or UDim2.new(0, 0, 0, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = image or ""
    imageLabel.Parent = parent or nil

    return imageLabel
end

-- Function to modify the size and position of the main GUI
function GuiLibrary:SetMainGuiSizeAndPosition(size, position)
    defaultGuiSize = size or defaultGuiSize
    defaultGuiPosition = position or defaultGuiPosition
end

-- Create a new tab system
function GuiLibrary.CreateTabSystem(name, parent, size, position)
    local tabSystem = Instance.new("Frame")
    tabSystem.Name = name
    tabSystem.Size = size or UDim2.new(0, 400, 0, 300)
    tabSystem.Position = position or UDim2.new(0.5, -200, 0.5, -150)
    tabSystem.BackgroundTransparency = 1
    tabSystem.Parent = parent or nil

    local tabs = Instance.new("Frame")
    tabs.Name = "Tabs"
    tabs.Size = UDim2.new(1, 0, 0, 50)
    tabs.Position = UDim2.new(0, 0, 0, 0)
    tabs.BackgroundTransparency = 1
    tabs.Parent = tabSystem

    local contents = Instance.new("Frame")
    contents.Name = "Contents"
    contents.Size = UDim2.new(1, 0, 1, -50)
    contents.Position = UDim2.new(0, 0, 0, 50)
    contents.BackgroundTransparency = 1
    contents.Parent = tabSystem

    local tabButtons = {} -- Table to store tab buttons
    local tabContents = {} -- Table to store tab contents

    -- Function to switch to the selected tab
    local function switchTab(tabIndex)
        for index, tabContent in pairs(tabContents) do
            if index == tabIndex then
                tabButtons[index].BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
                tabContent.Visible = true
            else
                tabButtons[index].BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
                tabContent.Visible = false
            end
        end
    end

    -- Function to add a new tab
    function tabSystem:AddTab(tabName)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.Position = UDim2.new((#tabButtons * 100), 0, 0, 0)
        tabButton.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
        tabButton.Text = tabName
        tabButton.Font = Enum.Font.SourceSans
        tabButton.TextSize = 18
        tabButton.Parent = tabs

        local tabContent = Instance.new("Frame")
        tabContent.Name = tabName
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contents

        -- Function to add content to the tab
        function tabContent:AddElement(element)
            element.Parent = tabContent
            return element
        end

        tabButton.MouseButton1Click:Connect(function()
            switchTab(#tabButtons)
        end)

        table.insert(tabButtons, tabButton)
        table.insert(tabContents, tabContent)

        if #tabButtons == 1 then
            switchTab(1)
        end

        return tabContent
    end

    return tabSystem
end

-- Create a new color picker
function GuiLibrary.CreateColorPicker(name, parent, size, position, defaultColor)
    local colorPicker = Instance.new("TextButton")
    colorPicker.Name = name
    colorPicker.Size = size or UDim2.new(0, 100, 0, 50)
    colorPicker.Position = position or UDim2.new(0, 0, 0, 0)
    colorPicker.BackgroundColor3 = defaultColor or Color3.new(1, 1, 1) -- Default color
    colorPicker.Text = ""
    colorPicker.Parent = parent or nil

    -- Add styling to the color picker button
    colorPicker.AutoButtonColor = false
    colorPicker.BorderSizePixel = 0
    colorPicker.ClipsDescendants = true
    colorPicker.BackgroundTransparency = 0.1
    colorPicker.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)

    local colorPickerFrame = Instance.new("Frame")
    colorPickerFrame.Name = "ColorPickerFrame"
    colorPickerFrame.Size = UDim2.new(0, 200, 0, 200)
    colorPickerFrame.Position = UDim2.new(1, 5, 0, 0) -- Place the ColorPickerFrame next to the TextButton
    colorPickerFrame.BackgroundTransparency = 0.5
    colorPickerFrame.Visible = false
    colorPickerFrame.Parent = colorPicker

    -- Add styling to the color picker frame
    colorPickerFrame.BorderSizePixel = 0
    colorPickerFrame.BackgroundTransparency = 0.2
    colorPickerFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

    -- Function to show/hide the color picker frame
    local function toggleColorPickerFrame()
        colorPickerFrame.Visible = not colorPickerFrame.Visible
    end

    -- Function to handle color selection in the color picker frame
    local function onColorSelected(newColor)
        colorPicker.BackgroundColor3 = newColor
        toggleColorPickerFrame()
    end

    -- Create the color picker frame content
    for r = 0, 255, 85 do
        for g = 0, 255, 85 do
            for b = 0, 255, 85 do
                local colorButton = Instance.new("TextButton")
                colorButton.Size = UDim2.new(0, 50, 0, 50)
                colorButton.Position = UDim2.new(r / 255, 0, g / 255, 0)
                colorButton.BackgroundColor3 = Color3.new(r / 255, g / 255, b / 255)
                colorButton.Text = ""
                colorButton.AutoButtonColor = false
                colorButton.BorderSizePixel = 0
                colorButton.Parent = colorPickerFrame

                -- Add hover effect to the color buttons
                colorButton.MouseEnter:Connect(function()
                    colorButton.BackgroundTransparency = 0.5
                end)
                colorButton.MouseLeave:Connect(function()
                    colorButton.BackgroundTransparency = 0
                end)

                colorButton.MouseButton1Click:Connect(function()
                    onColorSelected(colorButton.BackgroundColor3)
                end)
            end
        end
    end

    -- Bind mouse event for showing/hiding the color picker frame
    colorPicker.MouseButton1Click:Connect(toggleColorPickerFrame)

    return colorPicker
end

-- Create a new toggle button
function GuiLibrary.CreateToggle(name, parent, size, position, defaultState)
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = name
    toggleButton.Size = size or UDim2.new(0, 100, 0, 50)
    toggleButton.Position = position or UDim2.new(0, 0, 0, 0)
    toggleButton.Text = ""
    toggleButton.Parent = parent or nil

    local toggleState = Instance.new("BoolValue")
    toggleState.Name = "ToggleState"
    toggleState.Value = defaultState or false
    toggleState.Parent = toggleButton

    -- Add styling to the toggle button
    toggleButton.AutoButtonColor = false
    toggleButton.BorderSizePixel = 0
    toggleButton.ClipsDescendants = true
    toggleButton.BackgroundTransparency = 0.1
    toggleButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)

    -- Create the toggle indicator (the circle inside the button)
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Name = "ToggleIndicator"
    toggleIndicator.Size = UDim2.new(0, 40, 0, 40)
    toggleIndicator.Position = UDim2.new(0.5, -20, 0.5, -20)
    toggleIndicator.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
    toggleIndicator.Parent = toggleButton

    -- Function to toggle the state of the toggle button
    local function toggle()
        toggleState.Value = not toggleState.Value
        toggleIndicator.BackgroundColor3 = toggleState.Value and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.8, 0.8)
    end

    -- Bind mouse event for toggling the button state
    toggleButton.MouseButton1Click:Connect(toggle)

    return toggleButton, toggleState
end

-- Create a new section
function GuiLibrary.CreateSection(name, parent, size, position)
    local section = Instance.new("Frame")
    section.Name = name
    section.Size = size or UDim2.new(0, 200, 0, 100)
    section.Position = position or UDim2.new(0, 0, 0, 0)
    section.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
    section.BorderSizePixel = 1
    section.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
    section.Parent = parent or nil

    return section
end

return GuiLibrary
