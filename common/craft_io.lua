local craft_io = {}
require("common.string_utils")
local robot = require("robot")
local components = require("component")
local modem = components.modem
local events = require("event")
local constants = require("common.constants")

local slave_port = constants.slave_port
local master_port = constants.master_port

modem.setStrength(constants.signal_strength)

-- Starts the connection between master and slave
-- Returns false if no master was found and true if the connection was successfully established
function craft_io.startSlave()
	modem.open(slave_port)
	modem.broadcast(master_port, constants.slave_connection_attempt_message)
	local id, _, from, port, _, message = events.pull(10, "modem_message")
	if id == nil or not (message == constants.master_connection_authorization_message) then
		return false
	end
	craft_io.master_address = from
	return true
end

-- Receives a message from the master and returns it
-- Returns nil if time out
function craft_io.receive()
	local id, _, from, port, _, message = events.pull("modem_message")
	if id == nil then
		return nil
	end
	return message
end

function craft_io.send(message)
	return modem.send(craft_io.master_address, master_port, message)
end

return craft_io
