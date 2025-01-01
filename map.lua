local MapGenerator = require "map_generator"
local NameGenerator = require "name_generator"
local Text = require "text"

local Map = {}

function Map.create()
   -- TODO: add virtual map generation for bus traffic
   local map = MapGenerator.generate_map(600, 600)
   NameGenerator.generate_stop_names(map.bus_stops)
   map.bus_manager = require("bus_manager").create(map),
   setmetatable(map, {__index = Map})
   return map
end

function Map:draw_map()
   -- TODO: actually add proper map ui
   love.graphics.setColor(1, 1, 1)
   for _, road in ipairs(self.roads) do
      local p1 = self.bus_stops[road[1]]
      local p2 = self.bus_stops[road[2]]
      love.graphics.line(p1.x, p1.y, p2.x, p2.y)
   end
   for _, stop in ipairs(self.bus_stops) do
      love.graphics.circle("fill", stop.x, stop.y, 2)
   end
   -- print names
   local font = Text.get_font("Comfortaa-Bold", 12)
   Text.set_font("Comfortaa-Bold", 12)
   for _, stop in ipairs(self.bus_stops) do
      love.graphics.setColor(0, 0, 0, 0.4)
      local text_width, text_height = font:getWidth(stop.name), font:getHeight()
      love.graphics.rectangle("fill", stop.x - 2, stop.y - 2,
                              text_width + 4, text_height + 4)
      love.graphics.setColor(1, 1, 1)
      love.graphics.print(stop.name, stop.x, stop.y)
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
