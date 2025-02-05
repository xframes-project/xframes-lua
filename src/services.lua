local dkjson = require("dkjson")
local ReplaySubject = require("replaysubject")
local utils = require("utils")
local xframes = require("xframes")

local WidgetRegistrationService = {}
WidgetRegistrationService.__index = WidgetRegistrationService

function WidgetRegistrationService.new()
    local obj = setmetatable({}, WidgetRegistrationService)
    obj.events_subject = ReplaySubject.new(10)

    obj.events_subject:subscribe(function(fn) 
        fn()
    end)

    obj.widget_registry = {}
    obj.on_click_registry = {}

    obj.last_widget_id = 0
    obj.last_component_id = 0
    return obj
end

function WidgetRegistrationService:get_widget_by_id(widget_id)
    return self.widget_registry[widget_id]
end

function WidgetRegistrationService:register_widget(widget_id, widget)
    self.widget_registry[widget_id] = widget
end

function WidgetRegistrationService:get_next_widget_id()
    local widget_id = self.last_widget_id
    self.last_widget_id = self.last_widget_id + 1
    return widget_id
end

function WidgetRegistrationService:get_next_component_id()
    local component_id = self.last_component_id
    self.last_component_id = self.last_component_id + 1
    return component_id
end

function WidgetRegistrationService:register_on_click(widget_id, on_click)
    self.on_click_registry[widget_id] = on_click
end

function WidgetRegistrationService:dispatch_on_click_event(widget_id)
    local on_click = self.on_click_registry[widget_id]
    if self.on_click_registry[widget_id] then
        self.events_subject:onNext(on_click)
    else
        print(string.format("Widget with id %d has no on_click handler", widget_id))
    end
end

function WidgetRegistrationService:create_widget(widget)
    local filtered_widget = {
        id = widget.id,
        type = widget.type
    }

    for key, value in pairs(widget.props) do
        if type(value) ~= "function" then
            filtered_widget[key] = value
        end
    end

    local widget_json = dkjson.encode(filtered_widget)

    self:set_element(widget_json)
end

function WidgetRegistrationService:patch_widget(widget_id, widget)
    local widget_json = dkjson.encode(widget)
    self:patch_element(widget_id, widget_json)
end

function WidgetRegistrationService:link_children(widget_id, child_ids)
    local children_json = dkjson.encode(child_ids)
    self:set_children(widget_id, children_json)
end

function WidgetRegistrationService:set_data(widget_id, data)
    local data_json = dkjson.encode(data)
    self:element_internal_op(widget_id, data_json)
end

function WidgetRegistrationService:append_data(widget_id, data)
    local data_json = dkjson.encode(data)
    self:element_internal_op(widget_id, data_json)
end

function WidgetRegistrationService:reset_data(widget_id, data)
    local data_json = data and dkjson.encode(data) or dkjson.encode("")
    self:element_internal_op(widget_id, data_json)
end

function WidgetRegistrationService:append_data_to_plot_line(widget_id, x, y)
    local plot_data = { x = x, y = y }
    self:element_internal_op(widget_id, dkjson.encode(plot_data))
end

function WidgetRegistrationService:set_plot_line_axes_decimal_digits(widget_id, x, y)
    local axes_data = { x = x, y = y }
    self:element_internal_op(widget_id, dkjson.encode(axes_data))
end

function WidgetRegistrationService:append_text_to_clipped_multi_line_text_renderer(widget_id, text)
    self:extern_append_text(widget_id, text)
end

function WidgetRegistrationService:set_input_text_value(widget_id, value)
    self:element_internal_op(widget_id, value)
end

function WidgetRegistrationService:set_combo_selected_index(widget_id, index)
    local selected_index_data = { index = index }
    self:element_internal_op(widget_id, dkjson.encode(selected_index_data))
end

function WidgetRegistrationService:set_element(json_data)
    -- print(debug.traceback())
    xframes.setElement(json_data)
end

function WidgetRegistrationService:patch_element(widget_id, json_data)
    -- Implementation not provided in the original code
end

function WidgetRegistrationService:set_children(widget_id, json_data)
    xframes.setChildren(widget_id, json_data)
end

function WidgetRegistrationService:element_internal_op(widget_id, json_data)
    -- Implementation not provided in the original code
end

return WidgetRegistrationService
