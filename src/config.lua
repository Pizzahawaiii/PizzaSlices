local defaultConfig = {
  scale = 1,
  openAtCursor = true,
  animation = {
    duration = 1,
    rotateOnClose = 1,
  },
  showMacroNames = false,
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

    if type(PizzaSlices_config[key]) == 'table' then
      for k, d in pairs(defaultValue) do
        if PizzaSlices_config[key][k] == nil then
          PizzaSlices_config[key][k] = d
        end
      end
    end
  end
end
