local SceneManager = require "scene_manager"
local BusStopScene = require "bus_stop_scene"
local Text = require "text"

local BusScene = {}

local bus_stop_width, bus_stop_height = 1000, 1000
local bus_stop_duration = 3

local BusStopScene
local function get_bus_stop_scene()
   if not BusStopScene then
      BusStopScene = require "bus_stop_scene"
   end
   return BusStopScene
end

function BusScene.create(bus, map)
   local bus_scene = {
      bus = bus,
      map = map,
      bus_stop_object = {
         x = -bus_stop_width,
         y = 0,
         active = false,
      },
   }
   setmetatable(bus_scene, {__index = BusScene})
   return bus_scene
end

function BusScene:update(dt) 
   -- TODO: maybe add stopping for the bus stops?
   if self.bus_stop_object.active then
      self.bus_stop_object.x = self.bus_stop_object.x +
                          dt*(love.graphics.getWidth()/bus_stop_duration)
   end
end

function BusScene:check_time_advance()
   if self.bus_stop_object.active then
      if self.bus_stop_object.x >= love.graphics.getWidth() then
         self.bus_stop_object.active = false
         return true
      else
         return false
      end
   elseif self.bus.stop then
      self.bus_stop_object.x = -bus_stop_width
      self.bus_stop_object.active = true
      return false
   end
   return true
end

function BusScene:draw()
   -- TODO: this is an eye sore
   if self.bus.stop then
      love.graphics.setColor(0.1, 0.5, 0.17)
      love.graphics.rectangle("fill", self.bus_stop_object.x, self.bus_stop_object.y, 
                              bus_stop_width, bus_stop_height)
      love.graphics.setColor(0, 0, 0)
      love.graphics.setFont(Text.get_font("Kingbus.ttf", 40))
      Text.draw_centered_text("stop "..tostring(self.bus.stop), 
                              self.bus_stop_object.x, self.bus_stop_object.y, 
                              bus_stop_width, bus_stop_height)
   end
   love.graphics.setColor(0, 0, 1)
   love.graphics.print(tostring("on bus: "..self.bus.name), 0, 0)
end

function BusScene:mousepressed(x, y, button, istouch, presses)
   if self.bus then
      local rel_x = x - self.bus_stop_object.x
      local rel_y = y - self.bus_stop_object.y
      if rel_x > 0 and rel_x < bus_stop_width and
         rel_y > 0 and rel_y < bus_stop_height then
         SceneManager.set_scene(get_bus_stop_scene().create(self.bus.stop, self.map))
         self.bus.stop = nil
      end
   end
end

function BusScene:mousemoved(x, y, dx, dy, istouch)
end

return BusScene

