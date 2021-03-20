local computer = computer
local component = component
local table = table
--local coroutime = coroutine

local gpu = component.list("gpu")()
local screen = component.list("screen")()
local keyboard = component.invoke(screen, "getKeyboards")[1]

do
    component.invoke(gpu, "bind", screen, true)
    component.invoke(gpu, "set", 1, 1, "ShrineOS")
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
        return false
    else
        if arg then
            return true, fFunc(table.unpack(arg))
        else
            return true, fFunc()
        end
    end
end

DiskDrive = component.list("disk_drive")()
if not DiskDrive then
    computer.beep(750, 0.4)
    computer.beep(750, 0.4)
    error("No disk drive")
    computer.shutdown()
    return
end

local DiskAddr = component.invoke(DiskDrive, "media")
if not DiskAddr then
    computer.beep(750, 0.4)
    computer.beep(750, 0.4)
    error("No additional installation disk")
    computer.shutdown()
    return
end

local dfs = component.proxy(DiskAddr)
if dfs.exists("/.install") then
    local ifile = dfs.open("/.install")
    dofile(ifile, computer.getBootAddress())
end

computer.shutdown()
