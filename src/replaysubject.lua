local ReplaySubject = {}
ReplaySubject.__index = ReplaySubject

function ReplaySubject.new(bufferSize)
    local obj = setmetatable({}, ReplaySubject)
    obj.observers = {}
    obj.buffer = {}
    obj.bufferSize = bufferSize or math.huge
    obj.isCompleted = false
    obj.error = nil
    return obj
end

function ReplaySubject:subscribe(onNext, onError, onCompleted)
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

    for _, value in ipairs(self.buffer) do
        onNext(value)
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

function ReplaySubject:onNext(value)
    if self.isCompleted or self.error then return end

    table.insert(self.buffer, value)
    if #self.buffer > self.bufferSize then
        table.remove(self.buffer, 1)
    end

    for _, observer in ipairs(self.observers) do
        observer.onNext(value)
    end
end

function ReplaySubject:error(err)
    if self.isCompleted or self.error then return end
    self.error = err
    for _, observer in ipairs(self.observers) do
        if observer.onError then observer.onError(err) end
    end
end

function ReplaySubject:complete()
    if self.isCompleted or self.error then return end
    self.isCompleted = true
    for _, observer in ipairs(self.observers) do
        if observer.onCompleted then observer.onCompleted() end
    end
end

function ReplaySubject:hasObservers()
    return #self.observers > 0
end

function ReplaySubject:pipe(...)
    local funcs = { ... }
    local result = self
    for _, fn in ipairs(funcs) do
        result = fn(result)
    end
    return result
end

return ReplaySubject
