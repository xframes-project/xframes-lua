local array = require("array")
local luv = require("luv")
local widgetnode = require("widgetnode")
local ops = require("operators")
local utils = require("utils")
local WidgetTypes = require("WidgetTypes")

local function ShadowNode(id, renderable)
    return {
        __type = "ShadowNode",
        id = id,
        renderable = renderable,
        current_props = {},
        children = {},
        props_change_subscription = nil,
        children_change_subscription = nil
    }
end

local function get_linkable_children(node)
    local out = {}

    for _, child in ipairs(node.children) do
        if child and child.renderable then
            if child.renderable.__type == "WidgetNode" then
                table.insert(out, child)
            elseif #child.children > 0 then
                local nested_children = get_linkable_children(child)
                for _, nested_child in ipairs(nested_children) do
                    table.insert(out, nested_child)
                end
            end
        end
    end

    return out
end

local ShadowNodeTraversalHelper = {}
ShadowNodeTraversalHelper.__index = ShadowNodeTraversalHelper

function ShadowNodeTraversalHelper.new(widget_registration_service)
    local obj = setmetatable({}, ShadowNodeTraversalHelper)
    obj.widget_registration_service = widget_registration_service
    return obj
end

function ShadowNodeTraversalHelper:are_props_equal(props1, props2)
    return props1 == props2
end

function ShadowNodeTraversalHelper:subscribe_to_props_helper(shadow_node)
    if shadow_node.props_change_subscription then
        -- shadow_node.props_change_subscription()
    end

    local renderable = shadow_node.renderable
    local counter = 0

    if renderable.__type == "Component" then
        shadow_node.props_change_subscription = renderable.props:subscribe(function(new_props)
            if counter < 1 then
                counter = counter + 1
            else
                print("aaaaaaaaa")
                coroutine.wrap(function() 
                    self:handle_component_props_change(shadow_node, renderable, new_props)
                end)()
                print("bbbbbbbbb")
            end
        end)
    elseif renderable.__type == "WidgetNode" then
        shadow_node.props_change_subscription = renderable.props:subscribe(function(new_props)
            if counter < 1 then
                counter = counter + 1
            else
                print("ccccccccccccc")

                coroutine.wrap(function() 
                    self:handle_widget_node_props_change(shadow_node, renderable, new_props)
                end)()

                print("dddddddddddd")

                luv.run("nowait")
            end
        end)
    end
end

function ShadowNodeTraversalHelper:handle_widget_node(widget)
    if widget.type == WidgetTypes.Button then
        local on_click = widget.props["on_click"]
        if on_click then
            self.widget_registration_service:register_on_click(widget.id, on_click)
        else
            print("Button widget must have on_click prop")
        end
    end
end

function ShadowNodeTraversalHelper:handle_component_props_change(shadow_node, component, new_props)
    print("handle_component_props_change a")
    if self:are_props_equal(shadow_node.current_props, new_props) then
        return
    end

    print("handle_component_props_change b")

    local shadow_child = component:render()

    print("handle_component_props_change c")
    -- print(utils.table_to_string(shadow_child))

    shadow_node.children = { self:traverse_tree(shadow_child) }

    print("handle_component_props_change d")

    shadow_node.current_props = new_props

    print("handle_component_props_change e")

    local linkable_children = get_linkable_children(shadow_node)

    print("handle_component_props_change f")

    self.widget_registration_service:link_children(shadow_node.id,
        array.map(linkable_children, function(child) return child.id end))

    print("handle_component_props_change g")
end

function ShadowNodeTraversalHelper:handle_widget_node_props_change(shadow_node, widget_node, new_props)
    self.widget_registration_service:create_widget(
        widgetnode.create_raw_childless_widget_node_with_id(shadow_node.id, widget_node)
    )

    local shadow_children = array.map(widget_node.children:getValue(), function(child)
        return self:traverse_tree(child)
    end)

    shadow_node.children = shadow_children
    shadow_node.current_props = new_props

    self.widget_registration_service:link_children(shadow_node.id,
        array.map(shadow_node.children, function(child) return child.id end))
end

function ShadowNodeTraversalHelper:traverse_tree(renderable)
    if type(renderable) == "nil" then
        print("Received renderable is nil")
        error("Received renderable is nil")
    end

    if renderable.__type == "Component" then
        print("a0")
        local shadow_child = self:traverse_tree(renderable:render())
        print("a1")
        local id = self.widget_registration_service:get_next_component_id()
        print("a2")
        local shadow_node = ShadowNode(id, renderable)
        print("a3")
        shadow_node.children = { shadow_child }
        print("a4")
        shadow_node.current_props = renderable.props:getValue()
        print("a5")

        self:subscribe_to_props_helper(shadow_node)
        print("a6")

        return shadow_node
    elseif renderable.__type == "WidgetNode" then
        print("b0")
        local id = self.widget_registration_service:get_next_widget_id()
        print("b1")
        local raw_node = widgetnode.create_raw_childless_widget_node_with_id(id, renderable)
        print("b2")

        self:handle_widget_node(raw_node)
        print("b3")
        self.widget_registration_service:create_widget(raw_node)
        print("b4")

        local shadow_node = ShadowNode(id, renderable)
        print("b5")

        shadow_node.children = array.map(renderable.children:getValue(), function(child)
            return self:traverse_tree(child)
        end)

        print("b6")

        shadow_node.current_props = renderable.props:getValue()

        print("b7")

        local linkable_children = get_linkable_children(shadow_node)

        print("b8")

        if #linkable_children > 0 then
            self.widget_registration_service:link_children(id,
                array.map(linkable_children, function(child) return child.id end))
        end

        print("b9")

        self:subscribe_to_props_helper(shadow_node)

        print("b10")

        return shadow_node
    else
        print("Unrecognized renderable")
        error("Unrecognized renderable")
    end
end

return ShadowNodeTraversalHelper
