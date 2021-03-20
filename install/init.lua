local computer = computer
local component = component
local table = table
--local coroutime = coroutine

local bootFileSystem = computer.getBootAddress()

function loadfile(_path, _filesystem)
    local fs = _filesystem or bootFileSystem 
    local file = component.invoke(fs, "open", _path, "r")
    local fileData = ""
    local gotData = component.invoke(fs, "read", file, 64)
    while gotData do
        fileData = fileData .. gotData
        gotData = component.invoke(fs, "read", file, 64)
    end
    return fileData
end

function dofile(_path, _filesystem, ...)
    local fs = _filesystem or bootFileSystem
    local fData = loadfile(_path, fs)
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

-- Loop through /boot and run anything in there
do
    local boot = component.proxy(bootFileSystem)
    local bootFiles = boot.list("/boot/")
    for k, v in pairs(bootFiles) do
        dofile(v, boot.address)
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
    dofile("/.install", dfs.address)
end

computer.shutdown()
