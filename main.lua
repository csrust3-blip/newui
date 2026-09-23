```lua
local LegendUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/csrust3-blip/newui/refs/heads/main/main.lua"))()

local Window = LegendUI:CreateWindow({
    Title = "LegendUI",
    SubText = game.Players.LocalPlayer.Name,
    SubText2 = "session",
})

local VisualsNav = Window:AddNavTab("Visuals")
local MiscNav = Window:AddNavTab("Misc")

local EnemiesTab = Window:AddPageTab(VisualsNav, "Enemies")
local LocalTab = Window:AddPageTab(VisualsNav, "Local")

local Left = EnemiesTab:AddColumn()
local Right = EnemiesTab:AddColumn()

local EspBox = Left:AddBox("Enable ESP")

EspBox:AddToggle(
    "Box",
    true,
    Color3.fromRGB(236, 32, 160),
    function(v, color)
        print("Box toggled:", v, color)
    end
)

EspBox:AddToggle("Name", false)
EspBox:AddCheckbox("Health bar", false)
EspBox:AddCheckbox("Skeleton", false)

local ChamsBox = Right:AddBox("Chams")

ChamsBox:AddCheckbox("Visible chams", false)
ChamsBox:AddCheckbox("Invisible chams", false)
ChamsBox:AddSlider("Opacity", 0, 100, 50)

local MiscTab = Window:AddPageTab(MiscNav, "General")
local MiscCol = MiscTab:AddColumn(1)

local MiscBox = MiscCol:AddBox("Settings")

MiscBox:AddCheckbox("Example option", false)

MiscBox:AddDropdown(
    "Mode",
    {"Legit", "Rage", "Safe"},
    "Legit",
    function(v)
        print("Mode selected:", v)
    end
)

MiscBox:AddButton("Print Something", function()
    print("Hello from LegendUI!")
end)
```
