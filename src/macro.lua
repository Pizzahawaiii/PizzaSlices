PizzaSlices:RegisterModule('macro', function ()
  PS.macro = {}

  local function getBody(name)
    local id = GetMacroIndexByName(name)
    if not id then return end
    local _, _, body = GetMacroInfo(id)
    return body
  end

  function PS.macro.run(name)
    local body = getBody(name)
    if not body then return end
    local lines = PS.utils.strSplit(body, '\n', true)
    for _, line in pairs(lines) do
      ChatFrameEditBox:SetText(line)
      ChatEdit_SendText(ChatFrameEditBox)
    end
  end

  function PS.macro.getRunMacro()
    local runMacro
    if not runMacro and CleveRoids then runMacro = CleveRoids.ExecuteMacroByName end
    if not runMacro and Roids then runMacro = Roids.ExecuteMacroByName end
    if not runMacro and RunMacro then runMacro = RunMacro end
    if not runMacro then runMacro = PS.macro.run end
    return runMacro
  end

  function PS.macro.opensRing(macroName, ringIdx)
    local body = getBody(macroName)
    if not body then return false end
    local lines = PS.utils.strSplit(body, '\n', true)
    for _, line in pairs(lines) do
      if line == ('/ps open ' .. ringIdx) or line == ('/slices open ' .. ringIdx) or line == ('/pizzaslices open ' .. ringIdx) then
        return true
      end
    end
    return false
  end
end)
