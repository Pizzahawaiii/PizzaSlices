PizzaSlices:RegisterModule('commands', function ()
  _G.SLASH_PIZZASLICES1 = '/ps'
  _G.SLASH_PIZZASLICES2 = '/slices'
  _G.SLASH_PIZZASLICES3 = '/pizzaslices'

  SlashCmdList['PIZZASLICES'] = function (args)
    PS.settings:Show()
  end
end)
