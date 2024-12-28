local dkjson = require("dkjson")
local ffi = require("ffi")

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

-- Declare the C function and callback types
ffi.cdef[[
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
    "{}",
    ffi.cast("OnInitCb", onInit),
    ffi.cast("OnTextChangedCb", onTextChanged),
    ffi.cast("OnComboChangedCb", onComboChanged),
    ffi.cast("OnNumericValueChangedCb", onNumericValueChanged),
    ffi.cast("OnBooleanValueChangedCb", onBooleanValueChanged),
    ffi.cast("OnMultipleNumericValuesChangedCb", onMultipleNumericValuesChanged),
    ffi.cast("OnClickCb", onClick)
)

io.read()
