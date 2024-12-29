local SceneManager = {}

local _scene

function SceneManager.set_scene(scene)
   _scene = scene
end

function SceneManager.get_scene()
   return _scene
end

return SceneManager
