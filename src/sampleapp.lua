local array = require("array")
local BehaviorSubject = require("behaviorsubject")
local theme = require("theme")
local utils = require("utils")
local widgetnode = require("widgetnode")

local module = {}

local function make_todo_item(text, done)
    local todo_item = {
        text = text,
        done = done
    }

    return todo_item
end

local function make_app_state(todo_text, todo_items)
    return {
        todo_text = todo_text,
        todo_items = todo_items
    }
end


local app_state = BehaviorSubject.new(make_app_state("", {
    make_todo_item("todo 1", false),
    make_todo_item("todo 2", false)
}))

local function on_click()
    local new_todo_item = make_todo_item("New Todo", false)
    local current_state = app_state:getValue()
    local new_state = make_app_state(current_state.todo_text, array.concat(current_state.todo_items, { new_todo_item }))

    app_state:onNext(new_state)
end

local text_style = theme.WidgetStyle({
    style = theme.WidgetStyleDef({
        style_rules = theme.StyleRules({
            font = theme.FontDef("roboto-regular", 32)
        })
    })
})

local button_style = theme.WidgetStyle({
    style = theme.WidgetStyleDef({
        style_rules = theme.StyleRules({
            font = theme.FontDef("roboto-regular", 32)
        }),
        layout = theme.YogaStyle({
            width = "50%",
            padding = {
                [theme.Edge.Vertical] = 10
            },
            margin = {
                [theme.Edge.Left] = 140
            }
        })
    })
})

module.App = {}
module.App.__index = module.App

function module.App.new()
    local obj = setmetatable(widgetnode.Component.new(), module.App)
    obj.app_state_subscription = app_state:subscribe(function(latest_app_state)
        obj.props:onNext({
            todo_text = latest_app_state.todo_text,
            todo_items = latest_app_state.todo_items,
        })
    end)
    return obj
end

function module.App:render()
    local children = {
        widgetnode.button("Add todo", on_click, button_style)
    }

    for _, todo_item in ipairs(self.props.value.todo_items) do
        local text = string.format("%s (%s).", todo_item.text, todo_item.done and "done" or "to do")
        table.insert(children, widgetnode.unformatted_text(text, text_style))
    end

    return widgetnode.node(children)
end

function module.App:dispose()
    if self.app_state_subscription then
        self.app_state_subscription:dispose()
    end
end

module.Root = {}
module.Root.__index = module.Root

function module.Root.new()
    local obj = setmetatable(widgetnode.Component.new(), module.Root)
    return obj
end

function module.Root:render()
    return widgetnode.root_node({
        module.App.new()
    })
end

return module
