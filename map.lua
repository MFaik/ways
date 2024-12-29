local Map = {}

function Map.create()
   -- TODO: add map generation
   local map = {}
   map.bus_manager = require("bus_manager").create(map),
   setmetatable(map, {__index = Map})
   return map
end

function Map:advance_time()
   self.bus_manager:advance_time()
end

function Map:add_bus(start, target)
   -- TODO: add path finding
   local path = {}
   for i = start, target do
      table.insert(path, i)
   end
   self.bus_manager:add_bus(path, tostring(start).."->"..tostring(target))
end

function Map:get_bus_arr()
   return self.bus_manager:get_bus_arr()
end

function Map:get_traffic()
   -- TODO: add traffic
   return 2
end

return Map
