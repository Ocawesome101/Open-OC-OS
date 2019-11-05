-- Standard IO: print(), error(), and io.error() --

_G.io = {}

io.__panic = error
io.__cy = 1
io.__cx = 1

local w,h = gpu.getResolution()

io.getlines = function(str)
  local lines = {}
  for i=1, string.len(str)/w, w do
    table.insert(lines,str:sub(i,(i+w or len)))
  end
  return lines
end

local last_sleep = os.uptime()
__screen.update = function()end
_G.print = function(str) -- Very similar to os.status()
  if gpu then
    gpu.set(io.__cx, io.__cy, str)
    __screen.update()
    if y == h then
      gpu.copy(1, 2, w, h - 1, 0, -1)
      gpu.fill(1, h, w, 1, " ")
    else
      io.__cy = io.__cy + 1
    end
    io.__cx = 1
  end

  if os.uptime() - last_sleep > 1 then
    local signal = table.pack(os.pullSignal(0))
    -- there might not be any signal
    if signal.n > 0 then
      -- push the signal back in queue for the system to use it
      os.pushSignal(table.unpack(signal, 1, signal.n))
    end
    last_sleep = os.uptime()
  end
end

io.error = function(error,type)
  if type == "panic" then
    io.__panic(error)
  elseif type == "warn" then
    print("WARN: " .. error)
  elseif type == nil or type == "standard" then
    print("ERROR: " .. error)
  end
end

_G.error = io.error
