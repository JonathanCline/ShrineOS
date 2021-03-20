local component = component
local computer = computer

local boot = component.proxy(computer.getBootAddress())
boot.makeDirectory("lib")

local packageFile = boot.open("lib/package.lua", "w")
local function pkwrite(string)
    boot.write(packageFile, string)
end

pkwrite("function require(pkgFile)")
pkwrite("   return dofile(\"lib/\" .. pkgFile)")
pkwrite("end")

boot.close(packageFile)
