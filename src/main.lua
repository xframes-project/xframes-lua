local dkjson = require("dkjson")
local ffi = require("ffi")

local BehaviorSubject = require("behaviorsubject")

local theme = require("theme")

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
      [theme.ImGuiCol.Text] = {theme2Colors.white, 1},
      [theme.ImGuiCol.TextDisabled] = {theme2Colors.lighterGrey, 1},
      [theme.ImGuiCol.WindowBg] = {theme2Colors.black, 1},
      [theme.ImGuiCol.ChildBg] = {theme2Colors.black, 1},
      [theme.ImGuiCol.PopupBg] = {theme2Colors.white, 1},
      [theme.ImGuiCol.Border] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.BorderShadow] = {theme2Colors.darkestGrey, 1},
      [theme.ImGuiCol.FrameBg] = {theme2Colors.black, 1},
      [theme.ImGuiCol.FrameBgHovered] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.FrameBgActive] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.TitleBg] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.TitleBgActive] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.TitleBgCollapsed] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.MenuBarBg] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.ScrollbarBg] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.ScrollbarGrab] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.ScrollbarGrabHovered] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.ScrollbarGrabActive] = {theme2Colors.darkestGrey, 1},
      [theme.ImGuiCol.CheckMark] = {theme2Colors.darkestGrey, 1},
      [theme.ImGuiCol.SliderGrab] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.SliderGrabActive] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.Button] = {theme2Colors.black, 1},
      [theme.ImGuiCol.ButtonHovered] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.ButtonActive] = {theme2Colors.black, 1},
      [theme.ImGuiCol.Header] = {theme2Colors.black, 1},
      [theme.ImGuiCol.HeaderHovered] = {theme2Colors.black, 1},
      [theme.ImGuiCol.HeaderActive] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.Separator] = {theme2Colors.darkestGrey, 1},
      [theme.ImGuiCol.SeparatorHovered] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.SeparatorActive] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.ResizeGrip] = {theme2Colors.black, 1},
      [theme.ImGuiCol.ResizeGripHovered] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.ResizeGripActive] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.Tab] = {theme2Colors.black, 1},
      [theme.ImGuiCol.TabHovered] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.TabActive] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.TabUnfocused] = {theme2Colors.black, 1},
      [theme.ImGuiCol.TabUnfocusedActive] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.PlotLines] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.PlotLinesHovered] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.PlotHistogram] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.PlotHistogramHovered] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.TableHeaderBg] = {theme2Colors.black, 1},
      [theme.ImGuiCol.TableBorderStrong] = {theme2Colors.lightGrey, 1},
      [theme.ImGuiCol.TableBorderLight] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.TableRowBg] = {theme2Colors.darkGrey, 1},
      [theme.ImGuiCol.TableRowBgAlt] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.TextSelectedBg] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.DragDropTarget] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.NavHighlight] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.NavWindowingHighlight] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.NavWindowingDimBg] = {theme2Colors.darkerGrey, 1},
      [theme.ImGuiCol.ModalWindowDimBg] = {theme2Colors.darkerGrey, 1},
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

local os_name = package.config:sub(1,1) == "\\" and "win" or "unix"

local xframes = ffi.load(os_name == "win" and "xframesshared" or "./libxframesshared.so")

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

local subject = BehaviorSubject.new(42)

local unsubscribe = subject:subscribe(
    function(x) print("Received:", x) end,
    function(err) print("Error:", err) end,
    function() print("Completed") end
)

subject:onNext(56)

print("Current value:", subject:getValue())

subject:onCompleted()

unsubscribe()

xframes.init(
    "../assets",
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
