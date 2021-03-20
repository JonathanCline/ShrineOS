local computer = computer
local component = component
local table = table
--local coroutime = coroutine

local gpu = component.list("gpu")()
local screen = component.list("screen")()
 
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

local fsList = {}
do
    local fsIter = component.list("filesystem")
    local fs = fsIter()
    while fs do
        fsList[fs] = fs
        fs = fsIter()
    end
end

component.invoke(gpu, "set", 1, 2, "Select Install Destination")
local sy = 3
for k, v in pairs(fsList) do
    component.invoke(gpu, "set", 1, sy, tostring(sy - 2) .. " " .. k)
    sy = sy + 1
end



local _, event = dofile("./lib/event.lua")

SelectedFS = 1

local function keyup_callback(_signal, _keyboard, char, _, _)
    SelectedFS = tonumber(char)
    component.invoke(gpu, "set", 1, sy + 1, tostring(SelectedFS))
    return true
end

event.listen("key_up", keyup_callback)
while true do
    event.idle()
end

computer.shutdown()
