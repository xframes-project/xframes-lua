local dkjson = require("dkjson")
local ffi = require("ffi")

local ImGuiCol = {
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

local fontDefs = {
    defs = {}
}

-- Original list of font names and sizes
local fontData = {
    { name = "roboto-regular", sizes = {16, 18, 20, 24, 28, 32, 36, 48} }
}

-- Convert and flatten the data
for _, entry in ipairs(fontData) do
    local name = entry.name
    for _, size in ipairs(entry.sizes) do
        table.insert(fontDefs.defs, { name = name, size = size })
    end
end


local fontDefsJson = dkjson.encode(fontDefs)

local theme2Colors = {
    darkestGrey = "#141f2c",
    darkerGrey = "#2a2e39",
    darkGrey = "#363b4a",
    lightGrey = "#5a5a5a",
    lighterGrey = "#7A818C",
    evenLighterGrey = "#8491a3",
    black = "#0A0B0D",
    green = "#75f986",
    red = "#ff0062",
    white = "#fff",
  }

  local theme2 = {
    colors = {
      [ImGuiCol.Text] = {theme2Colors.white, 1},
      [ImGuiCol.TextDisabled] = {theme2Colors.lighterGrey, 1},
      [ImGuiCol.WindowBg] = {theme2Colors.black, 1},
      [ImGuiCol.ChildBg] = {theme2Colors.black, 1},
      [ImGuiCol.PopupBg] = {theme2Colors.white, 1},
      [ImGuiCol.Border] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.BorderShadow] = {theme2Colors.darkestGrey, 1},
      [ImGuiCol.FrameBg] = {theme2Colors.black, 1},
      [ImGuiCol.FrameBgHovered] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.FrameBgActive] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.TitleBg] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.TitleBgActive] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.TitleBgCollapsed] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.MenuBarBg] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.ScrollbarBg] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.ScrollbarGrab] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.ScrollbarGrabHovered] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.ScrollbarGrabActive] = {theme2Colors.darkestGrey, 1},
      [ImGuiCol.CheckMark] = {theme2Colors.darkestGrey, 1},
      [ImGuiCol.SliderGrab] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.SliderGrabActive] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.Button] = {theme2Colors.black, 1},
      [ImGuiCol.ButtonHovered] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.ButtonActive] = {theme2Colors.black, 1},
      [ImGuiCol.Header] = {theme2Colors.black, 1},
      [ImGuiCol.HeaderHovered] = {theme2Colors.black, 1},
      [ImGuiCol.HeaderActive] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.Separator] = {theme2Colors.darkestGrey, 1},
      [ImGuiCol.SeparatorHovered] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.SeparatorActive] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.ResizeGrip] = {theme2Colors.black, 1},
      [ImGuiCol.ResizeGripHovered] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.ResizeGripActive] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.Tab] = {theme2Colors.black, 1},
      [ImGuiCol.TabHovered] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.TabActive] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.TabUnfocused] = {theme2Colors.black, 1},
      [ImGuiCol.TabUnfocusedActive] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.PlotLines] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.PlotLinesHovered] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.PlotHistogram] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.PlotHistogramHovered] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.TableHeaderBg] = {theme2Colors.black, 1},
      [ImGuiCol.TableBorderStrong] = {theme2Colors.lightGrey, 1},
      [ImGuiCol.TableBorderLight] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.TableRowBg] = {theme2Colors.darkGrey, 1},
      [ImGuiCol.TableRowBgAlt] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.TextSelectedBg] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.DragDropTarget] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.NavHighlight] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.NavWindowingHighlight] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.NavWindowingDimBg] = {theme2Colors.darkerGrey, 1},
      [ImGuiCol.ModalWindowDimBg] = {theme2Colors.darkerGrey, 1},
    },
  }

local theme2Json = dkjson.encode(theme2)

-- Declare the C function and callback types
ffi.cdef[[
    void setElement(const char* elementJson);
    void setChildren(int id, const char* childrenIds);

    typedef void (*OnInitCb)();
    typedef void (*OnTextChangedCb)(const char* text);
    typedef void (*OnComboChangedCb)(int index);
    typedef void (*OnNumericValueChangedCb)(double value);
    typedef void (*OnBooleanValueChangedCb)(int value); // 0 or 1 for false/true
    typedef void (*OnMultipleNumericValuesChangedCb)(double* values, int count);
    typedef void (*OnClickCb)();

    void init(
        const char* assetsBasePath,
        const char* rawFontDefinitions,
        const char* rawStyleOverrideDefinitions,
        OnInitCb onInit,
        OnTextChangedCb onTextChanged,
        OnComboChangedCb onComboChanged,
        OnNumericValueChangedCb onNumericValueChanged,
        OnBooleanValueChangedCb onBooleanValueChanged,
        OnMultipleNumericValuesChangedCb onMultipleNumericValuesChanged,
        OnClickCb onClick
    );
]]

-- Load the shared library
local xframes = ffi.load("xframesshared")

-- Define the Lua callbacks
local function onInit()
    print("Initialization complete!")

    local rootNode = {
        id = 0,
        type = "node",
        root = true
    }

    local unformattedText = {
        id = 1,
        type = "unformatted-text",
        text = "Hello, world"
    }

    xframes.setElement(dkjson.encode(rootNode))
    xframes.setElement(dkjson.encode(unformattedText))

    xframes.setChildren(0, dkjson.encode({1}))
end

local function onTextChanged(text)
    print("Text changed:", ffi.string(text))
end

local function onComboChanged(index)
    print("Combo selection changed to index:", index)
end

local function onNumericValueChanged(value)
    print("Numeric value changed to:", value)
end

local function onBooleanValueChanged(value)
    print("Boolean value changed to:", value == 1 and "true" or "false")
end

local function onMultipleNumericValuesChanged(values, count)
    for i = 0, count - 1 do
        print("Value", i + 1, ":", values[i])
    end
end

local function onClick()
    print("Button clicked!")
end

xframes.init(
    "./assets",
    fontDefsJson,
    theme2Json,
    ffi.cast("OnInitCb", onInit),
    ffi.cast("OnTextChangedCb", onTextChanged),
    ffi.cast("OnComboChangedCb", onComboChanged),
    ffi.cast("OnNumericValueChangedCb", onNumericValueChanged),
    ffi.cast("OnBooleanValueChangedCb", onBooleanValueChanged),
    ffi.cast("OnMultipleNumericValuesChangedCb", onMultipleNumericValuesChanged),
    ffi.cast("OnClickCb", onClick)
)

io.read()
