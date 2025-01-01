local util = require "util"

local NameGenerator = {}
local stop_name_first = {
   "new",
   "white", "black", "red", "green", "yellow",
   "ball", "stick",
   "miniscule", "little", "big", "huge", "giant",
   "olive", "crow",
   "copper", "iron", "gold",
   "two", "three", "four", "five", "six",
   "1. ", "2. ", "3. ", "4. ",
   "cherry",
   "john",
   "merry",
   "harry",
   "river",
   "paper",
   "fabric",
   "eye",
   "sun", "moon", "day", "night",
   "flower", "rose",
   "circle",
   "rude",
   "torch",
   "cute",
   "arrow",
   "chained",
   "short", "long",
}
local stop_name_second = {
   "gardens",
   "town", "city", "village",
   "door",
   "drawer",
   "bridge",
   "factory",
   "market",
   "school",
   "houses",
   "nose",
   "faces",
   "mountain", "hills", "forest", "rocks",
   "farm", "cows", "sheeps", "chics",
   "mines",
   "trials",
   "trenches",
   "porch",
   "road", "ways", "street",
}

function NameGenerator.generate_stop_names(stop_arr)
   local city_names = {}
   local city_cnt = 0
   while city_cnt < #stop_arr do
      local choice = love.math.random(1, #stop_name_second*#stop_name_first)
      if not city_names[choice] then
         city_names[choice] = true
         city_cnt = city_cnt + 1
      end
   end

   local ret = {}
   for i, _ in pairs(city_names) do
      if i <= #stop_name_second then
         table.insert(ret, stop_name_second[i])
      else
         table.insert(ret, stop_name_first[math.floor(i/#stop_name_second)]..
                           stop_name_second[i%#stop_name_second+1])
      end
   end
   util.shuffle(ret)
   for i, name in ipairs(ret) do
      stop_arr[i].name = name
   end
end

function NameGenerator.generate_bus_names(stop_names, bus_arr)
   local name_cnt = {}
   for _, bus in ipairs(bus_arr) do
      local name = string.sub(stop_names[bus.path[1]], 1, 1)
      name = name..string.sub(stop_names[bus.path[#bus.path]], 1, 1)
      if name_cnt[name] then
         name_cnt[name] = name_cnt[name] + 1
      else
         name_cnt[name] = 1
      end
   end
   for _, bus in ipairs(bus_arr) do
      local name = string.sub(stop_names[bus.path[1]], 1, 1)
      name = name..string.sub(stop_names[bus.path[#bus.path]], 1, 1)
      name = string.upper(name)
      if name_cnt[name] > 1 then
         bus.name = name..tostring(name_cnt[name])
         name_cnt[name] = name_cnt[name] - 1
      else
         bus.name = name
      end
   end
end

return NameGenerator
