require "global_test"

local screen_width, screen_height = 1000, 1000

local lume = require "lume"

-- scenes
local BusStopScene = require "bus_stop_scene"
local SceneManager = require "scene_manager"

local Map = require "map"
local map

local timer = 0
local time_advance_delay = 1

local function advance_time()
   map:advance_time()
   print("advanced time")
end

function love.load()
   -- love.math.setRandomSeed(31)
   love.window.setMode(screen_width, screen_height)

   map = Map.create()
   -- test buses and bus stop
   map:add_bus(1, 5)
   map:add_bus(3, 5)

   SceneManager.set_scene(BusStopScene.create(3, map))
   -- end test
   -- SceneManager.set_scene(BusStopScene.create(map:start_stop, map))
end

function love.update(dt)
   SceneManager.get_scene():update(dt)

   if timer < time_advance_delay then
      timer = timer + dt
   else 
      if SceneManager.get_scene():check_time_advance() then
         advance_time()
         timer = 0
      end
   end
end

function love.draw()
   SceneManager.get_scene():draw()
end

function love.mousepressed(x, y, button, istouch, presses)
   SceneManager.get_scene():mousepressed(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
   -- SceneManager.get_scene():mousemoved(x, y, dx, dy, istouch)
end

function love.keypressed(key)
end
