-- Main entry point for the craft slave program

local craft_slave = require("slave.craft_slave")
local craft_io = require("common.craft_io")
local computer = require("computer")
require("common.string_utils")

if not craft_io.startSlave() then -- No connection found, stop the robot
	computer.beep()
	computer.beep()
	os.exit(-1)
end

local craft_depth = 0

while true do
	local message = craft_io.receive()
	if message == "shutdown" then
		computer.beep()
		computer.beep()
		os.exit(0)
	else
		print("Executing command "..message)
		local parts = split(message, ";")
		local action = parts[1]
		if action == "start_craft" then
			craft_depth = craft_depth+1
		elseif action == "end_craft" then
			craft_depth = craft_depth-1
			if(craft_depth <= 0) then
				craft_slave.should_abort_craft = false
				craft_depth = 0
			end
		elseif action == "count" then
			local item = parts[2]
			local count = craft_slave.count(item)
			craft_io.send(count)
		elseif not craft_slave.should_abort_craft then
			if action == "put" then -- put;<item>;<position>
				craft_slave.put(parts[2], tonumber(parts[3]))
			elseif action == "craft" then -- craft;<output position>;<amount>
				craft_slave.performCraft(tonumber(parts[2]), tonumber(parts[3]))
			elseif action == "move" then
				local slot1 = tonumber(parts[2])
				local slot2 = tonumber(parts[3])
				craft_slave.move(slot1, slot2)
			end
		end
	end
end