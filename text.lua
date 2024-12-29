local Text = {}

function Text.draw_centered_text(text, rectX, rectY, rectWidth, rectHeight)
   local font = love.graphics.getFont()
	local textWidth = font:getWidth(text)
	local textHeight = font:getHeight()
	love.graphics.print(text, rectX+rectWidth/2, rectY+rectHeight/2, 0, 1, 1, textWidth/2, textHeight/2)
end

function Text.get_font(font_name, size)
   if Text[font_name..tostring(size)] then
      return Text[font_name..tostring(size)]
   else
      local font = love.graphics.newFont("assets/"..font_name, size)
      Text[font_name..tostring(size)] = font
      return font
   end
end

return Text
