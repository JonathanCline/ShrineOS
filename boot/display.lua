local computer = computer
local component = component

local ScreenList = {}
local GPUList = {}

Display =
{
    gpu = component.list("gpu")(),
    screen = component.list("screen")(),
    terminal =
    {
        cy = 1,
    }
}
