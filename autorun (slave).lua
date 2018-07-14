local fs = require("filesystem")
local proxy = ...
fs.mount(proxy, "/auto_craft_slave")
os.execute("cd /auto_craft_slave/auto_craft && slave/slave")