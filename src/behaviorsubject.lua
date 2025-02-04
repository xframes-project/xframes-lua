local BehaviorSubject = {}
BehaviorSubject.__index = BehaviorSubject

function BehaviorSubject.new(initialValue)
    local obj = setmetatable({}, BehaviorSubject)
    obj.value = initialValue
    obj.observers = {}
    obj.isCompleted = false
    obj.error = nil
    return obj
end

function BehaviorSubject:subscribe(onNext, onError, onCompleted)
    if self.isCompleted then
        if onCompleted then onCompleted() end
        return
    end
    if self.error then
        if onError then onError(self.error) end
        return
    end

    local observer = { onNext = onNext, onError = onError, onCompleted = onCompleted }
    table.insert(self.observers, observer)

    if self.value ~= nil then
        onNext(self.value)
    end

    return function()
        for i, obs in ipairs(self.observers) do
            if obs == observer then
                table.remove(self.observers, i)
                break
            end
        end
    end
end

function BehaviorSubject:getValue()
    if self.error then
        error(self.error)
    end
    return self.value
end

function BehaviorSubject:onNext(value)
    if self.isCompleted or self.error then return end
    self.value = value
    for _, observer in ipairs(self.observers) do
        observer.onNext(value)
    end
end

function BehaviorSubject:onError(err)
    if self.isCompleted or self.error then return end
    self.error = err
    for _, observer in ipairs(self.observers) do
        if observer.onError then observer.onError(err) end
    end
end

function BehaviorSubject:onCompleted()
    if self.isCompleted or self.error then return end
    self.isCompleted = true
    for _, observer in ipairs(self.observers) do
        if observer.onCompleted then observer.onCompleted() end
    end
end

function BehaviorSubject:hasObservers()
    return #self.observers > 0
end

function BehaviorSubject:pipe(...)
    local funcs = { ... }
    local result = self
    for _, fn in ipairs(funcs) do
        result = fn(result)
    end
    return result
end

return BehaviorSubject
