local libString = [[
local computer = computer
local component = component

local insLib = {}

local boot = component.proxy(computer.getBootAddress())

insLib.add_library = function(name, data)
    local file = boot.open("lib/" .. name, "w")
    boot.write(file, data)
    boot.close(file)
end

insLib.add_boot = function(name, data)
    local file = boot.open("boot/" .. name, "w")
    boot.write(file, data)
    boot.close(file)
end

return insLib
]]

local computer = computer
local component = component
local boot = component.proxy(computer.getBootAddress())
local fHandle = boot.open("/lib/inslib.lua", "w")
boot.write(fHandle, libString)
boot.close(fHandle)
