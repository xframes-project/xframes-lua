local bit = require("bit")
local array = require("array")
local utils = require("utils")

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
    None = -1,
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

module.ImGuiDir = {
    None = -1,
    Left = 0,
    Right = 1,
    Up = 2,
    Down = 3
}

module.ImGuiHoveredFlags = {
    None = 0,
    ChildWindows = bit.lshift(1, 0),
    RootWindow = bit.lshift(1, 1),
    AnyWindow = bit.lshift(1, 2),
    NoPopupHierarchy = bit.lshift(1, 3),
    -- DockHierarchy = bit.lshift(1, 4),
    AllowWhenBlockedByPopup = bit.lshift(1, 5),
    -- AllowWhenBlockedByModal = bit.lshift(1, 6),
    AllowWhenBlockedByActiveItem = bit.lshift(1, 7),
    AllowWhenOverlappedByItem = bit.lshift(1, 8),
    AllowWhenOverlappedByWindow = bit.lshift(1, 9),
    AllowWhenDisabled = bit.lshift(1, 10),
    NoNavOverride = bit.lshift(1, 11),
    AllowWhenOverlapped = bit.bor(bit.lshift(1, 8), bit.lshift(1, 9)),  -- AllowWhenOverlappedByItem | AllowWhenOverlappedByWindow
    RectOnly = bit.bor(bit.lshift(1, 5), bit.lshift(1, 7), bit.lshift(1, 8)),  -- AllowWhenBlockedByPopup | AllowWhenBlockedByActiveItem | AllowWhenOverlapped
    RootAndChildWindows = bit.bor(bit.lshift(1, 1), bit.lshift(1, 0)),  -- RootWindow | ChildWindows
    ForTooltip = bit.lshift(1, 12),
    Stationary = bit.lshift(1, 13),
    DelayNone = bit.lshift(1, 14),
    DelayShort = bit.lshift(1, 15),
    DelayNormal = bit.lshift(1, 16),
    NoSharedDelay = bit.lshift(1, 17)
}

function module.HEXA(color, opacity)
    if type(color) ~= "string" then
        utils.print_error("Invalid color type. Expected string.")
    end
    if type(opacity) ~= "number" or opacity < 0 or opacity > 1 then
        utils.print_error("Invalid opacity. Expected a number between 0 and 1.")
    end

    return {
        color, opacity
    }
end

function module.FontDef(name, size)
    if type(name) ~= "string" then
        utils.print_error("Invalid name type. Expected string.")
    end
    if type(size) ~= "number" then
        utils.print_error("Invalid size. Expected a number.")
    end

    return {
        name = name,
        size = size
    }
end

function module.ImVec2(x, y)
    if type(x) ~= "number" then
        utils.print_error("Invalid x. Expected a number.")
    end
    if type(y) ~= "number" then
        utils.print_error("Invalid y. Expected a number.")
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

function module.is_valid_colors(input)
    if type(input) ~= "table" then
        return false
    end
    local is_valid = true
    for key, value in pairs(input) do
        if not module.table_contains(module.ImGuiCol, key) then
            is_valid = false
            break
        end
        if not module.is_valid_color_value(value) then
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
    for key, _ in pairs(input) do
        if not utils.table_contains(module.ImGuiStyleVar, key) then
            is_valid = false
            break
        end
    end

    return is_valid
end

function module.is_valid_edge_based_values_table(input)
    if type(input) ~= "table" then
        return false
    end

    local is_valid = true
    for key, value in pairs(input) do
        if not utils.table_contains(module.Edge, key) or type(value) ~= "number" then
            is_valid = false
            break
        end
    end

    return is_valid
end

function module.is_valid_gutter_based_values_table(input)
    if type(input) ~= "table" then
        return false
    end

    local is_valid = true
    for key, value in pairs(input) do
        if not utils.table_contains(module.Gutter, key) or type(value) ~= "number" then
            is_valid = false
            break
        end
    end

    return is_valid
end

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

function module.is_valid_border_style(input)
    if type(input) ~= "table" then
        return false
    end
    if type(input.color) ~= "string" then
        return false
    end

    if type(input.thickness) ~= "nil" and type(input.thickness) ~= "number" then
        return false
    end

    return true
