_G.graphics = {}

local w,h = gpu.getResolution()

graphics.clear = function()
    gpu.set(1,1,w,h,' ')
end
