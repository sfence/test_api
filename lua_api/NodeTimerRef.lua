
test_api.NodeTimerRef = {}

-- new is extra added method by test_api
function test_api.NodeTimerRef:new(node_pos, timer)
  local new_timer = {node_pos = node_pos, timer = timer}
  setmetatable(new_timer, {__index = self})
  return new_timer
end

function test_api.NodeTimerRef:set(timeout, elapsed)
  self.timer.timeout_time = timeout
  self.timer.elapsed_time = elapsed
end
function test_api.NodeTimerRef:start(timeout)
  self:set(timeout,0)
end
function test_api.NodeTimerRef:stop()
  self:set(0,0)
end
function test_api.NodeTimerRef:get_timeout()
  return self.timer.timeout_time
end
function test_api.NodeTimerRef:get_elapsed()
  return self.timer.elapsed_time
end
function test_api.NodeTimerRef:is_started()
  return self.timer.timeout_time ~= 0
end
