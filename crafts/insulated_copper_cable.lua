function craft(craft_manager, outputPos)
	local cable_count = craft_manager.count("Copper Cable")
	local rubber_count = craft_manager.count("Rubber")
	if cable_count < 1 then
		craft_manager.fail("Missing copper cables (requires at least 1, only has "..cable_count..")")
		return false
	end
	if rubber_count < 1 then
		craft_manager.fail("Missing rubber (requires at least 1, only has "..rubber_count..")")
		return false
	end
	craft_manager.begin_craft()
	craft_manager.put("Copper Cable", 1)
	craft_manager.put("Rubber", 2)
	craft_manager.perform_craft(outputPos, 1)
	craft_manager.end_craft()
end

return craft