end

function module.is_valid_round_corners(input)
    if type(input) ~= "table" then
        return false
    end
    
    return array.every(input.roundCorners, function(value)
        return utils.table_contains(module.RoundCorners, value)
    end)
end

function module.is_valid_color_value(input)
    if type(input) == "string" then
        return input:match("^#[0-9A-Fa-f]{6}$") ~= nil
    end
    if type(input) == "table" then
        if #input == 2 and type(input[1]) == "string" and type(input[2]) == "number" then
            return input[1]:match("^#[0-9A-Fa-f]{6}$") ~= nil and input[2] >= 0 and input[2] <= 1
        end
    end
    return false
end

function module.StyleRules(input)
    if type(input) ~= "table" then
        utils.print_error("Invalid type. Expected table.")
    end

    local style_rules = {}

    if type(input.align) == "string" and utils.table_contains(module.Align, input.align) then
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
        utils.print_error("Invalid color. Expected string or HEXA.")
    end

    local border_style = {
        color = color
    }
    
    if type(thickness) ~= "nil" then
        if type(thickness) ~= "number" then
            utils.print_error("Invalid thickness. Expected number.")
        end

        border_style.thickness = thickness
    end

    return border_style
end

function module.YogaStyle(input)
    if type(input) ~= "table" then
        utils.print_error("Invalid type. Expected table.")
    end

    local yoga_style = {}

    if type(input.direction) == "string" and utils.table_contains(module.Direction, input.direction) then
        yoga_style.direction = input.direction
    end

    if type(input.flexDirection) == "string" and utils.table_contains(module.FlexDirection, input.flexDirection) then
        yoga_style.flexDirection = input.flexDirection
    end

    if type(input.justifyContent) == "string" and utils.table_contains(module.JustifyContent, input.justifyContent) then
        yoga_style.justifyContent = input.justifyContent
    end

    if type(input.alignContent) == "string" and utils.table_contains(module.AlignContent, input.alignContent) then
        yoga_style.alignContent = input.alignContent
    end

    if type(input.alignItems) == "string" and utils.table_contains(module.AlignItems, input.alignItems) then
        yoga_style.alignItems = input.alignItems
    end

    if type(input.alignSelf) == "string" and utils.table_contains(module.AlignSelf, input.alignSelf) then
        yoga_style.alignSelf = input.alignSelf
    end

    if type(input.positionType) == "string" and utils.table_contains(module.PositionType, input.positionType) then
        yoga_style.positionType = input.positionType
    end

    if type(input.flexWrap) == "string" and utils.table_contains(module.FlexWrap, input.flexWrap) then
        yoga_style.flexWrap = input.flexWrap
    end

    if type(input.overflow) == "string" and utils.table_contains(module.Overflow, input.overflow) then
        yoga_style.overflow = input.overflow
    end

    if type(input.display) == "string" and utils.table_contains(module.Display, input.display) then
        yoga_style.display = input.display
    end

    if type(input.flex) == "number" then
        yoga_style.flex = input.flex
    end

    if type(input.flexGrow) == "number" then
        yoga_style.flexGrow = input.flexGrow
    end

    if type(input.flexShrink) == "number" then
        yoga_style.flexShrink = input.flexShrink
    end

    if type(input.flexBasis) == "number" then
        yoga_style.flexBasis = input.flexBasis
    end

    if type(input.flexBasisPercent) == "number" then
        yoga_style.flexBasisPercent = input.flexBasisPercent
    end

    if module.is_valid_edge_based_values_table(input.position) then
        yoga_style.position = input.position
    end

    if module.is_valid_edge_based_values_table(input.margin) then
        yoga_style.margin = input.margin
    end

    if module.is_valid_edge_based_values_table(input.padding) then
        yoga_style.padding = input.padding
    end

    if module.is_valid_gutter_based_values_table(input.gap) then
        yoga_style.gap = input.gap
    end

    if type(input.aspectRatio) == "number" then
        yoga_style.aspectRatio = input.aspectRatio
    end

    if type(input.width) == "number" or type(input.width) == "string" then
        yoga_style.width = input.width
    end

    if type(input.minWidth) == "number" or type(input.minWidth) == "string" then
        yoga_style.minWidth = input.minWidth
    end

    if type(input.maxWidth) == "number" or type(input.maxWidth) == "string" then
        yoga_style.maxWidth = input.maxWidth
    end

    if type(input.height) == "number" or type(input.height) == "string" then
        yoga_style.height = input.height
    end

    if type(input.minHeight) == "number" or type(input.minHeight) == "string" then
        yoga_style.minHeight = input.minHeight
    end

    if type(input.maxHeight) == "number" or type(input.maxHeight) == "string" then
        yoga_style.maxHeight = input.maxHeight
    end

    return yoga_style
