local computer = computer
local component = component
local table = table
--local coroutime = coroutine

do
    local gpu = component.list("gpu")()
    local screen = component.list("screen")()

    component.invoke(gpu, "bind", screen, true)
    component.invoke(gpu, "set", 1, 1, "MakinPancakes got big gay")
end

local bootFileSystem = computer.getBootAddress()

function loadfile(_path)
    local file = component.invoke(bootFileSystem, "open", _path, "r")
    local fileData = ""
    local gotData = component.invoke(bootFileSystem, "read", file, 64)
    while gotData do
        fileData = fileData .. gotData
        gotData = component.invoke(bootFileSystem, "read", file, 64)
    end
    return fileData
end

function dofile(_path, ...)
    local fData = loadfile(_path)
    local fFunc = load(fData)
    if not fFunc then
        return nil
    else
        return true, fFunc(table.unpack(arg))
    end
end

dofile("./lib/tlib.lua")
--computer.beep(750, 0.5)

computer.pullSignal()
computer.shutdown()
