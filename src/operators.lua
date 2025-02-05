local luv = require("luv")
local BehaviorSubject = require("behaviorsubject")
local ReplaySubject = require("replaysubject")

local module = {}

local function createSubject(inputSubject)
    if inputSubject.getValue then
        return BehaviorSubject.new(inputSubject:getValue())
    else
        return ReplaySubject.new(inputSubject.bufferSize or 1)
    end
end

function module.map(transform)
    return function(subject)
        local newSubject = createSubject(subject)
        subject:subscribe(
            function(value)
                newSubject:onNext(transform(value))
            end,
            function(err) newSubject:onError(err) end,
            function() newSubject:onCompleted() end
        )
        return newSubject
    end
end

function module.filter(predicate)
    return function(subject)
        local newSubject = createSubject(subject)
        subject:subscribe(
            function(value)
                if predicate(value) then
                    newSubject:onNext(value)
                end
            end,
            function(err) newSubject:onError(err) end,
            function() newSubject:onCompleted() end
        )
        return newSubject
    end
end

function module.debounce(delay)
    return function(subject)
        local newSubject = createSubject(subject)
        local timer = nil

        subject:subscribe(
            function(value)
                if timer then
                    timer:stop()
                    timer:close()
                else
                    timer = luv.new_timer()
                end
                timer:start(delay, 0, function()
                    newSubject:onNext(value)
                    luv.defer(function() timer:close() end)
                    timer = nil
                end)
            end,
            function(err) newSubject:onError(err) end,
            function()
                if timer then
                    timer:stop()
                    timer:close()
                    -- luv.defer(function() timer:close() end)
                end
                newSubject:onCompleted()
            end
        )

        return newSubject
    end
end

---Inspired by https://reactivex.io/documentation/operators/skip.html
---@param count number
---@return function
function module.skip(count)
    return function(subject)
        local newSubject = createSubject(subject)
        local skipped = 0

        subject:subscribe(
            function(value)
                if skipped < count then
                    skipped = skipped + 1
                else
                    newSubject:onNext(value)
                end
            end,
            function(err) newSubject:onError(err) end,
            function() newSubject:onCompleted() end
        )

        return newSubject
    end
end

return module
