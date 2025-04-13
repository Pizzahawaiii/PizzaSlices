local defaultConfig = {
  scale = 1,
  openAtCursor = true,
  animationDuration = 1,
  triggerOnClick = false,
  toggleAnchor = false,
  anchorX = 0,
  anchorY = 100
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