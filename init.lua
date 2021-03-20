local computer = computer
local component = component
--local table = table
--local coroutime = coroutine

do
    local gpu = component.list("gpu")()
    local screen = component.list("screen")()

    component.invoke(gpu, "bind", screen, true)
    component.invoke(gpu, "set", 1, 1, "MakinPancakes got big gay")
end

computer.beep(750, 0.5)

computer.pullSignal()
computer.shutdown()
