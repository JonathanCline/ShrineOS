local libstr = [[
local component = require("component.lua")

GFXDisplayList = nil
GFXDisplayList = {}
do

    local gpu_iter = component.list("gpu")
    local screen_iter = component.list("screen")

    local gpu = gpu_iter()

    while gpu do
        local display =
        {
            gpu = gpu,
            screen = screen_iter()
        }
        if display.screen then
            component.invoke(display.gpu, "bind", display.screen, true)
            component.invoke(display.gpu, "set", 1, 1, tostring(#GFXDisplayList+1))
        end
        GFXDisplayList[#GFXDisplayList+1] = display
        gpu = gpu_iter()
    end

end
]]

local _, insLib = require("insLib.lua")
insLib.add_boot("01_gfx.lua", libstr)
