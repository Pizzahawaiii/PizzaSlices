local defaultConfig = {
  scale = 1,
  openAtCursor = true,
  animationDuration = 1,
}

function PizzaSlices:LoadConfig()
  if not PizzaSlices_config then
    PizzaSlices_config = defaultConfig
    return
  end

  for key, defaultValue in pairs(defaultConfig) do
    local v = PizzaSlices_config[key]
    if v == nil then
      v = defaultValue
    end

    if type(v) == 'table' then
      for k, d in pairs(defaultValue) do
        if v[k] == nil then
          v[k] = d
        end
      end
    end
  end
end
