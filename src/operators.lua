local luv = require("luv")

local module = {}

function module.map(transform)
    return function(subject)
        local newSubject = BehaviorSubject.new()
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
        local newSubject = BehaviorSubject.new()
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
        local newSubject = BehaviorSubject.new()
        local timer = nil
        
        subject:subscribe(
            function(value)
                if timer then
                    timer:cancel()
                end
                timer = luv.timer.new()
                timer:start(delay, 0, function()
                    newSubject:onNext(value)
                    timer:close()
                    timer = nil
                end)
            end,
            function(err) newSubject:onError(err) end,
            function() 
                if timer then
                    timer:cancel()
                end
                newSubject:onCompleted() 
            end
        )
        
        return newSubject
    end
end


return module
