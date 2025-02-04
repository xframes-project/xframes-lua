local WidgetTypes = require("widgettypes")
local BehaviorSubject = require("behaviorsubject")
local utils = require("utils")

local module = {}

module.BaseComponent = {}
module.BaseComponent.__index = module.BaseComponent

function module.BaseComponent.new(props)
    local obj = setmetatable({}, module.BaseComponent)
    obj.props = BehaviorSubject.new(props)
    return obj
end

function module.BaseComponent:render()
    error("render() must be implemented in subclass!")
end

function module.WidgetNode(widgetType, props, children)
    if not utils.table_contains(WidgetTypes, widgetType) then
        error("Unrecognised widgetType")
    end

    if type(props) ~= "table" then
        error("props must be a table")
    end

    if type(children) ~= "table" then
        error("children must be a table")
    end

    return {
        type = type,
        props = BehaviorSubject.new(props),
        children = BehaviorSubject.new(children)
    }
end

function module.widget_node_factory(widgetType, props, children)
    local node = {
        type = widgetType,
        props = props or {},
        children = children or {}
    }

    return node
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
    
    return module.widget_node_factory(WidgetTypes.Node, props, children)
end

function module.node(children, style)
    local props = init_props_with_style(style)
    props["root"] = false
    
    return module.widget_node_factory(WidgetTypes.Node, props, children)
end

return module
