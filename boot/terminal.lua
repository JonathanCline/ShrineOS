local computer = computer
local component = component

Display =
{
    gpu = component.list("gpu")(),
    screen = component.list("screen")(),
    terminal =
    {
        cy = 1
    }
}

component.invoke(Display.gpu, "bind", Display.screen)

function print(string)
    component.invoke(Display.gpu, "set", 1, Display.terminal.cy, string)
    Display.terminal.cy = Display.terminal.cy + 1 
end

print("This is a test")
print("Of your mother's")
print("Massive penis")
