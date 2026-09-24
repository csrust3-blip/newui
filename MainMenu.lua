local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Theme = {
    Background = Color3.fromRGB(24, 24, 27),
    Sidebar = Color3.fromRGB(20, 20, 23),
    CardBg = Color3.fromRGB(30, 30, 34),
    CardStroke = Color3.fromRGB(46, 46, 51),
    TabBarBg = Color3.fromRGB(24, 24, 27),
    TextPrimary = Color3.fromRGB(235, 235, 238),
    TextMuted = Color3.fromRGB(140, 140, 148),
    Accent = Color3.fromRGB(236, 32, 160),
    AccentBlue = Color3.fromRGB(70, 110, 245),
    ToggleOff = Color3.fromRGB(58, 58, 64),
    ToggleOnBg = Color3.fromRGB(235, 235, 238),
    CheckboxOff = Color3.fromRGB(38, 38, 43),
    ToggleOn = Color3.fromRGB(56, 196, 108),
    IconInactive = Color3.fromRGB(120, 120, 128),
    IconActive = Color3.fromRGB(240, 240, 243),
    NavHover = Color3.fromRGB(32, 32, 36),
    Font = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
}

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.CardStroke
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function pad(parent, l, t, r, b)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, l or 0)
    p.PaddingTop = UDim.new(0, t or 0)
    p.PaddingRight = UDim.new(0, r or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.Parent = parent
    return p
end

local function tween(obj, props, time)
    TweenService:Create(
        obj,
        TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad),
        props
    ):Play()
end

local LegendUI = {}
local ScreenGuiRef

LegendUI.__index = LegendUI

