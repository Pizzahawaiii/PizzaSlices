local defaultConfig = {
  scale = 1,
  openAtCursor = true,
  animationDuration = 1,
  triggerOnClick = false, -- New setting for mouse click triggering
}

function PizzaSlices:LoadConfig()
  if not PizzaSlices_config then
    PizzaSlices_config = defaultConfig
    return
  end

  for key, defaultValue in pairs(defaultConfig) do
    if PizzaSlices_config[key] == nil then
      PizzaSlices_config[key] = defaultValue
    end
  end
end