end

function module.BaseDrawStyle(input)
    if type(input) ~= "table" then
        utils.print_error("Invalid type. Expected table.")
    end

    local base_draw_style = {}

    if type(input.backgroundColor) == "number" or type(input.backgroundColor) == "string" then
        base_draw_style.backgroundColor = input.backgroundColor
    end

    if module.is_valid_border_style(input.border) then
        base_draw_style.border = input.border
    end

    if module.is_valid_border_style(input.borderTop) then
        base_draw_style.borderTop = input.borderTop
    end

    if module.is_valid_border_style(input.borderRight) then
        base_draw_style.borderRight = input.borderRight
    end

    if module.is_valid_border_style(input.borderBottom) then
        base_draw_style.borderBottom = input.borderBottom
    end

    if module.is_valid_border_style(input.borderLeft) then
        base_draw_style.borderLeft = input.borderLeft
    end
    
    if type(input.rounding) == "number" then
        base_draw_style.rounding = input.rounding
    end
    
    if module.is_valid_round_corners(input.roundCorners) then
        base_draw_style.roundCorners = input.roundCorners
    end

    return base_draw_style
end

function module.NodeStyleDef(input)
    if type(input) ~= "table" then
        utils.print_error("Invalid type. Expected table.")
    end

    local node_style_def = {}

    if type(input.layout) == "table" then
        for k, v in pairs(input.layout) do
            node_style_def[k] = v
        end
    end

    if type(input.base_draw) == "table" then
        for k, v in pairs(input.base_draw) do
            node_style_def[k] = v
        end
    end

    return node_style_def
end

function module.WidgetStyleDef(input)
    if type(input) ~= "table" then
        utils.print_error("Invalid type. Expected table.")
    end

    local widget_style_def = {}

    if type(input.style_rules) == "table" then
        for k, v in pairs(input.style_rules) do
            widget_style_def[k] = v
        end
    end

    if type(input.layout) == "table" then
        for k, v in pairs(input.layout) do
            widget_style_def[k] = v
        end
    end

    if type(input.base_draw) == "table" then
        for k, v in pairs(input.base_draw) do
            widget_style_def[k] = v
        end
    end

    return widget_style_def
end

function module.NodeStyle(input)
    if type(input) ~= "table" then
        utils.print_error("Invalid type. Expected table.")
    end

    local node_style = {}

    if type(input.style) == "table" then
        node_style.style = input.style
    end

    if type(input.hoverStyle) == "table" then
        node_style.hoverStyle = input.hoverStyle
    end

    if type(input.activeStyle) == "table" then
        node_style.activeStyle = input.activeStyle
    end

    if type(input.disabledStyle) == "table" then
        node_style.disabledStyle = input.disabledStyle
    end

    return node_style
end

function module.WidgetStyle(input)
    if type(input) ~= "table" then
        utils.print_error("Invalid type. Expected table.")
    end

    local widget_style = {}

    if type(input.style) == "table" then
        widget_style.style = input.style
    end

    if type(input.hoverStyle) == "table" then
        widget_style.hoverStyle = input.hoverStyle
    end

    if type(input.activeStyle) == "table" then
        widget_style.activeStyle = input.activeStyle
    end

    if type(input.disabledStyle) == "table" then
        widget_style.disabledStyle = input.disabledStyle
    end
    

    return widget_style
end

return module