function LegendUI:CreateWindow(config)
    config = config or {}

    local existing = PlayerGui:FindFirstChild("LegendUI")
    if existing then
        existing:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LegendUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    ScreenGuiRef = ScreenGui

    local Root = Instance.new("Frame")
    Root.Name = "Root"
    Root.Size = UDim2.fromOffset(717, 646)
    Root.Position = UDim2.new(0.5, -359, 0.5, -323)
    Root.BackgroundColor3 = Theme.Background
    Root.BorderSizePixel = 0
    Root.Parent = ScreenGui
    Root.ClipsDescendants = true

    corner(Root, 10)

    local UIScale = Instance.new("UIScale")
    UIScale.Name = "ResponsiveScale"
    UIScale.Scale = 1
    UIScale.Parent = Root

    local function updateScale()
        local Camera = workspace.CurrentCamera

        if not Camera then
            return
        end

        local viewport = Camera.ViewportSize
        local isTouch = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

        local scale

        if isTouch then
            scale = math.min(
                viewport.X / 620,
                viewport.Y / 560
            )

            scale = math.clamp(scale, 0.85, 1.25)
        else
            scale = math.min(
                viewport.X / 717,
                viewport.Y / 646
            )

            scale = math.clamp(scale, 0.85, 1)
        end

        UIScale.Scale = scale

        Root.Position = UDim2.new(
            0.5,
            -(717 * scale) / 2,
            0.5,
            -(646 * scale) / 2
        )
    end

    updateScale()

    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end

    do
        local DragButton = Instance.new("TextButton")
        DragButton.Name = "DragButton"
        DragButton.Size = UDim2.fromScale(1, 1)
        DragButton.BackgroundTransparency = 1
        DragButton.BorderSizePixel = 0
        DragButton.AutoButtonColor = false
        DragButton.Text = ""
        DragButton.ZIndex = 0
        DragButton.Parent = Root

        local dragging = false
        local dragStart
        local startPos

        DragButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Root.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging
                and (
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                ) then

                local delta = input.Position - dragStart

                Root.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 183, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Root

    local SideDivider = Instance.new("Frame")
    SideDivider.Size = UDim2.new(0, 1, 1, 0)
    SideDivider.Position = UDim2.new(1, 0, 0, 0)
    SideDivider.BackgroundColor3 = Theme.CardStroke
    SideDivider.BorderSizePixel = 0
    SideDivider.Parent = Sidebar

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 56)
    Header.BackgroundTransparency = 1
    Header.Parent = Sidebar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.fromOffset(18, 14)
    TitleLabel.Size = UDim2.new(1, -30, 0, 28)
    TitleLabel.Font = Theme.FontBold
    TitleLabel.TextSize = 18
    TitleLabel.TextColor3 = Theme.TextPrimary
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Text = config.Title or "LegendUI"
    TitleLabel.Parent = Header

    local NavList = Instance.new("Frame")
    NavList.Name = "NavList"
    NavList.Position = UDim2.fromOffset(0, 64)
    NavList.Size = UDim2.new(1, 0, 1, -128)
    NavList.BackgroundTransparency = 1
    NavList.Parent = Sidebar

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Padding = UDim.new(0, 4)
    NavLayout.Parent = NavList

    pad(NavList, 10, 0, 10, 0)

    local Footer = Instance.new("Frame")
    Footer.Size = UDim2.new(1, 0, 0, 56)
    Footer.Position = UDim2.new(0, 0, 1, -56)
    Footer.BackgroundTransparency = 1
    Footer.Parent = Sidebar

    local FooterDivider = Instance.new("Frame")
    FooterDivider.Size = UDim2.new(1, 0, 0, 1)
    FooterDivider.BackgroundColor3 = Theme.CardStroke
    FooterDivider.BorderSizePixel = 0
    FooterDivider.Parent = Footer

    local UserName = Instance.new("TextLabel")
    UserName.BackgroundTransparency = 1
    UserName.Position = UDim2.fromOffset(18, 10)
    UserName.Size = UDim2.new(1, -30, 0, 16)
    UserName.Font = Theme.FontBold
    UserName.TextSize = 12
    UserName.TextColor3 = Theme.TextPrimary
    UserName.TextXAlignment = Enum.TextXAlignment.Left
    UserName.Text = config.SubText or LocalPlayer.Name
    UserName.Parent = Footer

    local UserSub = Instance.new("TextLabel")
    UserSub.BackgroundTransparency = 1
    UserSub.Position = UDim2.fromOffset(18, 28)
    UserSub.Size = UDim2.new(1, -30, 0, 14)
    UserSub.Font = Theme.Font
    UserSub.TextSize = 11
    UserSub.TextColor3 = Theme.TextMuted
    UserSub.TextXAlignment = Enum.TextXAlignment.Left
    UserSub.Text = config.SubText2 or ""
    UserSub.Parent = Footer

    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Position = UDim2.new(0, 183, 0, 0)
    Content.Size = UDim2.new(1, -183, 1, 0)
    Content.BackgroundColor3 = Theme.Background
    Content.BorderSizePixel = 0
    Content.Parent = Root

    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1, 0, 0, 44)
    TabBar.BackgroundColor3 = Theme.TabBarBg
    TabBar.BorderSizePixel = 0
    TabBar.Parent = Content

    local TabBarList = Instance.new("UIListLayout")
    TabBarList.FillDirection = Enum.FillDirection.Horizontal
    TabBarList.Padding = UDim.new(0, 6)
    TabBarList.VerticalAlignment = Enum.VerticalAlignment.Center
    TabBarList.Parent = TabBar

    pad(TabBar, 20, 0, 20, 0)

    local Pages = Instance.new("Frame")
    Pages.Name = "Pages"
    Pages.Position = UDim2.new(0, 0, 0, 44)
    Pages.Size = UDim2.new(1, 0, 1, -44)
    Pages.BackgroundTransparency = 1
    Pages.Parent = Content

    local Window = setmetatable({
        ScreenGui = ScreenGui,
        Root = Root,
        NavList = NavList,
        TabBar = TabBar,
        Pages = Pages,
        _navButtons = {},
        Watermark = nil,
        ToggleButton = nil,
        _visible = true,
        _scale = UIScale,
    }, LegendUI)

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.fromOffset(42, 42)
    ToggleButton.Position = UDim2.new(0, 14, 0.5, -21)
    ToggleButton.BackgroundColor3 = Theme.CardBg
    ToggleButton.BorderSizePixel = 0
    ToggleButton.AutoButtonColor = false
    ToggleButton.Text = "≡"
    ToggleButton.Font = Theme.FontBold
    ToggleButton.TextSize = 20
    ToggleButton.TextColor3 = Theme.TextPrimary
    ToggleButton.ZIndex = 500
    ToggleButton.Parent = ScreenGui

    corner(ToggleButton, 10)
    stroke(ToggleButton, Theme.CardStroke, 1)

    ToggleButton.MouseEnter:Connect(function()
        tween(
            ToggleButton,
            {
                BackgroundColor3 = Theme.NavHover
            },
            0.1
        )
    end)

    ToggleButton.MouseLeave:Connect(function()
        tween(
            ToggleButton,
            {
                BackgroundColor3 = Theme.CardBg
            },
            0.1
        )
    end)

    ToggleButton.MouseButton1Click:Connect(function()
        Window._visible = not Window._visible
        Root.Visible = Window._visible
        ToggleButton.Text = Window._visible and "≡" or "≡"
    end)

    Window.ToggleButton = ToggleButton

    function Window:SetVisible(v)
        self._visible = v
        self.Root.Visible = v
    end

    function Window:Toggle()
        self._visible = not self._visible
        self.Root.Visible = self._visible
    end

    function Window:SetToggleButtonVisible(v)
        self.ToggleButton.Visible = v
    end

    return Window
end

