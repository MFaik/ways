local util = {}

function util.point_distance(a, b)
   return math.sqrt(((a.x-b.x)*(a.x-b.x)) + ((a.y-b.y)*(a.y-b.y)))
end

function util.line_distance(p, l1, l2)
   local dx, dy = p.x - l1.x, p.y - l1.y
   local seg_dx, seg_dy = l2.x - l1.x, l2.y - l1.y
   local seg_length_sq = seg_dx * seg_dx + seg_dy * seg_dy
   if seg_length_sq == 0 then
      return math.sqrt(dx * dx + dy * dy)
   end
   local t = (dx * seg_dx + dy * seg_dy) / seg_length_sq
   t = math.max(0, math.min(1, t))
   local closest_x, closest_y = l1.x + t * seg_dx, l1.y + t * seg_dy
   local dist_dx = p.x - closest_x
   local dist_dy = p.y - closest_y
   return math.sqrt(dist_dx * dist_dx + dist_dy * dist_dy)
end
function util.is_intersection(p1, q1, p2, q2)
   local function cross_product(p, q, r)
      return (q.x - p.x) * (r.y - p.y) - (q.y - p.y) * (r.x - p.x)
   end

   -- Check if two line segments intersect
   local d1 = cross_product(p1, q1, p2)
   local d2 = cross_product(p1, q1, q2)
   local d3 = cross_product(p2, q2, p1)
   local d4 = cross_product(p2, q2, q1)

   -- General case: segments intersect if directions differ
   if (d1 * d2 < 0) and (d3 * d4 < 0) then
      return true
   end

   return false
end

return util
