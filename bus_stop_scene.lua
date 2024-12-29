local SceneManager = require "scene_manager"
local Text = require "text"

local BusStopScene = {}

local bus_width, bus_height = 400, 200
local bus_catch_duration = 3

local BusScene
local function get_bus_scene()
   if not BusScene then
      BusScene = require "bus_scene"
   end
   return BusScene
end

function BusStopScene.create(stop, map)
   local bus_stop_scene = {
      stop = stop, 
      map = map, 
      bus = nil,
      bus_object = {
         x = -bus_width,
         y = 200,
      },
   }
   setmetatable(bus_stop_scene, {__index = BusStopScene})
   return bus_stop_scene
end

function BusStopScene:update(dt) 
   if self.bus then
      self.bus_object.x = self.bus_object.x + 
                          dt*(love.graphics.getWidth()/bus_catch_duration)
   end
end

function BusStopScene:check_time_advance()
   if self.bus then
      if self.bus_object.x >= love.graphics.getWidth() then
         self.bus = nil
         return true
      else
         return false
      end
   end
   for _, bus in ipairs(self.map:get_bus_arr()) do
      if bus.stop == self.stop then
         self.bus = bus
         self.bus_object.x = -bus_width
         return false
      end
   end
   return true
end

function BusStopScene:draw()
   -- TODO: this is an eye sore
   if self.bus then
      love.graphics.setColor(0.4, 0.2, 0.2)
      love.graphics.rectangle("fill", self.bus_object.x, self.bus_object.y, 
                              bus_width, bus_height)
      love.graphics.setColor(0, 0, 0)
      love.graphics.setFont(Text.get_font("Kingbus.ttf", 40))
      Text.draw_centered_text(self.bus.name, self.bus_object.x, self.bus_object.y, 
                         bus_width, bus_height)
   end
   love.graphics.setColor(0, 0, 1)
   love.graphics.print("on bus stop: "..tostring(self.stop), 0, 0)
end

function BusStopScene:mousepressed(x, y, button, istouch, presses)
   if self.bus then
      local rel_x = x - self.bus_object.x
      local rel_y = y - self.bus_object.y
      if rel_x > 0 and rel_x < bus_width and
         rel_y > 0 and rel_y < bus_height then
         self.bus.stop = nil
         SceneManager.set_scene(get_bus_scene().create(self.bus, self.map))
      end
   end
end

function BusStopScene:mousemoved(x, y, dx, dy, istouch)
   -- TODO: add highlight to objects that are under the mouse
end

return BusStopScene
