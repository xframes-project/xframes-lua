local ffi = require("ffi")

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

return xframes