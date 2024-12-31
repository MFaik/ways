local util = require "util"

local MapGenerator = {}

local bus_stop_cnt = 75
local max_try = 1000
local max_edge_len = 0.2
local max_degree = math.pi/2
local max_branch = 3
local merge_distance = 0.05
local min_point_line_distance = 0.13
local connection_try_cnt = 200

function MapGenerator.generate_map(width, height)
   local points = {{x = 0, y = 0}}
   local edges = {}

   local function is_edge_valid(edge) 
      local p1, p2
      if type(edge[1]) == "table" then p1 = edge[1] else p1 = points[edge[1]] end
      if type(edge[2]) == "table" then p2 = edge[2] else p2 = points[edge[2]] end

      for _, other in ipairs(edges) do
         -- check equality
         if edge[1] == other[1] and edge[2] == other[2] then
            return false
         end
         if edge[2] == other[1] and edge[1] == other[2] then
            return false
         end
         if util.is_intersection(p1, p2, points[other[1]], points[other[2]]) then
            return false
         end
      end
      return true
   end

   local dfs = {
      { point = 1, branch_cnt = 1 },
      { point = 1, branch_cnt = 2 },
      { point = 1, branch_cnt = 3 },
      { point = 1, branch_cnt = 4 },
   }
   local try_counter = 0
   while #points < bus_stop_cnt do
      if #dfs == 0 then
         table.insert(dfs, {point = love.math.random(1, #points), branch_cnt = 4})
         try_counter = try_counter + 1
         if try_counter > max_try then break end
      end
      local curr_point = points[dfs[1].point]
      local center_dis = util.point_distance(curr_point, {x = 0, y = 0})
      if center_dis < 1 then
         local angle
         if center_dis ~= 0 then
            angle = math.pow(love.math.random(), center_dis)*max_degree
            if love.math.random() > 0.5 then angle = -angle end
            angle = angle + math.atan2(curr_point.y, curr_point.x)
            angle = angle*dfs[1].branch_cnt
         else
            angle = love.math.random()*math.pi*2
         end

         local dis = math.pow(love.math.random(), 1-center_dis)*max_edge_len

         local branch = math.pow(love.math.random(), center_dis)*max_branch
         branch = math.floor(branch)

         local point = {x = dis*math.cos(angle)+curr_point.x, 
                        y = dis*math.sin(angle)+curr_point.y}
         -- Merge Check
         local will_merge = nil
         for i, other in ipairs(points) do
            if util.point_distance(other, point) < merge_distance then
               will_merge = i
               break
            end
         end
         if will_merge then
            local edge = {dfs[1].point, will_merge}
            if is_edge_valid(edge) then
               table.insert(edges, edge)
            end
         else
            -- Proximity Check
            local can_place = true
            for i, edge in ipairs(edges) do
               if util.line_distance(point, points[edge[1]], points[edge[2]]) < min_point_line_distance then
                  can_place = false
                  break
               end
            end
            if is_edge_valid({dfs[1].point, point}) and can_place then
               table.insert(points, point)
               table.insert(edges, {dfs[1].point, #points})
               for i = 1, branch do
                  table.insert(dfs, {point = #points, branch_cnt = i})
               end
            end
         end
      end
      table.remove(dfs, 1)
   end
   -- try to add connections
   for i = 1, connection_try_cnt do
      local p1 = love.math.random(1, #points)
      local p2 = love.math.random(1, #points)
      if p2 < p1 then
         p1, p2 = p2, p1
      elseif p1 ~= p2 then
         if util.point_distance(points[p1], points[p2]) < max_edge_len and
            is_edge_valid({p1, p2}) then
            table.insert(edges, {p1, p2})
         end
      end
   end
   -- normalize
   local left, right, up, down = points[1].x, points[1].x, points[1].y, points[1].y
   for _, point in ipairs(points) do
      if point.x > left then left = point.x end
      if point.x < right then right = point.x end
      if point.y < up then up = point.y end
      if point.y > down then down = point.y end
   end
   for _, point in ipairs(points) do
      point.old_x, point.old_y = point.x, point.y
      point.x = (point.x-left)/(right-left)
      point.y = (point.y-up)/(down-up)
      point.x = point.x*width
      point.y = point.y*height
   end
   return { bus_stops = points, roads = edges }
end

return MapGenerator
