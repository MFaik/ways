local BusManager = {}

function BusManager.create(map)
   local bus_manager = {
      bus_array = {},
      map = map,
   }
   setmetatable(bus_manager, {__index = BusManager})
   return bus_manager
end

function BusManager:add_bus(path, name)
   local bus = {
      path = path,
      stop = path[1],
      destination_ptr = 2,
      progress = 0,
      name = name,
   }
   table.insert(self.bus_array, bus)
end

function BusManager:advance_time()
   local will_remove = {}
   for i, bus in ipairs(self.bus_array) do
      if bus.stop then
         bus.stop = nil
      end
      local traffic = self.map:get_traffic(bus.path[bus.destination_ptr-1],
                                           bus.path[bus.destination_ptr])
      bus.progress = bus.progress + 1/traffic
      if bus.progress >= 1 then
         bus.progress = 0
         if bus.destination_ptr > #bus.path then
            table.insert(will_remove, i)
         else
            bus.stop = bus.path[bus.destination_ptr]
            bus.destination_ptr = bus.destination_ptr + 1
         end
      end
   end
   for _, i in ipairs(will_remove) do
      table.remove(self.bus_array, i)
   end
end

function BusManager:get_bus_arr()
   return self.bus_array
end

return BusManager
