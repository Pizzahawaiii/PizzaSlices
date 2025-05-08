PizzaSlices:RegisterModule('channel', function ()
  PS.channelName = 'LFT'

  PS.channelJoinDelay = CreateFrame('Frame', 'PizzaSlicesChannelJoinDelay', UIParent)
  PS.channelJoinDelay:Hide()

  PS.channelJoinDelay:SetScript('OnShow', function ()
    this.startTime = GetTime()
  end)
  PS.channelJoinDelay:Show()

  PS.channelJoinDelay:SetScript('OnHide', function ()
    local isInChannel = false
    local channels = { GetChannelList() }

    for _, channel in next, channels do
      if channel == PS.channelName then
        isInChannel = true
        break
      end
    end

    if not isInChannel then
      JoinChannelByName(PWB.channelName)
    end

    -- Share our addon version once
    local channelIdx = GetChannelName(PS.channelName)
    if channelIdx > 0 then
      SendChatMessage(PS:GetName() .. ':' .. PS.utils.getVersionNumber(), 'CHANNEL', nil, channelIdx)
    end
  end)

  PS.channelJoinDelay:SetScript('OnUpdate', function ()
    local delay = 15
    local gt = GetTime() * 1000
    local st = (this.startTime + delay) * 1000
    if gt >= st then
      PS.channelJoinDelay:Hide()
    end
  end)
end)
