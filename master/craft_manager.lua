local craft_manager = {}
local constants = require("common.constants")
local components = require("component")
local events = require("event")
local modem = components.modem

function craft_manager.init(slaveAddress)
	craft_manager.slaveAddress = slaveAddress
end

function craft_manager.send(message)
	modem.send(craft_manager.slaveAddress, constants.slave_port, message)
end

function craft_manager.ask(message)
	craft_manager.send(message)
	local id, remoteAddress, senderAddress, port, distance, message = events.pull("modem_message")
	return message
end

function craft_manager.move(slot1, slot2)
	craft_manager.send("move;"..slot1..";"..slot2)
end

function craft_manager.count(item)
	return craft_manager.ask("count;"..item)
end

function craft_manager.fail(message)
	print("[ERROR] "..message)
end

function craft_manager.put(item, position)
	craft_manager.send("put;"..item..";"..position)
end

function craft_manager.perform_craft(outputPosition, amount)
	craft_manager.send("craft;"..outputPosition..";"..amount)
end

function craft_manager.begin_craft()
	craft_manager.send("begin_craft")
end

function craft_manager.end_craft()
	craft_manager.send("end_craft")
end

-- Returns true if the craft could be done
-- false otherwise
function craft_manager.craft(craftname, outputPosition)
	local craft = require("crafts."..craftname)
	return craft(craft_manager, outputPosition)
end

return craft_manager