function LegendUI:CreateWatermark(text)
    if self.Watermark then
        self.Watermark:Destroy()
        self.Watermark = nil
    end

    local Watermark = Instance.new("Frame")
    Watermark.Name = "Watermark"
    Watermark.AutomaticSize = Enum.AutomaticSize.X
    Watermark.Size = UDim2.fromOffset(0, 28)
    Watermark.Position = UDim2.new(1, -12, 0, 12)
    Watermark.AnchorPoint = Vector2.new(1, 0)
    Watermark.BackgroundColor3 = Theme.CardBg
    Watermark.BorderSizePixel = 0
    Watermark.ZIndex = 200
    Watermark.Parent = self.ScreenGui

    corner(Watermark, 6)
    stroke(Watermark, Theme.CardStroke, 1)
    pad(Watermark, 10, 0, 10, 0)

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.fromOffset(0, 28)
    Label.AutomaticSize = Enum.AutomaticSize.X
    Label.Font = Theme.FontBold
    Label.TextSize = 12
    Label.TextColor3 = Theme.TextPrimary
    Label.TextXAlignment = Enum.TextXAlignment.Center
    Label.Text = text or "LegendUI"
    Label.ZIndex = 201
    Label.Parent = Watermark

    self.Watermark = Watermark

    return Label
end

function LegendUI:AddNavTab(name)
    local Btn = Instance.new("TextButton")
    Btn.Name = name
    Btn.Size = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundTransparency = 1
    Btn.AutoButtonColor = false
    Btn.Text = ""
    Btn.Parent = self.NavList

    corner(Btn, 8)

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.fromOffset(14, 0)
    Label.Size = UDim2.new(1, -24, 1, 0)
    Label.Font = Theme.Font
    Label.TextSize = 14
    Label.TextColor3 = Theme.TextMuted
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Text = name
    Label.Parent = Btn

    local PageHolder = Instance.new("Frame")
    PageHolder.Name = name .. "_Page"
    PageHolder.Size = UDim2.fromScale(1, 1)
    PageHolder.BackgroundTransparency = 1
    PageHolder.Visible = false
    PageHolder.Parent = self.Pages

    local TabButtons = Instance.new("Frame")
    TabButtons.Name = name .. "_TabButtons"
    TabButtons.Size = UDim2.fromScale(1, 1)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Visible = false
    TabButtons.Parent = self.TabBar

    local TBLayout = Instance.new("UIListLayout")
    TBLayout.FillDirection = Enum.FillDirection.Horizontal
    TBLayout.Padding = UDim.new(0, 6)
    TBLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TBLayout.Parent = TabButtons

    local NavTab = {
        _window = self,
        Name = name,
        Button = Btn,
        Label = Label,
        Page = PageHolder,
        TabButtons = TabButtons,
        _pageTabs = {},
    }

    local function selectThisNav()
        for _, nt in ipairs(self._navButtons) do
            local active = nt == NavTab

            nt.Page.Visible = active
            nt.TabButtons.Visible = active
            nt.Label.TextColor3 = active and Theme.TextPrimary or Theme.TextMuted
            nt.Label.Font = active and Theme.FontBold or Theme.Font
            nt.Button.BackgroundColor3 = Theme.NavHover

            tween(
                nt.Button,
                {
                    BackgroundTransparency = active and 0 or 1
                },
                0.12
            )
        end
    end

    Btn.MouseButton1Click:Connect(selectThisNav)

    table.insert(self._navButtons, NavTab)

    if #self._navButtons == 1 then
        selectThisNav()
    end

    return NavTab
end

function LegendUI:AddPageTab(navTab, name)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.fromOffset(0, 44)
    Btn.AutomaticSize = Enum.AutomaticSize.X
    Btn.BackgroundTransparency = 1
    Btn.AutoButtonColor = false
    Btn.Text = ""
    Btn.Parent = navTab.TabButtons

    pad(Btn, 4, 0, 4, 0)

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0, 0, 1, 0)
    Label.AutomaticSize = Enum.AutomaticSize.X
    Label.Font = Theme.Font
    Label.TextSize = 14
    Label.TextColor3 = Theme.TextMuted
    Label.Text = "  " .. name .. "  "
    Label.Parent = Btn

    local Underline = Instance.new("Frame")
    Underline.Size = UDim2.new(1, 0, 0, 2)
    Underline.Position = UDim2.new(0, 0, 1, -2)
    Underline.BackgroundColor3 = Theme.TextPrimary
    Underline.BackgroundTransparency = 1
    Underline.BorderSizePixel = 0
    Underline.Parent = Btn

    local Page = Instance.new("Frame")
    Page.Size = UDim2.fromScale(1, 1)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = navTab.Page

    local ColLayout = Instance.new("UIListLayout")
    ColLayout.FillDirection = Enum.FillDirection.Horizontal
    ColLayout.Padding = UDim.new(0, 16)
    ColLayout.Parent = Page

    pad(Page, 20, 16, 20, 20)

    local PageTab = {
        Button = Btn,
        Label = Label,
        Underline = Underline,
        Page = Page,
        _columns = {}
    }

    local function select()
        for _, pt in ipairs(navTab._pageTabs) do
            local active = pt == PageTab

            pt.Page.Visible = active
            pt.Label.TextColor3 = active and Theme.TextPrimary or Theme.TextMuted
            pt.Label.Font = active and Theme.FontBold or Theme.Font

            tween(
                pt.Underline,
                {
                    BackgroundTransparency = active and 0 or 1
                },
                0.12
            )
        end
    end

    Btn.MouseButton1Click:Connect(select)

    table.insert(navTab._pageTabs, PageTab)

    if #navTab._pageTabs == 1 then
        select()
    end

    function PageTab:AddColumn(widthScale)
        local Col = Instance.new("Frame")
        Col.Size = UDim2.new(widthScale or 0.5, -8, 1, 0)
        Col.BackgroundTransparency = 1
        Col.Parent = Page

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 14)
        Layout.Parent = Col

        local Column = {
            Frame = Col
        }

        function Column:AddBox(title)
            return LegendUI._buildBox(Col, title)
        end

        return Column
    end

    return PageTab
