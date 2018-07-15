function craft(craft_manager, outputPos)
	local insulated_cable_count = craft_manager.count("Insulated Copper Cable")
	if(insulated_cable_count < 6) then
		local cable_count = craft_manager.count("Copper Cable")
		local rubber_count = craft_manager.count("Rubber")
		if cable_count < 6 then
			craft_manager.fail("Missing copper cables (requires at least 6, only has "..cable_count..")")
			return false
		end
		if rubber_count < 6 then
			craft_manager.fail("Missing rubber (requires at least 6, only has "..rubber_count..")")
			return false
		end
		print("Not enough insulated cables, crafting some")
		craft_manager.craft("insulated_copper_cable", 4)
		craft_manager.craft("insulated_copper_cable", 8)
		craft_manager.craft("insulated_copper_cable", 12)
		craft_manager.craft("insulated_copper_cable", 13)
		craft_manager.craft("insulated_copper_cable", 14)
		craft_manager.craft("insulated_copper_cable", 15)
	end
	local plate_count = craft_manager.count("Iron Plate")
	local redstone_count = craft_manager.count("minecraft:redstone")
	if plate_count < 1 then
		craft_manager.fail("Missing plate (requires at least 1, only has "..plate_count..")")
		return false
	end
	if redstone_count < 2 then
		craft_manager.fail("Missing redstone (requires at least 2, only has "..redstone_count..")")
		return false
	end
	craft_manager.begin_craft()
	craft_manager.put("Insulated Copper Cable", 1)
	craft_manager.put("Insulated Copper Cable", 2)
	craft_manager.put("Insulated Copper Cable", 3)
	craft_manager.put("Insulated Copper Cable", 9)
	craft_manager.put("Insulated Copper Cable", 10)
	craft_manager.put("Insulated Copper Cable", 11)
	craft_manager.put("minecraft:redstone", 5)
	craft_manager.put("minecraft:redstone", 7)
	craft_manager.put("Iron Plate", 6)
	craft_manager.perform_craft(outputPos, 1)
	craft_manager.end_craft()
	return true
end

return craft