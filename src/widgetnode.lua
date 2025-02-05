local Rx = require("rx")
local WidgetTypes = require("widgettypes")
local utils = require("utils")

local module = {}

module.Component = {}
module.Component.__index = module.Component

function module.Component.new(props)
    local obj = setmetatable({}, module.Component)
    obj.props = Rx.BehaviorSubject.create(props)
    obj.__type = "Component"
    return obj
end

function module.Component:render()
    utils.print_error("render() must be implemented in subclass!")
end

function module.WidgetNode(widgetType, props, children)
    if not utils.table_contains(WidgetTypes, widgetType) then
        utils.print_error("Unrecognised widgetType")
    end

    if type(props) ~= "table" then
        utils.print_error("props must be a table")
    end

    if type(children) ~= "table" then
        utils.print_error("children must be a table")
    end

    return {
        __type = "WidgetNode",
        type = widgetType,
        props = Rx.BehaviorSubject.create(props),
        children = Rx.BehaviorSubject.create(children)
    }
end

function module.RawChildlessWidgetNodeWithId(id, widgetType, props)
    if not id or type(id) ~= "number" then
        error("Expected number for id parameter")
    end
    if not widgetType or not utils.table_contains(WidgetTypes, widgetType) then
        error("Expected valid widgetType parameter")
    end
    
    return {
        id = id,
        type = widgetType,
        props = props or {}
    }
end

function module.create_raw_childless_widget_node_with_id(id, node)
    return module.RawChildlessWidgetNodeWithId(
        id,
        node.type,
        node.props:getValue()
    )
end

local function init_props_with_style(style)
    local props = {}

    if style then
        if style.style then
            props["style"] = style.style
        end
        if style.activeStyle then
            props["activeStyle"] = style.activeStyle
        end
        if style.hoverStyle then
            props["hoverStyle"] = style.hoverStyle
        end
        if style.disabledStyle then
            props["disabledStyle"] = style.disabledStyle
        end
    end

    return props
end

function module.root_node(children, style)
    local props = init_props_with_style(style)
    props["root"] = true

    return module.WidgetNode(WidgetTypes.Node, props, children)
end

function module.node(children, style)
    local props = init_props_with_style(style)
    props["root"] = false

    return module.WidgetNode(WidgetTypes.Node, props, children)
end

function module.unformatted_text(text, style)
    if type(text) ~= "string" then
        error("Expected string for text parameter")
    end

    local props = init_props_with_style(style)

    props["text"] = text

    return module.WidgetNode(WidgetTypes.UnformattedText, props, {})
end

function module.button(label, on_click, style)
    if type(label) ~= "string" then
        error("Expected string for text parameter")
    end

    local props = init_props_with_style(style)
    props["label"] = label

    if type(on_click) == "function" then
        props["on_click"] = on_click
    end

    return module.WidgetNode(WidgetTypes.Button, props, {})
end

return module
