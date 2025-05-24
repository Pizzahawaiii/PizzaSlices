PizzaSlices:RegisterModule('commands', function ()
  _G.SLASH_PIZZASLICES1 = '/ps'
  _G.SLASH_PIZZASLICES2 = '/slices'
  _G.SLASH_PIZZASLICES3 = '/pizzaslices'

  SlashCmdList['PIZZASLICES'] = function (args, x)
    local cmd, msg = PS.utils.strSplit(args, ' ')
    local command = cmd and string.lower(cmd)

    if command == 'open' then
      local ringIdx = tonumber(msg)
      local ringCount = PS.utils.length(PizzaSlices_rings)

      if not ringIdx or ringIdx < 1 or ringIdx > ringCount then
        PS:Print((msg or 'nil') .. ' is not a valid ring index. try a number between 1 and ' .. ringCount)
        return
      end

      PS:Open(ringIdx, true)
      return
    end

    PS.settings:Show()
  end
end)
