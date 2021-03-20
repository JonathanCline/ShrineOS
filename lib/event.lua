local coroutine = coroutine
local table = table
local computer = computer

local event = {}

SignalCallbacks = {}

local function listen_co(callback)
    local cb = callback
    local keepRunning = true
    while keepRunning do
        local _signal, _args = coroutine.yield()
        keepRunning = cb(_signal, table.unpack(_args))
    end
end

event.listen = function(signal, callback)

    -- Get listener table
    local cbSet = SignalCallbacks[signal]
    if not cbSet then
        SignalCallbacks[signal] = {}
        cbSet = SignalCallbacks[signal]
    end

    -- Make new coroutine
    local newCo = coroutine.create(listen_co)
    coroutine.resume(newCo, callback)

    -- Add callback coroutine to table
    cbSet[newCo] = callback

    -- Return coroutine ID
    return newCo
    
end

local function pack_signal(signal, ...)
    return signal, arg
end

event.idle = function(_timeout)
    local timeout = _timeout or 1
    local _signal, _args = pack_signal(computer.pullSignal(timeout))
    if _signal then
        computer.beep(500, 0.2)
        local cSet = SignalCallbacks[_signal]
        if cSet then
            for k, v in pairs(cSet) do
                coroutine.resume(k, _signal, _args)
                if not coroutine.running(k) then
                    cSet[k] = nil
                end
            end
            if #cSet then
                SignalCallbacks[_signal] = nil
            end
        end
    end
end

return event
