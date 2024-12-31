local MapGenerator = require "map_generator"

local Map = {}

function Map.create()
   -- TODO: add virtual map generation for bus traffic
   local map = {
      pmap = MapGenerator.generate_map(400, 400)
   }
   map.bus_manager = require("bus_manager").create(map),
   setmetatable(map, {__index = Map})
   return map
end

function Map:draw_map()
   -- TODO: actually add proper map ui
   love.graphics.setColor(1, 1, 1)
   for _, road in ipairs(self.pmap.roads) do
      local p1 = self.pmap.bus_stops[road[1]]
      local p2 = self.pmap.bus_stops[road[2]]
      love.graphics.line(p1.x, p1.y, p2.x, p2.y)
   end
   for _, stop in ipairs(self.pmap.bus_stops) do
      love.graphics.circle("fill", stop.x, stop.y, 2)
   end
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
