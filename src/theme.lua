local module = {}

module.ImGuiCol = {
    Text = 0,
    TextDisabled = 1,
    WindowBg = 2,
    ChildBg = 3,
    PopupBg = 4,
    Border = 5,
    BorderShadow = 6,
    FrameBg = 7,
    FrameBgHovered = 8,
    FrameBgActive = 9,
    TitleBg = 10,
    TitleBgActive = 11,
    TitleBgCollapsed = 12,
    MenuBarBg = 13,
    ScrollbarBg = 14,
    ScrollbarGrab = 15,
    ScrollbarGrabHovered = 16,
    ScrollbarGrabActive = 17,
    CheckMark = 18,
    SliderGrab = 19,
    SliderGrabActive = 20,
    Button = 21,
    ButtonHovered = 22,
    ButtonActive = 23,
    Header = 24,
    HeaderHovered = 25,
    HeaderActive = 26,
    Separator = 27,
    SeparatorHovered = 28,
    SeparatorActive = 29,
    ResizeGrip = 30,
    ResizeGripHovered = 31,
    ResizeGripActive = 32,
    Tab = 33,
    TabHovered = 34,
    TabActive = 35,
    TabUnfocused = 36,
    TabUnfocusedActive = 37,
    PlotLines = 38,
    PlotLinesHovered = 39,
    PlotHistogram = 40,
    PlotHistogramHovered = 41,
    TableHeaderBg = 42,
    TableBorderStrong = 43,
    TableBorderLight = 44,
    TableRowBg = 45,
    TableRowBgAlt = 46,
    TextSelectedBg = 47,
    DragDropTarget = 48,
    NavHighlight = 49,
    NavWindowingHighlight = 50,
    NavWindowingDimBg = 51,
    ModalWindowDimBg = 52,
    COUNT = 53,
}

module.ImPlotScale = {
    Linear = 0,
    Time = 1,
    Log10 = 2,
    SymLog = 3
}

module.ImPlotMarker = {
    None_ = -1,
    Circle = 0,
    Square = 1,
    Diamond = 2,
    Up = 3,
    Down = 4,
    Left = 5,
    Right = 6,
    Cross = 7,
    Plus = 8,
    Asterisk = 9
}

module.ImGuiStyleVar = {
    Alpha = 0,
    DisabledAlpha = 1,
    WindowPadding = 2,
    WindowRounding = 3,
    WindowBorderSize = 4,
    WindowMinSize = 5,
    WindowTitleAlign = 6,
    ChildRounding = 7,
    ChildBorderSize = 8,
    PopupRounding = 9,
    PopupBorderSize = 10,
    FramePadding = 11,
    FrameRounding = 12,
    FrameBorderSize = 13,
    ItemSpacing = 14,
    ItemInnerSpacing = 15,
    IndentSpacing = 16,
    CellPadding = 17,
    ScrollbarSize = 18,
    ScrollbarRounding = 19,
    GrabMinSize = 20,
    GrabRounding = 21,
    TabRounding = 22,
    TabBorderSize = 23,
    TabBarBorderSize = 24,
    TableAngledHeadersAngle = 25,
    TableAngledHeadersTextAlign = 26,
    ButtonTextAlign = 27,
    SelectableTextAlign = 28,
    SeparatorTextBorderSize = 29,
    SeparatorTextAlign = 30,
    SeparatorTextPadding = 31
}

module.ImPlotMarker = {
    None_ = -1,
    Left = 0,
    Right = 1,
    Up = 2,
    Down = 3
}

module.ImGuiHoveredFlags = {
    None_ = 0,  -- "None" is a reserved keyword in Python
    ChildWindows = 1 << 0,
    RootWindow = 1 << 1,
    AnyWindow = 1 << 2,
    NoPopupHierarchy = 1 << 3,
    -- DockHierarchy = 1 << 4,
    AllowWhenBlockedByPopup = 1 << 5,
    -- AllowWhenBlockedByModal = 1 << 6,
    AllowWhenBlockedByActiveItem = 1 << 7,
    AllowWhenOverlappedByItem = 1 << 8,
    AllowWhenOverlappedByWindow = 1 << 9,
    AllowWhenDisabled = 1 << 10,
    NoNavOverride = 1 << 11,
    AllowWhenOverlapped = (1 << 8) | (1 << 9),  -- AllowWhenOverlappedByItem | AllowWhenOverlappedByWindow
    RectOnly = (1 << 5) | (1 << 7) | (1 << 8),  -- AllowWhenBlockedByPopup | AllowWhenBlockedByActiveItem | AllowWhenOverlapped
    RootAndChildWindows = (1 << 1) | (1 << 0),  -- RootWindow | ChildWindows
    ForTooltip = 1 << 12,
    Stationary = 1 << 13,
    DelayNone = 1 << 14,
    DelayShort = 1 << 15,
    DelayNormal = 1 << 16,
    NoSharedDelay = 1 << 17
}

function module.HEXA(color, opacity)
    if type(color) ~= "string" then
        error("Invalid color type. Expected string.")
    end
    if type(opacity) ~= "number" or opacity < 0 or opacity > 1 then
        error("Invalid opacity. Expected a number between 0 and 1.")
    end

    return {
        color, opacity
    }
end

function module.FontDef(name, size)
    if type(name) ~= "string" then
        error("Invalid name type. Expected string.")
    end
    if type(size) ~= "number" then
        error("Invalid size. Expected a number.")
    end

    return {
        name = name,
        size = size
    }
end

