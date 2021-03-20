
local component = require("component")
local shell = require("shell")

local args, ops = shell.parse(...)

local disk_drive = component.disk_drive
assert(not disk_drive.empty())
local dest = component.proxy(disk_drive.media)

local here = shell.getWorkingDirectory()
local inputPath = here .. "/disks/" .. args[1]
