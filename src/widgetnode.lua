local WidgetTypes = require("widgettypes")

local module = {}

function module.widget_node_factory(widgetType, props, children)
    local node = {
        type = widgetType,
        props = props or {},
        children = children or {}
    }

    return node
end

function init_props_with_style(style)
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
    
    return widget_node_factory(WidgetTypes.Node, props, children)
end

function module.node(children, style)
    local props = init_props_with_style(style)
    props["root"] = false
    
    return widget_node_factory(WidgetTypes.Node, props, children)
end

return module
