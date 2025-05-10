PizzaSlices:RegisterModule('scanner', function ()
  PS.scanner = {}

  local scanner = CreateFrame('GameTooltip', 'PizzaSlicesTooltipScanner', nil, 'GameTooltipTemplate')
  scanner:SetOwner(WorldFrame, 'ANCHOR_NONE')
  scanner:SetScript('OnHide', function ()
    this:SetOwner(WorldFrame, 'ANCHOR_NONE')
  end)

  function scanner:GetLineText(line)
    local name = scanner:GetName()
    local l = _G[string.format('%sTextLeft%d', name, line)]
    local r = _G[string.format('%sTextRight%d', name, line)]
    l = l and l:IsVisible() and l:GetText()
    r = r and r:IsVisible() and r:GetText()

    if l or r then
      return l, r
    end
  end

  function PS.scanner.isUsableItem(itemId)
    scanner:ClearLines()
    scanner:SetHyperlink('item:' .. itemId)
    for line = 1, scanner:NumLines() do
      local text = scanner:GetLineText(line)
      if string.sub(text, 1, 5) == 'Use: ' then
        return true
      end
    end
    return false
  end
end)