function module.ImVec2(x, y)
    if type(x) ~= "number" then
        error("Invalid x. Expected a number.")
    end
    if type(y) ~= "number" then
        error("Invalid y. Expected a number.")
    end

    return {
        x = x,
        y = y
    }
end

module.Align = {
    Left = "left",
    Right = "right"
}

-- todo: move to utils.lua
function module.table_contains(tbl, val)
    for _, v in pairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

function module.is_valid_colors(input)
    if type(input) ~= "table" then
        return false
    end

    local is_valid = true
    for key, _ in pairs(input.colors) do
        if not module.table_contains(module.ImGuiCol, key) then
            is_valid = false
            break
        end
    end

    return is_valid
end

function module.is_valid_style_vars(input)
    if type(input) ~= "table" then
        return false
    end

    local is_valid = true
    for key, _ in pairs(input.colors) do
        if not module.table_contains(module.ImGuiStyleVar, key) then
            is_valid = false
            break
        end
    end

    return is_valid
end

-- this seems a bit overkill
function module.is_valid_font_def(input)
    if type(input) ~= "table" then
        return false
    end
    if type(input.name) ~= "string" then
        return false
    end
    if type(input.size) ~= "number" then
        return false
    end

    return true
end

function module.is_valid_color_value(input)
    if type(input) == "string" then
        return true
    end
    if type(input) == "table" then
        if #input == 2 and type(input[1]) == "string" and type(input[2]) == "number" then
            return true
        end
    end

    return false
end

function module.StyleRules(input)
    if type(input) ~= "table" then
        error("Invalid type. Expected table.")
    end

    local style_rules = {}

    if type(input.align) == "string" and module.table_contains(module.Align, input.align) then
        style_rules.align = input.align
    end

    if module.is_valid_font_def(input.font) then
        style_rules.font = input.font
    end

    if module.is_valid_colors(input.colors) then
        style_rules.colors = input.colors
    end

    if module.is_valid_style_vars(input.vars) then
        style_rules.vars = input.vars
    end

    return style_rules
end

module.Direction = {
    Inherit = "inherit",
    Ltr = "ltr",
    Rtl = "rtl"
}

module.FlexDirection = {
    Column = "column",
    ColumnReverse = "column-reverse",
    Row = "row",
    RowReverse = "row-reverse"
}

module.JustifyContent = {
    FlexStart = "flex-start",
    Center = "center",
    FlexEnd = "flex-end",
    SpaceBetween = "space-between",
    SpaceAround = "space-around",
    SpaceEvenly = "space-evenly"
}

module.AlignContent = {
    Auto = "auto",
    FlexStart = "flex-start",
    Center = "center",
    FlexEnd = "flex-end",
    Stretch = "stretch",
    SpaceBetween = "space-between",
    SpaceAround = "space-around",
    SpaceEvenly = "space-evenly"
}

module.AlignItems = {
    Auto = "auto",
    FlexStart = "flex-start",
    Center = "center",
    FlexEnd = "flex-end",
    Stretch = "stretch",
    Baseline = "baseline"
}

module.AlignSelf = {
    Auto = "auto",
    FlexStart = "flex-start",
    Center = "center",
    FlexEnd = "flex-end",
    Stretch = "stretch",
    Baseline = "baseline"
}

module.PositionType = {
    Static = "static",
    Relative = "relative",
    Absolute = "absolute",
}

module.FlexWrap = {
    NoWrap = "no-wrap",
    Wrap = "wrap",
    WrapReverse = "wrap-reverse"
}

module.Overflow = {
    Visible = "visible",
    Hidden = "hidden",
    Scroll = "scroll"
}

module.Display = {
    Flex = "flex",
    DisplayNone = "none"
}

module.Edge = {
    Left = "left",
    Top = "top",
    Right = "right",
    Bottom = "bottom",
    Start = "start",
    End = "end",
    Horizontal = "horizontal",
    Vertical = "vertical",
    All = "all"
}

module.Gutter = {
    Column = "column",
    Row = "row",
    All = "all"
}

module.RoundCorners = {
    All = "all",
    TopLeft = "topLeft",
    TopRight = "topRight",
    BottomLeft = "bottomLeft",
    BottomRight = "bottomRight"
}

function module.BorderStyle(color, thickness)
    if not module.is_valid_color_value(color) then
        error("Invalid color. Expected string or HEXA.")
    end

    local border_style = {
        color = color
    }
    
    if type(thickness) ~= "nil" then
        if type(thickness) ~= "number" then
            error("Invalid thickness. Expected number.")
        end

        border_style.thickness = thickness
    end

    return border_style
end

function module.YogaStyle(input)
    if type(input) ~= "table" then
        error("Invalid type. Expected table.")
    end

    local yoga_style = {}

    

    return yoga_style
end

function module.BaseDrawStyle(input)
    if type(input) ~= "table" then
        error("Invalid type. Expected table.")
    end

    local base_draw_style = {}

    

    return base_draw_style
end

function module.NodeStyleDef(input)
    if type(input) ~= "table" then
        error("Invalid type. Expected table.")
    end

    local node_style_def = {}

    

    return node_style_def
end

function module.WidgetStyleDef(input)
    if type(input) ~= "table" then
        error("Invalid type. Expected table.")
    end

    local widget_style_def = {}

    

    return widget_style_def
end

function module.NodeStyle(input)
    if type(input) ~= "table" then
        error("Invalid type. Expected table.")
    end

    local node_style = {}

    

    return node_style
end

function module.WidgetStyle(input)
    if type(input) ~= "table" then
        error("Invalid type. Expected table.")
    end

    local widget_style = {}

    

    return widget_style
end

return module
