-- Initialize services
print("[DEBUG] Initializing services...")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Wait for LocalPlayer to ensure PlayerGui is available
print("[DEBUG] Waiting for LocalPlayer...")
local player = Players.LocalPlayer
if not player then
    print("[DEBUG] LocalPlayer not found, waiting for signal...")
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    player = Players.LocalPlayer
end
print("[DEBUG] LocalPlayer found: " .. tostring(player))

-- Create ScreenGui
print("[DEBUG] Creating ScreenGui...")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KaleidoscopeGui"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false
print("[DEBUG] ScreenGui created and parented to PlayerGui")

-- Create Frame as canvas
print("[DEBUG] Creating Frame as canvas...")
local canvas = Instance.new("Frame")
canvas.Size = UDim2.new(1, 0, 1, 0)
canvas.BackgroundTransparency = 1
canvas.Parent = screenGui
print("[DEBUG] Canvas created with size: " .. tostring(canvas.Size))

-- Custom pixel drawing system
local pixels = {}
local function drawPixel(x, y, color)
    local key = x .. "-" .. y
    if not pixels[key] then
        pixels[key] = Instance.new("Frame")
        pixels[key].Size = UDim2.new(0, 1, 0, 1)
        pixels[key].BorderSizePixel = 0
        pixels[key].Parent = canvas
    end
    pixels[key].Position = UDim2.new(0, x, 0, y)
    pixels[key].BackgroundColor3 = color
end

-- Linear interpolation helper
local function lerp(a, b, t)
    return a + (b - a) * t
end

-- Main animation loop
print("[DEBUG] Starting animation loop...")
local timeCounter = 0
local frameCount = 0
RunService.RenderStepped:Connect(function(deltaTime)
    frameCount = frameCount + 1
    if frameCount % 60 == 0 then -- Log every 60 frames (~1 second at 60 FPS)
        print("[DEBUG] Frame " .. frameCount .. " - Time: " .. timeCounter)
    end
    
    timeCounter = timeCounter + deltaTime
    local width, height = canvas.AbsoluteSize.X, canvas.AbsoluteSize.Y
    if frameCount == 1 then
        print("[DEBUG] Canvas dimensions: " .. width .. "x" .. height)
    end

    -- Gradient background (blue/green to gold)
    if frameCount % 60 == 0 then
        print("[DEBUG] Drawing gradient background...")
    end
    for y = 0, height - 1, 3 do
        local t = y / height
        local r = lerp(0, 1, t)
        local g = lerp(0.2, 0.8, t)
        local b = lerp(0.4, 0.2, t)
        for x = 0, width - 1, 3 do
            drawPixel(x, y, Color3.new(r, g, b))
        end
    end

    -- Kaleidoscope effect (six symmetrical lines)
    if frameCount % 60 == 0 then
        print("[DEBUG] Drawing kaleidoscope lines...")
    end
    for i = 1, 6 do
        local angle = i * math.pi / 3
        local cos, sin = math.cos(angle), math.sin(angle)
        
        local x1 = width / 2 + cos * 100
        local y1 = height / 2 + sin * 100
        local x2 = width / 2 - cos * 100
        local y2 = height / 2 + sin * 100
        
        for t = 0, 1, 0.01 do
            local x = lerp(x1, x2, t)
            local y = lerp(y1, y2, t)
            drawPixel(math.floor(x), math.floor(y), Color3.new(1, 0.8, 1))
        end
    end

    -- Central glowing eye
    if frameCount % 60 == 0 then
        print("[DEBUG] Drawing central eye...")
    end
    local x, y = width / 2, height / 2
    local size = 50
    
    for radius = size, 10, -5 do
        local hue = (math.sin(timeCounter + radius / 50) + 1) / 2
        local color = Color3.fromHSV(hue, 0.8, 1)
        for angle = 0, math.pi * 2, 0.1 do
            local px = x + math.cos(angle) * radius
            local py = y + math.sin(angle) * radius
            drawPixel(math.floor(px), math.floor(py), color)
        end
    end

    -- Yellow star/cross above the eye
    if frameCount % 60 == 0 then
        print("[DEBUG] Drawing yellow star...")
    end
    local starX, starY = x, y - size * 2
    local starSize = size * 0.5
    
    for i = 0, 3 do
        local angle = timeCounter + i * math.pi / 2
        local x1 = starX + math.cos(angle) * starSize
        local y1 = starY + math.sin(angle) * starSize
        local x2 = starX + math.cos(angle + math.pi) * starSize
        local y2 = starY + math.sin(angle + math.pi) * starSize
        
        for t = 0, 1, 0.01 do
            local px = lerp(x1, x2, t)
            local py = lerp(y1, y2, t)
            drawPixel(math.floor(px), math.floor(py), Color3.new(1, 1, 0))
        end
    end
end)
print("[DEBUG] Animation loop connected")
