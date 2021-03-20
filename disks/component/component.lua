
local libString = [[
local component = component

component.all = function(name)
    local out = {}
    local iter = component.list(name)
    local comp = iter()
    while comp do
        out[#out+1] = comp
        comp = iter()
    end
    return comp
end

return component
]]

local _, inslib = require("inslib.lua")
inslib.add_library("component.lua", libString)
