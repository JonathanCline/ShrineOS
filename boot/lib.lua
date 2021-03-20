local component = component
local computer = computer
local string = string

local boot = component.proxy(computer.getBootAddress())
boot.makeDirectory("lib")

local packageFile = boot.open("lib/package.lua", "w")
local function pkwrite(string)
    boot.write(packageFile, string)
end

pkwrite("function require(pkgFile)\n")
pkwrite("   return dofile(\"lib/\" .. pkgFile)\n")
pkwrite("end")

boot.close(packageFile)

local pkgBootFile = boot.open("boot/00_package.lua", "w")
boot.write(pkgBootFile, "dofile(\"lib/package.lua\")")
boot.close(pkgBootFile)
