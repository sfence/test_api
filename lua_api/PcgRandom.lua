test_api.PcgRandom = {}

function PcgRandom(seed, sequence)
  return test_api.PcgRandom:new(seed, sequence)
end

function test_api.PcgRandom:new(seed, sequence)
  local new_object = {}
  setmetatable(new_object, {__index = self})
  new_object.seed = seed
  new_object.sequence = sequence
  return new_object
end

function test_api.PcgRandom:next(min, max)
  min = min or -2147483648
  max = max or 2147483647
  
  return math.random(min, max)
end

function test_api.PcgRandom:rand_normal_dist(min, max, num_trials)
  num_trials = num_trials or 6
  local accum = 0
  
  for i=0,i<num_trials,1 do
    accum = accum + self:next(min, max)
  end
  
  return accum/num_trials
end

