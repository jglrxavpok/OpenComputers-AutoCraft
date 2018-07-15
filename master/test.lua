local computer = require("computer")
local components = require("component")
local events = require("event")
local constants = require("common.constants")
local craft_manager = require("master.craft_manager")
local modem = components.modem

modem.open(constants.master_port)

local id, remoteAddress, senderAddress, port, distance, message = events.pull("modem_message")
function count(item)
	modem.send(senderAddress, constants.slave_port, "count;"..item)
	local id, remoteAddress, senderAddress, port, distance, message =events.pull("modem_message")
	print(message)
	return message
end

craft_manager.init(senderAddress)

if message == constants.slave_connection_attempt_message then
	modem.send(senderAddress, constants.slave_port, constants.master_connection_authorization_message)
	craft_manager.craft("electronic_circuit", -1)
end