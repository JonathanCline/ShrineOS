local libstr = [[
local component = component

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

Terminal = {}
if #GFXDisplayList > 0 then
    Terminal = GFXDisplayList[1]
end

Terminal.refresh = function()
    Terminal.cmin = 1
    Terminal.cy = Terminal.cmin
    _, Terminal.cmax = component.invoke(Terminal.gpu, "maxResolution")
end
function print(msg)
    component.invoke(Terminal.gpu, "set", 1, Terminal.cy, msg)
    Terminal.cy = Terminal.cy + 1
end
]]

local _, insLib = require("inslib.lua")
insLib.add_boot("01_gfx.lua", libstr)

computer.pullSignal()