end

function LegendUI._buildBox(parent, title)
    local Card = Instance.new("Frame")
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.Size = UDim2.new(1, 0, 0, 0)
    Card.BackgroundColor3 = Theme.CardBg
    Card.BorderSizePixel = 0
    Card.Parent = parent

    corner(Card, 10)
    stroke(Card, Theme.CardStroke, 1)

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 2)
    Layout.Parent = Card

    pad(Card, 14, 10, 14, 12)

    if title then
        local HeaderRow = Instance.new("Frame")
        HeaderRow.Size = UDim2.new(1, 0, 0, 26)
        HeaderRow.BackgroundTransparency = 1
        HeaderRow.Parent = Card

        local HeaderLabel = Instance.new("TextLabel")
        HeaderLabel.BackgroundTransparency = 1
        HeaderLabel.Size = UDim2.new(1, 0, 1, 0)
        HeaderLabel.Font = Theme.FontBold
        HeaderLabel.TextSize = 14
        HeaderLabel.TextColor3 = Theme.TextPrimary
        HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
        HeaderLabel.Text = title
        HeaderLabel.Parent = HeaderRow
    end

    local Box = {
        Frame = Card
    }

    local function newRow(height)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, height or 28)
        Row.BackgroundTransparency = 1
        Row.Parent = Card
        return Row
    end

    function Box:AddLabel(text, color)
        local Row = newRow(28)

        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, 0, 0, 28)
        Label.AutomaticSize = Enum.AutomaticSize.Y
        Label.Font = Theme.Font
        Label.TextSize = 12
        Label.TextColor3 = color or Theme.TextMuted
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextYAlignment = Enum.TextYAlignment.Center
        Label.TextWrapped = true
        Label.Text = tostring(text or "")
        Label.Parent = Row

        local api = {}

        function api:Set(v)
            Label.Text = tostring(v or "")
        end

        function api:Get()
            return Label.Text
        end

        return api
    end
    
    function Box:AddCheckbox(text, default, callback)
        local Row = newRow(24)
        local check = default or false

        local Square = Instance.new("Frame")
        Square.Size = UDim2.fromOffset(14, 14)
        Square.Position = UDim2.fromOffset(0, 5)
        Square.BackgroundColor3 = check and Theme.ToggleOn or Theme.CheckboxOff
        Square.Parent = Row

        corner(Square, 3)
        stroke(Square, Theme.CardStroke, 1)

        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.fromOffset(22, 0)
        Label.Size = UDim2.new(1, -22, 1, 0)
        Label.Font = Theme.Font
        Label.TextSize = 13
        Label.TextColor3 = Theme.TextPrimary
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = text
        Label.Parent = Row

        local Click = Instance.new("TextButton")
        Click.BackgroundTransparency = 1
        Click.Size = UDim2.fromScale(1, 1)
        Click.Text = ""
        Click.Parent = Row

        local api = {}

        function api:Set(v)
            check = v

            tween(
                Square,
                {
                    BackgroundColor3 = check and Theme.ToggleOn or Theme.CheckboxOff
                },
                0.1
            )

            if callback then
                callback(check)
            end
        end

        Click.MouseButton1Click:Connect(function()
            api:Set(not check)
        end)

        return api
    end

    function Box:AddToggle(text, default, accentColor, callback)
        local Row = newRow(26)
        local state = default or false
        local color = accentColor or Theme.Accent

        local Square = Instance.new("Frame")
        Square.Size = UDim2.fromOffset(14, 14)
        Square.Position = UDim2.fromOffset(0, 6)
        Square.BackgroundColor3 = state and Theme.ToggleOn or Theme.CheckboxOff
        Square.BorderSizePixel = 0
        Square.Parent = Row

        corner(Square, 3)
        stroke(Square, Theme.CardStroke, 1)

        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.fromOffset(22, 0)
        Label.Size = UDim2.new(1, -50, 1, 0)
        Label.Font = Theme.Font
        Label.TextSize = 13
        Label.TextColor3 = Theme.TextPrimary
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = text
        Label.Parent = Row

        local Click = Instance.new("TextButton")
        Click.BackgroundTransparency = 1
        Click.Size = UDim2.new(1, -28, 1, 0)
        Click.AutoButtonColor = false
        Click.Text = ""
        Click.ZIndex = 5
        Click.Parent = Row

        local Swatch = Instance.new("TextButton")
        Swatch.Size = UDim2.fromOffset(20, 14)
        Swatch.Position = UDim2.new(1, -20, 0, 6)
        Swatch.BackgroundColor3 = color
        Swatch.BorderSizePixel = 0
        Swatch.AutoButtonColor = false
        Swatch.Text = ""
        Swatch.ZIndex = 6
        Swatch.Parent = Row

        corner(Swatch, 4)
        stroke(Swatch, Theme.CardStroke, 1)

        local PickerCatcher = Instance.new("TextButton")
        PickerCatcher.Size = UDim2.fromScale(1, 1)
        PickerCatcher.BackgroundTransparency = 1
        PickerCatcher.BorderSizePixel = 0
        PickerCatcher.AutoButtonColor = false
        PickerCatcher.Text = ""
        PickerCatcher.Visible = false
        PickerCatcher.ZIndex = 90
        PickerCatcher.Parent = ScreenGuiRef

        local ColorPicker = Instance.new("Frame")
        ColorPicker.Size = UDim2.fromOffset(240, 310)
        ColorPicker.BackgroundColor3 = Color3.fromRGB(27, 27, 31)
        ColorPicker.BorderSizePixel = 0
        ColorPicker.Visible = false
        ColorPicker.ZIndex = 100
        ColorPicker.Parent = ScreenGuiRef

        corner(ColorPicker, 8)
        stroke(ColorPicker, Theme.CardStroke, 1)

        local PickerTitle = Instance.new("TextLabel")
        PickerTitle.BackgroundTransparency = 1
        PickerTitle.Position = UDim2.fromOffset(14, 10)
        PickerTitle.Size = UDim2.new(1, -28, 0, 18)
        PickerTitle.Font = Theme.FontBold
        PickerTitle.TextSize = 13
        PickerTitle.TextColor3 = Theme.TextPrimary
        PickerTitle.TextXAlignment = Enum.TextXAlignment.Left
        PickerTitle.Text = text
        PickerTitle.ZIndex = 101
        PickerTitle.Parent = ColorPicker

        local ColorArea = Instance.new("TextButton")
        ColorArea.Size = UDim2.fromOffset(212, 190)
        ColorArea.Position = UDim2.fromOffset(14, 36)
        ColorArea.BackgroundColor3 = Color3.fromHSV(0, 1, 1)
        ColorArea.BorderSizePixel = 0
        ColorArea.AutoButtonColor = false
        ColorArea.Text = ""
        ColorArea.ZIndex = 101
        ColorArea.Parent = ColorPicker

        corner(ColorArea, 6)

        local WhiteGradient = Instance.new("Frame")
        WhiteGradient.Size = UDim2.fromScale(1, 1)
        WhiteGradient.BackgroundColor3 = Color3.new(1, 1, 1)
        WhiteGradient.BorderSizePixel = 0
        WhiteGradient.ZIndex = 102
        WhiteGradient.Parent = ColorArea

        corner(WhiteGradient, 6)

        local WhiteUIGradient = Instance.new("UIGradient")
        WhiteUIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        WhiteUIGradient.Parent = WhiteGradient

        local BlackGradient = Instance.new("Frame")
        BlackGradient.Size = UDim2.fromScale(1, 1)
        BlackGradient.BackgroundColor3 = Color3.new(0, 0, 0)
        BlackGradient.BorderSizePixel = 0
        BlackGradient.ZIndex = 103
        BlackGradient.Parent = ColorArea

        corner(BlackGradient, 6)

        local BlackUIGradient = Instance.new("UIGradient")
        BlackUIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        })
        BlackUIGradient.Rotation = 90
        BlackUIGradient.Parent = BlackGradient

        local ColorCursor = Instance.new("Frame")
        ColorCursor.Size = UDim2.fromOffset(12, 12)
        ColorCursor.AnchorPoint = Vector2.new(0.5, 0.5)
        ColorCursor.BackgroundColor3 = Color3.new(1, 1, 1)
        ColorCursor.BorderSizePixel = 0
        ColorCursor.ZIndex = 104
        ColorCursor.Parent = ColorArea

        corner(ColorCursor, 6)
        stroke(ColorCursor, Color3.fromRGB(25, 25, 25), 2)

        local HueSlider = Instance.new("TextButton")
        HueSlider.Size = UDim2.fromOffset(212, 16)
        HueSlider.Position = UDim2.fromOffset(14, 234)
        HueSlider.BackgroundColor3 = Color3.new(1, 1, 1)
        HueSlider.BorderSizePixel = 0
        HueSlider.AutoButtonColor = false
        HueSlider.Text = ""
        HueSlider.ZIndex = 101
        HueSlider.Parent = ColorPicker

        corner(HueSlider, 5)

        local HueGradient = Instance.new("UIGradient")
        HueGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.166, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.666, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        })
        HueGradient.Parent = HueSlider

        local HueCursor = Instance.new("Frame")
        HueCursor.Size = UDim2.fromOffset(7, 20)
        HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
        HueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
        HueCursor.BorderSizePixel = 0
        HueCursor.ZIndex = 103
        HueCursor.Parent = HueSlider

        corner(HueCursor, 3)
        stroke(HueCursor, Color3.fromRGB(25, 25, 25), 1)

        local Cancel = Instance.new("TextButton")
        Cancel.Size = UDim2.fromOffset(103, 30)
        Cancel.Position = UDim2.new(0, 14, 1, -44)
        Cancel.BackgroundColor3 = Theme.CheckboxOff
        Cancel.BorderSizePixel = 0
        Cancel.AutoButtonColor = false
        Cancel.Text = "Cancel"
        Cancel.Font = Theme.FontBold
        Cancel.TextSize = 12
        Cancel.TextColor3 = Theme.TextPrimary
        Cancel.ZIndex = 101
        Cancel.Parent = ColorPicker

        corner(Cancel, 5)

        local Apply = Instance.new("TextButton")
        Apply.Size = UDim2.fromOffset(103, 30)
        Apply.Position = UDim2.new(0, 123, 1, -44)
        Apply.BackgroundColor3 = Theme.ToggleOn
        Apply.BorderSizePixel = 0
        Apply.AutoButtonColor = false
        Apply.Text = "Apply"
        Apply.Font = Theme.FontBold
        Apply.TextSize = 12
        Apply.TextColor3 = Theme.TextPrimary
        Apply.ZIndex = 101
        Apply.Parent = ColorPicker

        corner(Apply, 5)

        Apply.MouseEnter:Connect(function()
            Apply.BackgroundColor3 = Color3.fromRGB(66, 210, 118)
        end)

        Apply.MouseLeave:Connect(function()
            Apply.BackgroundColor3 = Theme.ToggleOn
        end)

        Cancel.MouseEnter:Connect(function()
            Cancel.BackgroundColor3 = Theme.ToggleOff
        end)

        Cancel.MouseLeave:Connect(function()
            Cancel.BackgroundColor3 = Theme.CheckboxOff
        end)

        local hue, saturation, value = Color3.toHSV(color)
        local workingColor = color
        local originalColor = color

        local function updateColor()
            workingColor = Color3.fromHSV(
                hue,
                saturation,
                value
            )

            ColorArea.BackgroundColor3 = Color3.fromHSV(
                hue,
                1,
                1
            )

            ColorCursor.Position = UDim2.new(
                saturation,
                0,
                1 - value,
                0
            )

            HueCursor.Position = UDim2.new(
                hue,
                0,
                0.5,
                0
            )
        end

        local function updateColorArea(position)
            local x = math.clamp(
                (position.X - ColorArea.AbsolutePosition.X)
                / ColorArea.AbsoluteSize.X,
                0,
                1
            )

            local y = math.clamp(
                (position.Y - ColorArea.AbsolutePosition.Y)
                / ColorArea.AbsoluteSize.Y,
                0,
                1
            )

            saturation = x
            value = 1 - y

            updateColor()
        end

        local function updateHue(position)
            local x = math.clamp(
                (position.X - HueSlider.AbsolutePosition.X)
                / HueSlider.AbsoluteSize.X,
                0,
                1
            )

            hue = x

            updateColor()
        end

        local draggingColor = false
        local draggingHue = false

        ColorArea.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                draggingColor = true
                updateColorArea(input.Position)
            end
        end)

        HueSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                draggingHue = true
                updateHue(input.Position)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then

                if draggingColor then
                    updateColorArea(input.Position)
                elseif draggingHue then
                    updateHue(input.Position)
                end
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                draggingColor = false
                draggingHue = false
            end
        end)

        local function closePicker()
            draggingColor = false
            draggingHue = false
            ColorPicker.Visible = false
            PickerCatcher.Visible = false
        end

        local function openPicker()
            originalColor = color
            hue, saturation, value = Color3.toHSV(color)

            ColorPicker.Position = UDim2.fromOffset(
                Swatch.AbsolutePosition.X - 220,
                Swatch.AbsolutePosition.Y + Swatch.AbsoluteSize.Y + 6
            )

            updateColor()

            PickerCatcher.Visible = true
            ColorPicker.Visible = true
        end

        Click.MouseButton1Click:Connect(function()
            state = not state

            tween(
                Square,
                {
                    BackgroundColor3 = state and Theme.ToggleOn or Theme.CheckboxOff
                },
                0.1
            )

            if callback then
                callback(state, color)
            end
        end)

        Swatch.MouseButton1Click:Connect(function()
            if ColorPicker.Visible then
                closePicker()
            else
                openPicker()
            end
        end)

        PickerCatcher.MouseButton1Click:Connect(closePicker)

        Apply.MouseButton1Click:Connect(function()
            color = workingColor
            Swatch.BackgroundColor3 = color

            closePicker()

            if callback then
                callback(state, color)
            end
        end)

        Cancel.MouseButton1Click:Connect(function()
            color = originalColor
            Swatch.BackgroundColor3 = color
            closePicker()
        end)

        local api = {
            Swatch = Swatch
        }

        function api:Set(v)
            state = v

            tween(
                Square,
                {
                    BackgroundColor3 = state and Theme.ToggleOn or Theme.CheckboxOff
                },
                0.1
            )

            if callback then
                callback(state, color)
            end
        end

        function api:SetColor(c)
            color = c
            workingColor = c
            Swatch.BackgroundColor3 = c

            hue, saturation, value = Color3.toHSV(c)
            updateColor()
        end

        function api:GetColor()
            return color
        end

        function api:Get()
            return state
        end

        return api
    end

    function Box:AddButton(text, callback)
        local Row = newRow(32)

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 28)
        Button.BackgroundColor3 = Theme.CheckboxOff
        Button.BorderSizePixel = 0
        Button.AutoButtonColor = false
        Button.Text = text
        Button.Font = Theme.FontBold
        Button.TextSize = 12
        Button.TextColor3 = Theme.TextPrimary
        Button.Parent = Row

        corner(Button, 6)
        stroke(Button, Theme.CardStroke, 1)

        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Theme.ToggleOff
        end)

        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Theme.CheckboxOff
        end)

        Button.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)

        return Button
    end

    function Box:AddSlider(text, min, max, default, callback)
        local Row = newRow(44)
        Row:SetAttribute("NoWindowDrag", true)

        min = min or 0
        max = max or 100

        local value = math.clamp(default or min, min, max)

        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, -40, 0, 18)
        Label.Font = Theme.Font
        Label.TextSize = 13
        Label.TextColor3 = Theme.TextPrimary
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = text
        Label.Parent = Row

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Position = UDim2.new(1, -40, 0, 0)
        ValueLabel.Size = UDim2.fromOffset(40, 18)
        ValueLabel.Font = Theme.Font
        ValueLabel.TextSize = 13
        ValueLabel.TextColor3 = Theme.TextMuted
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Text = tostring(value)
        ValueLabel.Parent = Row

        local Track = Instance.new("Frame")
        Track.Position = UDim2.fromOffset(0, 26)
        Track.Size = UDim2.new(1, 0, 0, 4)
        Track.BackgroundColor3 = Theme.ToggleOff
        Track.BorderSizePixel = 0
        Track.Parent = Row

        corner(Track, 2)

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.fromScale(
            max == min and 0 or (value - min) / (max - min),
            1
        )
        Fill.BackgroundColor3 = Theme.TextPrimary
        Fill.BorderSizePixel = 0
        Fill.Parent = Track

        corner(Fill, 2)

        local Knob = Instance.new("TextButton")
        Knob.Size = UDim2.fromOffset(12, 12)
        Knob.AnchorPoint = Vector2.new(0.5, 0.5)
        Knob.Position = UDim2.new(
            max == min and 0 or (value - min) / (max - min),
            0,
            0.5,
            0
        )
        Knob.BackgroundColor3 = Theme.TextPrimary
        Knob.BorderSizePixel = 0
        Knob.Text = ""
        Knob.AutoButtonColor = false
        Knob.Parent = Track

        corner(Knob, 6)

        local dragging = false

        local function setValue(v, callCallback)
            value = math.clamp(
                math.floor(v + 0.5),
                min,
                max
            )

            local rel

            if max == min then
                rel = 0
            else
                rel = (value - min) / (max - min)
            end

            Knob.Position = UDim2.new(
                rel,
                0,
                0.5,
                0
            )

            Fill.Size = UDim2.fromScale(
                rel,
                1
            )

            ValueLabel.Text = tostring(value)

            if callCallback and callback then
                callback(value)
            end
        end

        local function updateFromMouse()
            local rel = math.clamp(
                (UserInputService:GetMouseLocation().X - Track.AbsolutePosition.X)
                / Track.AbsoluteSize.X,
                0,
                1
            )

            setValue(
                min + (max - min) * rel,
                true
            )
        end

        Knob.MouseButton1Down:Connect(function()
            dragging = true
        end)

        Track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateFromMouse()
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging
                and (
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                ) then
                updateFromMouse()
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        return {
            Set = function(_, v)
                setValue(v, false)
            end,

            Get = function()
                return value
            end
        }
    end

    function Box:AddDropdown(text, options, default, callback)
        options = options or {}

        local Row = newRow(28)
        local selected = default or options[1]
        local open = false

        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, -118, 1, 0)
        Label.Font = Theme.Font
        Label.TextSize = 13
        Label.TextColor3 = Theme.TextPrimary
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = text
        Label.Parent = Row

        local DropBtn = Instance.new("TextButton")
        DropBtn.Size = UDim2.fromOffset(110, 22)
        DropBtn.Position = UDim2.new(1, -110, 0, 3)
        DropBtn.BackgroundColor3 = Theme.CheckboxOff
        DropBtn.AutoButtonColor = false
        DropBtn.Text = ""
        DropBtn.ZIndex = 2
        DropBtn.Parent = Row

        corner(DropBtn, 5)
        stroke(DropBtn, Theme.CardStroke, 1)

        local SelectedLabel = Instance.new("TextLabel")
        SelectedLabel.BackgroundTransparency = 1
        SelectedLabel.Position = UDim2.fromOffset(8, 0)
        SelectedLabel.Size = UDim2.new(1, -22, 1, 0)
        SelectedLabel.Font = Theme.Font
        SelectedLabel.TextSize = 12
        SelectedLabel.TextColor3 = Theme.TextPrimary
        SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
        SelectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
        SelectedLabel.Text = tostring(selected)
        SelectedLabel.ZIndex = 2
        SelectedLabel.Parent = DropBtn

        local Arrow = Instance.new("TextLabel")
        Arrow.BackgroundTransparency = 1
        Arrow.Position = UDim2.new(1, -18, 0, 0)
        Arrow.Size = UDim2.fromOffset(14, 22)
        Arrow.Font = Theme.Font
        Arrow.TextSize = 12
        Arrow.TextColor3 = Theme.TextMuted
        Arrow.Text = "▾"
        Arrow.ZIndex = 2
        Arrow.Parent = DropBtn

        local ListFrame = Instance.new("ScrollingFrame")
        ListFrame.Visible = false
        ListFrame.BackgroundColor3 = Theme.CardBg
        ListFrame.BorderSizePixel = 0
        ListFrame.ZIndex = 50
        ListFrame.ScrollBarThickness = 4
        ListFrame.ScrollBarImageColor3 = Theme.CardStroke
        ListFrame.CanvasSize = UDim2.fromOffset(0, 0)
        ListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        ListFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        ListFrame.Parent = ScreenGuiRef

        corner(ListFrame, 6)
        stroke(ListFrame, Theme.CardStroke, 1)

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Parent = ListFrame

        local Catcher = Instance.new("TextButton")
        Catcher.BackgroundTransparency = 1
        Catcher.Size = UDim2.fromScale(1, 1)
        Catcher.Text = ""
        Catcher.ZIndex = 49
        Catcher.Visible = false
        Catcher.Parent = ScreenGuiRef

        local api = {}

        local function closeList()
            open = false
            ListFrame.Visible = false
            Catcher.Visible = false
            Arrow.Text = "▾"
        end

        local function openList()
            open = true

            ListFrame.Position = UDim2.fromOffset(
                DropBtn.AbsolutePosition.X,
                DropBtn.AbsolutePosition.Y + DropBtn.AbsoluteSize.Y + 4
            )

            ListFrame.Size = UDim2.fromOffset(
                DropBtn.AbsoluteSize.X,
                math.min((#options * 24) + 8, 240)
            )

            ListFrame.Visible = true
            Catcher.Visible = true
            Arrow.Text = "▴"
        end

        for _, option in ipairs(options) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Size = UDim2.new(1, 0, 0, 24)
            OptBtn.BackgroundTransparency = 1
            OptBtn.BackgroundColor3 = Theme.CardBg
            OptBtn.AutoButtonColor = false
            OptBtn.Text = ""
            OptBtn.BorderSizePixel = 0
            OptBtn.ZIndex = 51
            OptBtn.Parent = ListFrame

            local OptLabel = Instance.new("TextLabel")
            OptLabel.BackgroundTransparency = 1
            OptLabel.Position = UDim2.fromOffset(8, 0)
            OptLabel.Size = UDim2.new(1, -16, 1, 0)
            OptLabel.Font = Theme.Font
            OptLabel.TextSize = 12
            OptLabel.TextColor3 =
                option == selected
                and Theme.ToggleOn
                or Theme.TextPrimary
            OptLabel.TextXAlignment = Enum.TextXAlignment.Left
            OptLabel.Text = tostring(option)
            OptLabel.ZIndex = 51
            OptLabel.Parent = OptBtn

            OptBtn.MouseEnter:Connect(function()
                OptBtn.BackgroundTransparency = 0
                OptBtn.BackgroundColor3 = Theme.NavHover
            end)

            OptBtn.MouseLeave:Connect(function()
                OptBtn.BackgroundTransparency = 1
            end)

            OptBtn.MouseButton1Click:Connect(function()
                selected = option
                SelectedLabel.Text = tostring(option)

                for _, child in ipairs(ListFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        local lbl = child:FindFirstChildOfClass("TextLabel")

                        if lbl then
                            lbl.TextColor3 =
                                lbl.Text == tostring(option)
                                and Theme.ToggleOn
                                or Theme.TextPrimary
                        end
                    end
                end

                closeList()

                if callback then
                    callback(option)
                end
            end)
        end

        DropBtn.MouseButton1Click:Connect(function()
            if open then
                closeList()
            else
                openList()
            end
        end)

        Catcher.MouseButton1Click:Connect(closeList)

        function api:Set(v)
            selected = v
            SelectedLabel.Text = tostring(v)

            for _, child in ipairs(ListFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    local lbl = child:FindFirstChildOfClass("TextLabel")

                    if lbl then
                        lbl.TextColor3 =
                            lbl.Text == tostring(v)
                            and Theme.ToggleOn
                            or Theme.TextPrimary
                    end
                end
            end

            if callback then
                callback(v)
            end
        end

        function api:Get()
            return selected
        end

        return api
    end

    return Box
end

return LegendUI
