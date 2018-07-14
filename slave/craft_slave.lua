-- TODO: Choose the amount of items crafted at once

-- Configuration: (O: output, I: input, P: power)
--  O   (from the side)
-- III
--  P
--
--  I   (from above)
-- IOI
--  I

local craft_slave = {}
local robot = require("robot")
local components = require("component")
local inventory_controller = components.inventory_controller
local craft = components.crafting
local sideEnum = require("sides")
local inputSides = {0, 1, 2, 3}
local outputSide = sideEnum.top

-- Returns the rotation and index in the inventory of the given item
-- 'side' is "internal" if the item is in the inventory of the robot
-- 'side' is nil if no item is found
-- The robot will be in front of the inventory that has the item (if not found in self)
function craft_slave.find(item_name)
	local inventorySize = robot.inventorySize()
	for index = 1, inventorySize do
		if not (index == 1 or index == 2 or index == 3 or index == 5 or index == 6 or index == 7 or index == 9 or index == 10 or index == 11) then
			local stack = inventory_controller.getStackInInternalSlot(index)
			if not (stack == nil) then
				if stack.name == item_name then
					return "internal", index
				end
			end
		end
	end
	for _, side in pairs(inputSides) do
		local noerror, size = pcall(function () return inventory_controller.getInventorySize(sideEnum.front) end)
		if noerror and not (size == nil) then
			for index = 1, size do
				local stack = inventory_controller.getStackInSlot(sideEnum.front, index)
				if not (stack == nil) then
					if stack.name == item_name then
						return side, index
					end
				end
			end
		end
		robot.turnRight()
	end
	-- the robot has put itself back to place
	-- but no item found  :c
	return nil, nil
end

function craft_slave.count(item_name)
	local inventorySize = robot.inventorySize()
	local count = 0
	for index = 1, inventorySize do
		if not (index == 1 or index == 2 or index == 3 or index == 5 or index == 6 or index == 7 or index == 9 or index == 10 or index == 11) then
			local stack = inventory_controller.getStackInInternalSlot(index)
			if not (stack == nil) then
				if stack.name == item_name then
					count = count+stack.size
				end
			end
		end
	end
	for _, side in pairs(inputSides) do
		local noerror, size = pcall(function () return inventory_controller.getInventorySize(sideEnum.front) end)
		if noerror and not (size == nil) then
			for index = 1, size do
				local stack = inventory_controller.getStackInSlot(sideEnum.front, index)
				if not (stack == nil) then
					if stack.name == item_name then
						count = count+stack.size
					end
				end
			end
		end
		robot.turnRight()
	end
	-- the robot has put itself back to place
	return count
end

function craft_slave.abortCraft()
	craft_slave.should_abort_craft = true
end

-- Searches and puts (if found) the given item at the given position
-- Returns "Item not found" if the item wasn't found
function craft_slave.put(item_name, position)
	robot.select(position)
	local side, index = craft_slave.find(item_name)
	if side == nil then
		print("Item not found")
		craft_slave.abortCraft()
		return "Item not found"
	end
	print("found item, transferring")
	if side == "internal" then
		robot.select(index)
		robot.transferTo(position)
	else
		robot.select(position)
		local result = inventory_controller.suckFromSlot(sideEnum.front, index, 1)
		if not result then
			print("Slot occupied, aborting")
			craft_slave.abortCraft()
		end
	end
end

-- Performs the craft
-- 'outputPosition' must be -1 if you want to directly output the result to the output slot
-- Otherwise, put the index to which the result must be moved
-- Returns the result from 'craft' of the crafting component
function craft_slave.performCraft(outputPosition, craftAmount)
	robot.select(1)
	local result = craft.craft(craftAmount)
	if result then
		print("Crafting was successful!")
		if not(outputPosition == -1) then
			robot.transferTo(outputPosition)
		else
			inventory_controller.dropIntoSlot(outputSide, craftAmount)
		end
	end
	return result
end

return craft_slave