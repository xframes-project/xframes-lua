local array = require("array")
local BehaviorSubject = require("behaviorsubject")

local function make_todo_item(text, done)
    local todo_item = {
        text = text,
        done = done
    }

    return todo_item
end

local function make_app_state(todo_text, todo_items)
    local app_state = {
        todo_text = todo_text,
        todo_items = todo_items
    }

    return app_state
end


local app_state = BehaviorSubject.new(make_app_state("", {}))

local function on_click()
    local new_todo_item = make_todo_item("New Todo", false)
    local current_state = app_state:getValue()
    local new_state = make_app_state(current_state.todo_text, array.concat(current_state.todo_items, {new_todo_item}))

    app_state:onNext(new_state)
end