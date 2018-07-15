function craft(craft_manager, outputPos)
	local count = craft_manager.count("minecraft:cobblestone")
	if count < 8 then
		craft_manager.fail("Missing cobblestone (requires at least 8, only has "..count..")")
		return false
	end
	craft_manager.begin_craft()
	craft_manager.put("minecraft:cobblestone", 1)
	craft_manager.put("minecraft:cobblestone", 2)
	craft_manager.put("minecraft:cobblestone", 3)
	craft_manager.put("minecraft:cobblestone", 5)
	craft_manager.put("minecraft:cobblestone", 7)
	craft_manager.put("minecraft:cobblestone", 9)
	craft_manager.put("minecraft:cobblestone", 10)
	craft_manager.put("minecraft:cobblestone", 11)
	craft_manager.perform_craft(outputPos, 1)
	craft_manager.end_craft()
	return true
end

return craft