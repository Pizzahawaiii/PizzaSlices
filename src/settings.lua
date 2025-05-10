PizzaSlices:RegisterModule('settings', function ()
  PS.settings = CreateFrame('Frame', 'PizzaSlicesSettings', UIParent)

  local f = PS.settings
  local c = { r = .376, g = .188, b = .6 }
  local r = { r = 1, g = .275, b = .180 }
  local g = { r = 0, g = 1, b = .596 }
  local b = { r = 0, g = .596, b = 1 }
  local backdrop = {
    bgFile = "Interface\\BUTTONS\\WHITE8X8", tile = false, tileSize = 0,
    edgeFile = "Interface\\BUTTONS\\WHITE8X8", edgeSize = 1,
    insets = {left = -1, right = -1, top = -1, bottom = -1},
  }
  local sliderBackdrop = {
    bgFile = "Interface\\Buttons\\UI-SliderBar-Background", tile = true, tileSize = 8,
    edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", edgeSize = 8,
    insets = {left = 3, right = 3, top = 6, bottom = 6},
  }

  local modifiers = {
    ["ALT"]   = "ALT-",
    ["CTRL"]  = "CTRL-",
    ["SHIFT"] = "SHIFT-"
  }

  local mouseButtonMap = {
    ["LeftButton"]   = "BUTTON1",
    ["RightButton"]  = "BUTTON2",
    ["MiddleButton"] = "BUTTON3",
    ["Button4"]      = "BUTTON4",
    ["Button5"]      = "BUTTON5",
  }

  local blockedKeys = {
    "LeftButton",
    "RightButton",
  }

  -----------------------------------------------------------------------------
  -- MAIN FRAME
  -----------------------------------------------------------------------------
  
  f:Hide()
  f:SetPoint('CENTER', 0, 0)
  f:SetFrameStrata('DIALOG')
  f:SetWidth(800)
  f:SetHeight(600)
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag('LeftButton')
  f:SetScript('OnDragStart', function () f:StartMoving() end)
  f:SetScript('OnDragStop', function () f:StopMovingOrSizing() end)
  f:SetBackdrop(backdrop)
  f:SetBackdropColor(0, 0, 0, .8)
  f:SetBackdropBorderColor(1, 1, 1, 0)

  table.insert(UISpecialFrames, f:GetName())

  -----------------------------------------------------------------------------
  -- CLOSE BUTTON
  -----------------------------------------------------------------------------

  f.close = CreateFrame('Button', f:GetName() .. 'Close', f, 'UIPanelButtonTemplate')
  f.close:SetBackdrop(backdrop)
  f.close:SetBackdropColor(r.r, r.g, r.b, 0)
  f.close:SetBackdropBorderColor(r.r, r.g, r.b, .7)
  f.close:SetNormalTexture('')
  f.close:SetHighlightTexture('')
  f.close:SetPushedTexture('')
  f.close:SetDisabledTexture('')
  f.close:SetWidth(16)
  f.close:SetHeight(16)
  f.close:SetPoint('TOPRIGHT', -10, -10)
  f.close.tex = f.close:CreateTexture(f.close:GetName() .. 'Tex', 'ARTWORK')
  f.close.tex:SetWidth(12)
  f.close.tex:SetHeight(12)
  f.close.tex:SetPoint('CENTER', 0, 0)
  f.close.tex:SetTexture('Interface\\AddOns\\PizzaSlices\\img\\close')
  f.close.tex:SetVertexColor(r.r, r.g, r.b, .7)
  f.close:SetScript('OnMouseDown', function ()
    this:SetBackdropColor(r.r, r.g, r.b, .5)
  end)
  f.close:SetScript('OnMouseUp', function ()
    this:SetBackdropColor(r.r, r.g, r.b, .7)
  end)
  f.close:SetScript('OnEnter', function ()
    f.close:SetBackdropColor(r.r, r.g, r.b, .7)
    f.close:SetBackdropBorderColor(r.r, r.g, r.b, 0)
    f.close:SetWidth(14)
    f.close:SetHeight(14)
    f.close:SetPoint('TOPRIGHT', -11, -11)
    f.close.tex:SetVertexColor(1, 1, 1, 1)
  end)
  f.close:SetScript('OnLeave', function ()
    f.close:SetBackdropColor(r.r, r.g, r.b, 0)
    f.close:SetBackdropBorderColor(r.r, r.g, r.b, .7)
    f.close:SetWidth(16)
    f.close:SetHeight(16)
    f.close:SetPoint('TOPRIGHT', -10, -10)
    f.close.tex:SetVertexColor(r.r, r.g, r.b, .7)
  end)
  f.close:SetScript('OnClick', function () f:Hide() end)

  -----------------------------------------------------------------------------
  -- HEADER
  -----------------------------------------------------------------------------
  
  f.header = f:CreateFontString('PizzaSlicesSettingsText', 'DIALOG', 'GameFontWhite')
  f.header:SetFont(STANDARD_TEXT_FONT, 20, 'OUTLINE')
  f.header:SetJustifyH('CENTER')
  f.header:SetPoint('TOP', 0, -20)
  f.header:SetText(PS.Colors.primary .. 'Pizza' .. PS.Colors.secondary .. 'Slices')

  f.version = f:CreateFontString('PizzaSlicesSettingsVersion', 'DIALOG', 'GameFontWhite')
  f.version:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
  f.version:SetJustifyH('CENTER')
  f.version:SetPoint('TOP', f.header, 'BOTTOM', -5)
  f.version:SetText(PS.utils.getVersion())
  f.version:SetTextColor(1, 1, 1, .7)

  -----------------------------------------------------------------------------
  -- TABS
  -----------------------------------------------------------------------------
  
  f.tabs = CreateFrame('Frame', 'PizzaSlicesSettingsTabs', f)
  f.tabs:SetBackdrop(backdrop)
  f.tabs:SetBackdropColor(0, 0, 0, 0)
  f.tabs:SetBackdropBorderColor(1, 1, 1, 0)
  f.tabs:SetWidth(f:GetWidth())
  f.tabs:SetHeight(30)
  f.tabs:SetPoint('TOP', f.version, 'BOTTOM', 0, -20)

  local tabs = {
    general = CreateFrame('Button', 'PizzaSlicesSettingsTabsGeneral', f.tabs, 'UIPanelButtonTemplate'),
    rings = CreateFrame('Button', 'PizzaSlicesSettingsTabsRings', f.tabs, 'UIPanelButtonTemplate'),
  }

  for tabName, frame in pairs(tabs) do
    local tab = tabName
    frame:SetBackdrop(backdrop)
    frame:SetBackdropColor(0, 0, 0, 0)
    frame:SetBackdropBorderColor(1, 1, 1, 0)
    frame:SetNormalTexture('')
    frame:SetHighlightTexture('')
    frame:SetPushedTexture('')
    frame:SetDisabledTexture('')
    frame:SetWidth(f.tabs:GetWidth() / 2)
    frame:SetHeight(f.tabs:GetHeight())
    frame:SetPoint(tab == 'general' and 'TOPLEFT' or 'TOPRIGHT', 0, 0)
    frame:SetFont(STANDARD_TEXT_FONT, 16)
    frame:SetHighlightTextColor(1, 1, 1, 1)
    frame:SetText(PS.utils.capitalize(tab))
    frame:SetScript('OnEnter', function ()
      if not this.selected then
        -- this:SetBackdropColor(c.r, c.g, c.b, .5)
      end
    end)
    frame:SetScript('OnLeave', function ()
      if not this.selected then
        -- this:SetBackdropColor(0, 0, 0, 0)
      end
    end)
    frame:SetScript('OnClick', function () PS.settings.selectTab(tab) end)
    f.tabs[tab] = frame
  end

  -----------------------------------------------------------------------------
  -- TABS BORDER
  -----------------------------------------------------------------------------
  
  f.tabs.border = CreateFrame('Frame', 'PizzaSlicesSettingsTabsBorder', f.tabs)
  f.tabs.border:SetBackdrop(backdrop)
  f.tabs.border:SetBackdropColor(c.r, c.g, c.b, 1)
  f.tabs.border:SetBackdropBorderColor(0, 0, 0, 0)
  f.tabs.border:SetWidth(f.tabs:GetWidth())
  f.tabs.border:SetHeight(1)
  f.tabs.border:SetPoint('TOP', f.tabs, 'BOTTOM')

  -----------------------------------------------------------------------------
  -- CONTENT FRAME
  -----------------------------------------------------------------------------
  
  f.content = CreateFrame('Frame', 'PizzaSlicesSettingsContent', f)
  f.content:SetFrameStrata('BACKGROUND')
  f.content:SetWidth(f:GetWidth())
  f.content:SetPoint('TOP', f.tabs, 'BOTTOM', 0, -3)
  f.content:SetPoint('BOTTOM', 0, 0)
  f.content:SetBackdrop(backdrop)
  f.content:SetBackdropColor(0, 0, 0, .8)
  f.content:SetBackdropBorderColor(1, 1, 1, 0)

  -----------------------------------------------------------------------------
  -- GENERAL TAB
  -----------------------------------------------------------------------------
  
  local general = CreateFrame('Frame', 'PizzaSlicesSettingsGeneral', f.content)
  general:SetFrameStrata('DIALOG')
  general:SetPoint('TOPLEFT', -1, 2)
  general:SetPoint('BOTTOMRIGHT', 1, -1)
  general:SetBackdrop(backdrop)
  general:SetBackdropColor(0, 0, 0, 0)
  general:SetBackdropBorderColor(0, 0, 0, 0)
  general:Hide()

  do -- Slider: animation duration
    local frame = CreateFrame('Frame', general:GetName() .. 'AnimationDuration', general)
    frame:SetFrameStrata('DIALOG')
    frame:SetWidth(f:GetWidth() * .5)
    frame:SetHeight(22)
    frame:SetPoint('TOP', general, 'TOP', 0, -30)
    frame.label = frame:CreateFontString(frame:GetName() .. 'Label', 'DIALOG', 'GameFontWhite')
    frame.label:SetFont(STANDARD_TEXT_FONT, 16, 'OUTLINE')
    frame.label:SetJustifyH('LEFT')
    frame.label:SetPoint('LEFT', 0, 1)
    frame.label:SetText('Animation duration')
    frame.slider = CreateFrame('Slider', frame:GetName() .. 'Slider', frame)
    frame.slider:SetPoint('RIGHT', 0, 0)
    frame.slider:SetWidth(150)
    frame.slider:SetHeight(16)
    frame.slider:SetBackdrop(backdrop)
    frame.slider:SetBackdropColor(0, 0, 0, 0)
    frame.slider:SetBackdropBorderColor(1, 1, 1, 1)
    frame.slider:SetThumbTexture('Interface\\BUTTONS\\WHITE8X8')
    frame.slider:SetOrientation('HORIZONTAL')
    frame.slider:SetMinMaxValues(0, 200)
    frame.slider:SetValue(C.animation.duration * 100)
    frame.slider:SetValueStep(5)
    frame.slider:SetScript('OnValueChanged', function ()
      _G.PizzaSlices_config.animation.duration = this:GetValue() / 100
      frame.valuelabel:SetText(frame.slider:GetValue() .. '%')
    end)
    frame.valuelabel = frame:CreateFontString(frame:GetName() .. 'Valuelabel', 'DIALOG', 'GameFontWhite')
    frame.valuelabel:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
    frame.valuelabel:SetJustifyH('LEFT')
    frame.valuelabel:SetPoint('LEFT', frame.slider, 'RIGHT', 5, 0)
    frame.valuelabel:SetText(frame.slider:GetValue() .. '%')
    general.animationDuration = frame
  end

  do -- Checkbox: Position ring at mouse
    local frame = CreateFrame('Frame', 'PizzaSlicesSettingsGeneralMousePos', general)
    frame:SetFrameStrata('DIALOG')
    frame:SetWidth(f:GetWidth() * .5)
    frame:SetHeight(22)
    frame:SetPoint('TOP', general.animationDuration, 'TOP', 0, -30)
    frame.label = frame:CreateFontString(frame:GetName() .. 'Label', 'DIALOG', 'GameFontWhite')
    frame.label:SetFont(STANDARD_TEXT_FONT, 16, 'OUTLINE')
    frame.label:SetJustifyH('LEFT')
    frame.label:SetPoint('LEFT', 0, 1)
    frame.label:SetText('Open rings at mouse cursor')
    frame.checkbox = CreateFrame('CheckButton', frame:GetName() .. 'Checkbox', frame, 'UICheckButtonTemplate')
    frame.checkbox:SetNormalTexture("")
    frame.checkbox:SetPushedTexture("")
    frame.checkbox:SetHighlightTexture("")
    frame.checkbox:SetCheckedTexture('Interface\\AddOns\\PizzaSlices\\img\\checkboxcheck')
    frame.checkbox:SetBackdrop(backdrop)
    frame.checkbox:SetBackdropColor(0, 0, 0, 0)
    frame.checkbox:SetBackdropBorderColor(1, 1, 1, 1)
    frame.checkbox:SetWidth(16)
    frame.checkbox:SetHeight(16)
    frame.checkbox:SetPoint("RIGHT" , 0, 0)
    frame.checkbox:SetScript("OnClick", function () PizzaSlices_config.openAtCursor = this:GetChecked() ~= nil end)
    if C.openAtCursor then frame.checkbox:SetChecked() end
    general.mousePos = frame
  end

  do -- Dropdown: Ring close rotation animation
    local frame = CreateFrame('Frame', 'PizzaSlicesSettingsGeneralCloseRotation', general)
    frame:SetFrameStrata('DIALOG')
    frame:SetWidth(f:GetWidth() * .5)
    frame:SetHeight(22)
    frame:SetPoint('TOP', general.mousePos, 'TOP', 0, -32)
    frame.label = frame:CreateFontString(frame:GetName() .. 'Label', 'DIALOG', 'GameFontWhite')
    frame.label:SetFont(STANDARD_TEXT_FONT, 16, 'OUTLINE')
    frame.label:SetJustifyH('LEFT')
    frame.label:SetPoint('LEFT', 0, 1)
    frame.label:SetText('Ring close animation rotation')

    local function updateCheckboxes()
      local v = C.animation.rotateOnClose
      frame.checkboxOff:SetChecked(v == 0)
      frame.checkboxLeft:SetChecked(v == -1)
      frame.checkboxRight:SetChecked(v == 1)
    end

    local function setRotateOnClose(v)
      PizzaSlices_config.animation.rotateOnClose = v
      updateCheckboxes()
    end

    frame.checkboxOff = CreateFrame('CheckButton', frame:GetName() .. 'CheckboxOff', frame, 'UICheckButtonTemplate')
    frame.checkboxOff:SetNormalTexture("")
    frame.checkboxOff:SetPushedTexture("")
    frame.checkboxOff:SetHighlightTexture("")
    frame.checkboxOff:SetCheckedTexture('Interface\\AddOns\\PizzaSlices\\img\\checkboxcheck')
    frame.checkboxOff:SetBackdrop(backdrop)
    frame.checkboxOff:SetBackdropColor(0, 0, 0, 0)
    frame.checkboxOff:SetBackdropBorderColor(1, 1, 1, 1)
    frame.checkboxOff:SetWidth(16)
    frame.checkboxOff:SetHeight(16)
    frame.checkboxOff:SetPoint("RIGHT" , 0, 0)
    frame.checkboxOff:SetScript("OnClick", function () setRotateOnClose(0) end)
    frame.checkboxOff.label = frame.checkboxOff:CreateFontString(frame.checkboxOff:GetName() .. 'Label', 'DIALOG', 'GameFontWhite')
    frame.checkboxOff.label:SetFont(STANDARD_TEXT_FONT, 16, 'OUTLINE')
    frame.checkboxOff.label:SetJustifyH('RIGHT')
    frame.checkboxOff.label:SetPoint('RIGHT', -20, 0)
    frame.checkboxOff.label:SetText('Off')

    frame.checkboxLeft = CreateFrame('CheckButton', frame:GetName() .. 'CheckboxLeft', frame, 'UICheckButtonTemplate')
    frame.checkboxLeft:SetNormalTexture("")
    frame.checkboxLeft:SetPushedTexture("")
    frame.checkboxLeft:SetHighlightTexture("")
    frame.checkboxLeft:SetCheckedTexture('Interface\\AddOns\\PizzaSlices\\img\\checkboxcheck')
    frame.checkboxLeft:SetBackdrop(backdrop)
    frame.checkboxLeft:SetBackdropColor(0, 0, 0, 0)
    frame.checkboxLeft:SetBackdropBorderColor(1, 1, 1, 1)
    frame.checkboxLeft:SetWidth(16)
    frame.checkboxLeft:SetHeight(16)
    frame.checkboxLeft:SetPoint("RIGHT" , 0, -20)
    frame.checkboxLeft:SetScript("OnClick", function () setRotateOnClose(-1) end)
    frame.checkboxLeft.label = frame.checkboxLeft:CreateFontString(frame.checkboxLeft:GetName() .. 'Label', 'DIALOG', 'GameFontWhite')
    frame.checkboxLeft.label:SetFont(STANDARD_TEXT_FONT, 16, 'OUTLINE')
    frame.checkboxLeft.label:SetJustifyH('RIGHT')
    frame.checkboxLeft.label:SetPoint('RIGHT', -20, 0)
    frame.checkboxLeft.label:SetText('Left')

    frame.checkboxRight = CreateFrame('CheckButton', frame:GetName() .. 'CheckboxRight', frame, 'UICheckButtonTemplate')
    frame.checkboxRight:SetNormalTexture("")
    frame.checkboxRight:SetPushedTexture("")
    frame.checkboxRight:SetHighlightTexture("")
    frame.checkboxRight:SetCheckedTexture('Interface\\AddOns\\PizzaSlices\\img\\checkboxcheck')
    frame.checkboxRight:SetBackdrop(backdrop)
    frame.checkboxRight:SetBackdropColor(0, 0, 0, 0)
    frame.checkboxRight:SetBackdropBorderColor(1, 1, 1, 1)
    frame.checkboxRight:SetWidth(16)
    frame.checkboxRight:SetHeight(16)
    frame.checkboxRight:SetPoint("RIGHT" , 0, -40)
    frame.checkboxRight:SetScript("OnClick", function () setRotateOnClose(1) end)
    frame.checkboxRight.label = frame.checkboxRight:CreateFontString(frame.checkboxRight:GetName() .. 'Label', 'DIALOG', 'GameFontWhite')
    frame.checkboxRight.label:SetFont(STANDARD_TEXT_FONT, 16, 'OUTLINE')
    frame.checkboxRight.label:SetJustifyH('RIGHT')
    frame.checkboxRight.label:SetPoint('RIGHT', -20, 0)
    frame.checkboxRight.label:SetText('Right')

    updateCheckboxes()

    general.closeRotation = frame
  end

  -----------------------------------------------------------------------------
  -- RINGS TAB
  -----------------------------------------------------------------------------
  
  local rings = CreateFrame('Frame', 'PizzaSlicesSettingsRings', f.content)
  rings:SetFrameStrata('DIALOG')
  rings:SetPoint('TOPLEFT', 0, 2)
  rings:SetPoint('BOTTOMRIGHT', 0, 0)
  rings:SetBackdrop(backdrop)
  rings:SetBackdropColor(0, 0, 0, 0)
  rings:SetBackdropBorderColor(0, 0, 0, 0)
  rings:Hide()

  rings.list = CreateFrame('Frame', 'PizzaSlicesSettingsRingsList', rings)
  rings.list:SetFrameStrata('DIALOG')
  rings.list:SetWidth(f:GetWidth() / 2)
  rings.list:SetPoint('TOP', rings, 'TOP', 0, -60)
  rings.list:SetPoint('BOTTOM', rings, 'BOTTOM', 0, 30)
  rings.list.frames = {}

  rings.new = CreateFrame('Button', 'PizzaSlicesSettingsRingsNewButton', rings, 'UIPanelButtonTemplate')
  rings.new:SetBackdrop(backdrop)
  rings.new:SetBackdropColor(g.r, g.g, g.b, 0)
  rings.new:SetBackdropBorderColor(g.r, g.g, g.b, .7)
  rings.new:SetNormalTexture('')
  rings.new:SetHighlightTexture('')
  rings.new:SetPushedTexture('')
  rings.new:SetDisabledTexture('')
  rings.new:SetWidth(rings.list:GetWidth() + 2)
  rings.new:SetHeight(40)
  rings.new:SetPoint('BOTTOM', rings.list, 'TOP', 0, 10)
  rings.new:SetFont(STANDARD_TEXT_FONT, 40)
  rings.new:SetTextColor(g.r, g.g, g.b, .7)
  rings.new:SetHighlightTextColor(1, 1, 1, 1)
  rings.new:SetText('+')
  rings.new:SetScript('OnMouseDown', function ()
    this:SetBackdropColor(g.r, g.g, g.b, .5)
  end)
  rings.new:SetScript('OnMouseUp', function ()
    this:SetBackdropColor(g.r, g.g, g.b, .7)
  end)
  rings.new:SetScript('OnEnter', function ()
    rings.new:SetBackdropColor(g.r, g.g, g.b, .7)
    rings.new:SetBackdropBorderColor(g.r, g.g, g.b, 0)
    rings.new:SetWidth(rings.list:GetWidth())
    rings.new:SetHeight(38)
    rings.new:SetPoint('BOTTOMRIGHT', rings.list, 'TOPRIGHT', 0, 5)
  end)
  rings.new:SetScript('OnLeave', function ()
    rings.new:SetBackdropColor(g.r, g.g, g.b, 0)
    rings.new:SetBackdropBorderColor(g.r, g.g, g.b, .7)
    rings.new:SetWidth(rings.list:GetWidth() + 2)
    rings.new:SetHeight(40)
    rings.new:SetPoint('BOTTOMRIGHT', rings.list, 'TOPRIGHT', 1, 4)
  end)
  rings.new:SetScript('OnClick', function () PS.settings.editRing() end)

  rings.bind = CreateFrame('Frame', rings:GetName() .. 'Bind', rings)
  rings.bind:SetFrameLevel(10)
  rings.bind:SetPoint('TOPLEFT', f.tabs, 'TOPLEFT', 0, 0)
  rings.bind:SetPoint('BOTTOMRIGHT', 0, 0)
  rings.bind:SetBackdrop(backdrop)
  rings.bind:SetBackdropColor(b.r, b.g, b.b, .7)
  rings.bind:SetBackdropBorderColor(0, 0, 0, 0)
  rings.bind:EnableKeyboard(true)
  rings.bind:EnableMouse(true)
  rings.bind.text = rings.bind:CreateFontString(rings.bind:GetName() .. 'Text', 'DIALOG', 'GameFontWhite')
  rings.bind.text:SetFont(STANDARD_TEXT_FONT, 32, 'OUTLINE')
  rings.bind.text:SetJustifyH('CENTER')
  rings.bind.text:SetPoint('CENTER', 0, 20)
  rings.bind.text:SetTextColor(1, 1, 1, 1)
  rings.bind.hint = rings.bind:CreateFontString(rings.bind:GetName() .. 'Hint', 'DIALOG', 'GameFontWhite')
  rings.bind.hint:SetFont(STANDARD_TEXT_FONT, 20, 'OUTLINE')
  rings.bind.hint:SetJustifyH('CENTER')
  rings.bind.hint:SetPoint('CENTER', 0, -20)
  rings.bind.hint:SetTextColor(1, 1, 1, 1)
  rings.bind.hint:SetText('Or press ESC to abort')
  rings.bind:Hide()

  function getPrefix()
    return string.format('%s%s%s',
      (IsAltKeyDown() and modifiers.ALT or ''),
      (IsControlKeyDown() and modifiers.CTRL or ''),
      (IsShiftKeyDown() and modifiers.SHIFT or ''))
  end

  function getBindHandler(ringIdx, map)
    return function ()
      if modifiers[arg1] then return end

      local prefix = getPrefix()
      if not prefix or prefix == '' then
        for _, blockedKey in ipairs(blockedKeys) do
          if arg1 == blockedKey then return end
        end
      end

      if arg1 ~= 'ESCAPE' then
        local binding = 'PIZZASLICES_RING'..ringIdx
        local prevKey = GetBindingKey(binding)
        if prevKey then SetBinding(prevKey) end
        local key = map and map[arg1] or arg1
        if SetBinding(prefix..key, binding) then
          SaveBindings(GetCurrentBindingSet())
        end
      end

      rings.bind:Hide()
    end
  end

  function showKeybindOverlay(ringIdx)
    local ring = PizzaSlices_rings[ringIdx]
    rings.bind.text:SetText('Press key or mouse button to bind ring "' .. ring.name .. '"')
    rings.bind:Show()
    rings.bind:SetScript('OnKeyDown', getBindHandler(ringIdx))
    rings.bind:SetScript('OnMouseDown', getBindHandler(ringIdx, mouseButtonMap))
  end

  local function createEditFrame(ringIdx, ring)
    local edit = CreateFrame('Frame', 'PizzaSlicesSettingsRingsEdit', rings)
    edit:SetPoint('TOPLEFT', f.content, 'TOPLEFT', 0, -14)
    edit:SetPoint('BOTTOMRIGHT', f.content, 'BOTTOMRIGHT', 0, 0)

    edit.header = CreateFrame('EditBox', edit:GetName() .. 'Header', edit)
    edit.header:SetTextInsets(5, 5, 5, 5)
    edit.header:SetTextColor(1, 1, 1, 1)
    edit.header:SetJustifyH('CENTER')
    edit.header:SetWidth(400)
    edit.header:SetHeight(30)
    edit.header:SetPoint('TOP', 0, 0)
    edit.header:SetFont(STANDARD_TEXT_FONT, 20, 'OUTLINE')
    edit.header:SetAutoFocus(false)
    edit.header:SetText(ring.name)
    edit.header:SetScript('OnEscapePressed', function ()
      this:ClearFocus()
    end)

    edit.content = CreateFrame('Frame', edit:GetName() .. 'Content', edit)
    edit.content:SetWidth(f.content:GetWidth() - 30)
    edit.content:SetPoint('TOP', edit.header, 'BOTTOM', 0, - 10)
    edit.content:SetPoint('BOTTOM', edit, 'BOTTOM', 0, 60)

    edit.content.ring = CreateFrame('Frame', edit.content:GetName() .. 'Ring', edit.content)
    edit.content.ring:SetWidth(40)
    edit.content.ring:SetPoint('TOPLEFT', 0, 0)
    edit.content.ring:SetPoint('BOTTOMLEFT', 0, 0)
    edit.content.ring:SetBackdrop(backdrop)
    edit.content.ring:SetBackdropColor(c.r, c.g, c.b, .5)
    edit.content.ring:SetBackdropBorderColor(0, 0, 0, 0)
    edit.content.ringdrop = CreateFrame('Frame', edit.content:GetName() .. 'Ringdrop', edit.content)
    edit.content.ringdrop:SetPoint('TOPLEFT', -1, 1)
    edit.content.ringdrop:SetPoint('BOTTOMRIGHT', edit.content.ring, 'BOTTOMRIGHT', 1, -1)
    edit.content.ringdrop:SetBackdrop(backdrop)
    edit.content.ringdrop:SetBackdropColor(g.r, g.g, g.b, 0)
    edit.content.ringdrop:SetBackdropBorderColor(g.r, g.g, g.b, .7)
    edit.content.ringdrop:Hide()
    edit.content.ringdrop.text = edit.content.ringdrop:CreateFontString(edit.content.ringdrop:GetName() .. 'Text', 'DIALOG', 'GameFontWhite')
    edit.content.ringdrop.text:SetFont(STANDARD_TEXT_FONT, 32, 'OUTLINE')
    edit.content.ringdrop.text:SetJustifyH('CENTER')
    edit.content.ringdrop.text:SetPoint('CENTER', 0, 0)
    edit.content.ringdrop.text:SetTextColor(g.r, g.g, g.b, .7)
    edit.content.ringdrop.text:SetText('+')

    local mouseOverRingDrop = false
    edit.content.ringdrop:SetScript('OnUpdate', function ()
      local now = GetTime()
      if (this.tick or 1/PS.fps) > now then return else this.tick = now + 1/PS.fps end

      if MouseIsOver(this) then
        if not mouseOverRingDrop then
          mouseOverRingDrop = true
          this.text:SetTextColor(1, 1, 1, 1)
          this:SetBackdropColor(g.r, g.g, g.b, .7)
          this:SetBackdropBorderColor(g.r, g.g, g.b, 0)
          this:ClearAllPoints()
          this:SetPoint('TOPLEFT', 0, 0)
          this:SetPoint('BOTTOMRIGHT', edit.content.ring, 'BOTTOMRIGHT', 0, 0)
        end
      elseif mouseOverRingDrop then
        mouseOverRingDrop = false
        this.text:SetTextColor(g.r, g.g, g.b, .7)
        this:SetBackdropColor(g.r, g.g, g.b, 0)
        this:SetBackdropBorderColor(g.r, g.g, g.b, .7)
        this:ClearAllPoints()
        this:SetPoint('TOPLEFT', -1, 1)
        this:SetPoint('BOTTOMRIGHT', edit.content.ring, 'BOTTOMRIGHT', 1, -1)
      end
    end)

    edit.content.drop = CreateFrame('Frame', edit.content:GetName() .. 'Drop', edit.content)
    edit.content.drop:SetPoint('TOPLEFT', edit.content.ring, 'TOPRIGHT', 4, 1)
    edit.content.drop:SetPoint('BOTTOMRIGHT', 1, -1)
    edit.content.drop:SetBackdrop(backdrop)
    edit.content.drop:SetBackdropColor(r.r, r.g, r.b, 0)
    edit.content.drop:SetBackdropBorderColor(r.r, r.g, r.b, .7)
    edit.content.drop:Hide()
    edit.content.drop.tex = edit.content.drop:CreateTexture(edit.content.drop:GetName() .. 'Tex', 'ARTWORK')
    edit.content.drop.tex:SetWidth(64)
    edit.content.drop.tex:SetHeight(64)
    edit.content.drop.tex:SetPoint('CENTER', 0, 0)
    edit.content.drop.tex:SetTexture('Interface\\AddOns\\PizzaSlices\\img\\trash')
    edit.content.drop.tex:SetVertexColor(r.r, r.g, r.b, .7)
    local mouseOverDrop = false
    edit.content.drop:SetScript('OnUpdate', function ()
      local now = GetTime()
      if (this.tick or 1/PS.fps) > now then return else this.tick = now + 1/PS.fps end

      if MouseIsOver(this) then
        if not mouseOverDrop then
          mouseOverDrop = true
          this:SetBackdropColor(r.r, r.g, r.b, .7)
          this:SetBackdropBorderColor(r.r, r.g, r.b, 0)
          this.tex:SetVertexColor(1, 1, 1, 1)
          this:ClearAllPoints()
          this:SetPoint('TOPLEFT', edit.content.ring, 'TOPRIGHT', 5, 0)
          this:SetPoint('BOTTOMRIGHT', 0, 0)
        end
      elseif mouseOverDrop then
        mouseOverDrop = false
        this:SetBackdropColor(r.r, r.g, r.b, 0)
        this:SetBackdropBorderColor(r.r, r.g, r.b, .7)
        this.tex:SetVertexColor(r.r, r.g, r.b, .7)
        this:ClearAllPoints()
        this:SetPoint('TOPLEFT', edit.content.ring, 'TOPRIGHT', 4, 1)
        this:SetPoint('BOTTOMRIGHT', 1, -1)
      end
    end)

    edit.content.browser = CreateFrame('Frame', edit.content:GetName() .. 'Browser', edit.content)
    edit.content.browser:SetWidth(edit.content:GetWidth() - edit.content.ring:GetWidth() - 10)
    edit.content.browser:SetPoint('TOPRIGHT', 0, 0)
    edit.content.browser:SetPoint('BOTTOMRIGHT', 0, 0)

    edit.content.browser.categories = CreateFrame('Frame', edit.content.browser:GetName() .. 'Categories', edit.content.browser)
    edit.content.browser.categories:SetWidth(200)
    edit.content.browser.categories:SetPoint('TOPRIGHT', 0, 0)
    edit.content.browser.categories:SetPoint('BOTTOMRIGHT', 0, 0)
    edit.content.browser.categories:SetBackdrop(backdrop)
    edit.content.browser.categories:SetBackdropColor(0, 0, 0, 0)
    edit.content.browser.categories:SetBackdropBorderColor(0, 0, 0, 0)

    edit.content.browser.slices = CreateFrame('Frame', edit.content.browser:GetName() .. 'Slices', edit.content.browser)
    edit.content.browser.slices:SetPoint('TOPLEFT', edit.content.ring, 'TOPRIGHT', 5, 0)
    edit.content.browser.slices:SetPoint('BOTTOMRIGHT', edit.content.browser.categories, 'BOTTOMLEFT', -2, 0)
    edit.content.browser.slices:SetBackdrop(backdrop)
    edit.content.browser.slices:SetBackdropColor(0, 0, 0, 0)
    edit.content.browser.slices:SetBackdropBorderColor(0, 0, 0, 0)

    edit.content.browser.click = CreateFrame('Frame', edit:GetName() .. 'Click', edit.content.browser)
    edit.content.browser.click:SetPoint('TOPLEFT', edit.content.browser.slices, 0, 0)
    edit.content.browser.click:SetPoint('BOTTOMRIGHT', edit.content.browser.slices, 0, 0)
    edit.content.browser.click:SetFrameLevel(10)
    edit.content.browser.click.tex = edit.content.browser.click:CreateTexture(edit.content.browser.click:GetName() .. 'Tex', 'ARTWORK')
    edit.content.browser.click.tex:SetWidth(120)
    edit.content.browser.click.tex:SetHeight(120)
    edit.content.browser.click.tex:SetPoint('RIGHT', -5, 80)
    edit.content.browser.click.tex:SetTexture('Interface\\AddOns\\PizzaSlices\\img\\click')
    edit.content.browser.click.tex:SetAlpha(.5)

    edit.content.browser.dragndrop = CreateFrame('Frame', edit:GetName() .. 'Dragndrop', edit.content.browser)
    edit.content.browser.dragndrop:SetPoint('TOPLEFT', 0, 0)
    edit.content.browser.dragndrop:SetPoint('BOTTOMRIGHT', 0, 0)
    edit.content.browser.dragndrop:SetFrameLevel(10)
    edit.content.browser.dragndrop.tex = edit.content.browser.dragndrop:CreateTexture(edit.content.browser.dragndrop:GetName() .. 'Tex', 'ARTWORK')
    edit.content.browser.dragndrop.tex:SetWidth(200)
    edit.content.browser.dragndrop.tex:SetHeight(200)
    edit.content.browser.dragndrop.tex:SetPoint('BOTTOMLEFT', -5, 0)
    edit.content.browser.dragndrop.tex:SetTexture('Interface\\AddOns\\PizzaSlices\\img\\dragndrop')
    edit.content.browser.dragndrop.tex:SetAlpha(.5)

    edit.cancel = CreateFrame('Button', edit:GetName() .. 'Cancel', edit)
    edit.cancel:SetWidth(rings.list:GetWidth() / 2 - 2)
    edit.cancel:SetHeight(30)
    edit.cancel:SetPoint('BOTTOM', edit, 'BOTTOM', -edit.cancel:GetWidth() / 2 - 2, 14)
    edit.cancel:SetNormalTexture('')
    edit.cancel:SetHighlightTexture('')
    edit.cancel:SetPushedTexture('')
    edit.cancel:SetDisabledTexture('')
    edit.cancel:SetBackdrop(backdrop)
    edit.cancel:SetBackdropColor(0, 0, 0, 0)
    edit.cancel:SetBackdropBorderColor(r.r, r.g, r.b, .7)
    edit.cancel:SetFont(STANDARD_TEXT_FONT, 14)
    edit.cancel:SetTextColor(r.r, r.g, r.b, .7)
    edit.cancel:SetHighlightTextColor(1, 1, 1, 1)
    edit.cancel:SetText('Cancel')
    edit.cancel:SetScript('OnMouseDown', function ()
      this:SetBackdropColor(r.r, r.g, r.b, .5)
    end)
    edit.cancel:SetScript('OnMouseUp', function ()
      this:SetBackdropColor(r.r, r.g, r.b, .7)
    end)
    edit.cancel:SetScript('OnEnter', function ()
      edit.cancel:SetBackdropColor(r.r, r.g, r.b, .7)
      edit.cancel:SetBackdropBorderColor(0, 0, 0, 0)
      edit.cancel:SetWidth(rings.list:GetWidth() / 2 - 4)
      edit.cancel:SetHeight(28)
      edit.cancel:SetPoint('BOTTOM', edit, 'BOTTOM', -edit.cancel:GetWidth() / 2 - 3, 15)
    end)
    edit.cancel:SetScript('OnLeave', function ()
      edit.cancel:SetBackdropColor(0, 0, 0, 0)
      edit.cancel:SetBackdropBorderColor(r.r, r.g, r.b, .7)
      edit.cancel:SetWidth(rings.list:GetWidth() / 2 - 2)
      edit.cancel:SetHeight(30)
      edit.cancel:SetPoint('BOTTOM', edit, 'BOTTOM', -edit.cancel:GetWidth() / 2 - 2, 14)
    end)
    edit.cancel:SetScript('OnClick', function () PS.settings.cancelEditing() end)

    edit.save = CreateFrame('Button', edit:GetName() .. 'Save', edit)
    edit.save:SetWidth(rings.list:GetWidth() / 2 - 2)
    edit.save:SetHeight(30)
    edit.save:SetPoint('BOTTOM', edit, 'BOTTOM', edit.save:GetWidth() / 2 + 2, 14)
    edit.save:SetNormalTexture('')
    edit.save:SetHighlightTexture('')
    edit.save:SetPushedTexture('')
    edit.save:SetDisabledTexture('')
    edit.save:SetBackdrop(backdrop)
    edit.save:SetBackdropColor(0, 0, 0, 0)
    edit.save:SetBackdropBorderColor(g.r, g.g, g.b, .7)
    edit.save:SetFont(STANDARD_TEXT_FONT, 14)
    edit.save:SetTextColor(g.r, g.g, g.b, .7)
    edit.save:SetHighlightTextColor(1, 1, 1, 1)
    edit.save:SetText('Save')
    edit.save:SetScript('OnMouseDown', function ()
      this:SetBackdropColor(g.r, g.g, g.b, .5)
    end)
    edit.save:SetScript('OnMouseUp', function ()
      this:SetBackdropColor(g.r, g.g, g.b, .7)
    end)
    edit.save:SetScript('OnEnter', function ()
      edit.save:SetBackdropColor(g.r, g.g, g.b, .7)
      edit.save:SetBackdropBorderColor(0, 0, 0, 0)
      edit.save:SetWidth(rings.list:GetWidth() / 2 - 4)
      edit.save:SetHeight(28)
      edit.save:SetPoint('BOTTOM', edit, 'BOTTOM', edit.save:GetWidth() / 2 + 3, 15)
    end)
    edit.save:SetScript('OnLeave', function ()
      edit.save:SetBackdropColor(0, 0, 0, 0)
      edit.save:SetBackdropBorderColor(g.r, g.g, g.b, .7)
      edit.save:SetWidth(rings.list:GetWidth() / 2 - 2)
      edit.save:SetHeight(30)
      edit.save:SetPoint('BOTTOM', edit, 'BOTTOM', edit.save:GetWidth() / 2 + 2, 14)
    end)

    edit.save:SetScript('OnClick', function ()
      PS.settings.save(rings.edit.ringIdx, rings.edit.ring)
      PS.settings.cancelEditing()
    end)

    return edit
  end

  function PS.settings.update()
    if not PizzaSlices_rings then return end
    for _, frame in rings.list.frames do frame:Hide() end

    for i, ring in PizzaSlices_rings do
      local idx = i
      local f = rings.list.frames[idx]
      if not f then
        f = CreateFrame('Frame', 'PizzaSlicesSettingsRingsList' .. idx, rings.list)
        f:SetWidth(rings.list:GetWidth() + 120)
        f:SetHeight(30)
        f:EnableMouse(true)
        f:SetScript('OnEnter', function ()
          this.bind:Show()
          this.delete:Show()
        end)
        f.button = CreateFrame('Button', f:GetName() .. 'Button', f, 'UIPanelButtonTemplate')
        f.button:SetNormalTexture('')
        f.button:SetHighlightTexture('')
        f.button:SetPushedTexture('')
        f.button:SetDisabledTexture('')
        f.button:SetWidth(rings.list:GetWidth())
        f.button:SetHeight(30)
        f.button:SetPoint('CENTER', 0, 0)
        f.button:SetBackdrop(backdrop)
        f.button:SetBackdropColor(.1, .1, .1, 1)
        f.button:SetBackdropBorderColor(0, 0, 0, 0)
        f.button:SetFont(STANDARD_TEXT_FONT, 16)
        f.button:SetTextColor(1, 1, 1, .7)
        f.button:SetHighlightTextColor(1, 1, 1, 1)
        f.button:SetScript('OnMouseDown', function ()
          this:SetBackdropColor(.3, .3, .3, .8)
        end)
        f.button:SetScript('OnMouseUp', function ()
          this:SetBackdropColor(.3, .3, .3, 1)
        end)
        f.button:SetScript('OnEnter', function ()
          this:SetBackdropColor(.3, .3, .3, 1)
          f.bind:Show()
          f.delete:Show()
        end)
        f.button:SetScript('OnLeave', function ()
          this:SetBackdropColor(.1, .1, .1, 1)
          f.bind:Hide()
          f.delete:Hide()
        end)

        f.delete = CreateFrame('Button', f:GetName() .. 'Delete', f, 'UIPanelButtonTemplate')
        f.delete:Hide()
        f.delete:SetNormalTexture('')
        f.delete:SetHighlightTexture('')
        f.delete:SetPushedTexture('')
        f.delete:SetDisabledTexture('')
        f.delete:SetPoint('TOPLEFT', -1, 1)
        f.delete:SetPoint('BOTTOMRIGHT', f.button, 'BOTTOMLEFT', -1, -1)
        f.delete:SetBackdrop(backdrop)
        f.delete:SetBackdropColor(r.r, r.g, r.b, 0)
        f.delete:SetBackdropBorderColor(r.r, r.g, r.b, .7)
        f.delete.tex = f.delete:CreateTexture(f.delete:GetName() .. 'Tex', 'ARTWORK')
        f.delete.tex:SetWidth(22)
        f.delete.tex:SetHeight(22)
        f.delete.tex:SetPoint('CENTER', 0, 0)
        f.delete.tex:SetTexture('Interface\\AddOns\\PizzaSlices\\img\\trash')
        f.delete.tex:SetVertexColor(r.r, r.g, r.b, .7)
        f.delete:SetScript('OnMouseDown', function ()
          this:SetBackdropColor(r.r, r.g, r.b, .5)
          this.tex:SetPoint('CENTER', 1, -1)
        end)
        f.delete:SetScript('OnMouseUp', function ()
          this:SetBackdropColor(r.r, r.g, r.b, .7)
          this.tex:SetPoint('CENTER', 0, 0)
        end)
        f.delete:SetScript('OnEnter', function ()
          this:SetBackdropColor(r.r, r.g, r.b, .7)
          this:SetBackdropBorderColor(r.r, r.g, r.b, 0)
          this:SetPoint('TOPLEFT', 0, 0)
          this:SetPoint('BOTTOMRIGHT', f.button, 'BOTTOMLEFT', -2, 0)
          this.tex:SetVertexColor(1, 1, 1, 1)
        end)
        f.delete:SetScript('OnLeave', function ()
          this:SetBackdropColor(r.r, r.g, r.b, 0)
          this:SetBackdropBorderColor(r.r, r.g, r.b, .7)
          this:SetPoint('TOPLEFT', -1, 1)
          this:SetPoint('BOTTOMRIGHT', f.button, 'BOTTOMLEFT', -1, -1)
          this.tex:SetVertexColor(r.r, r.g, r.b, .7)
          this:Hide()
          f.bind:Hide()
        end)
        f.delete:SetScript('OnClick', function ()
          PS.rings.remove(idx)
          PS.settings.shiftBindings(idx)
          PS.settings.update()
        end)

        f.bind = CreateFrame('Button', f:GetName() .. 'Bind', f, 'UIPanelButtonTemplate')
        f.bind:Hide()
        f.bind:SetNormalTexture('')
        f.bind:SetHighlightTexture('')
        f.bind:SetPushedTexture('')
        f.bind:SetDisabledTexture('')
        f.bind:SetPoint('TOPLEFT', f.button, 'TOPRIGHT', 1, 1)
        f.bind:SetPoint('BOTTOMRIGHT', 1, -1)
        f.bind:SetBackdrop(backdrop)
        f.bind:SetBackdropColor(b.r, b.g, b.b, 0)
        f.bind:SetBackdropBorderColor(b.r, b.g, b.b, .7)
        f.bind:SetTextColor(b.r, b.g, b.b, .7)
        f.bind:RegisterEvent('UPDATE_BINDINGS')
        function f.bind.update()
          local binding = GetBindingKey('PIZZASLICES_RING'..idx) or 'Bind'
          f.bind:SetText(string.gsub(binding, 'BUTTON', 'MOUSE '))
        end
        f.bind.update()
        f.bind:SetScript('OnEvent', function ()
          f.bind.update()
        end)
        f.bind:SetScript('OnMouseDown', function ()
          this:SetBackdropColor(b.r, b.g, b.b, .5)
        end)
        f.bind:SetScript('OnMouseUp', function ()
          this:SetBackdropColor(b.r, b.g, b.b, .7)
        end)
        f.bind:SetScript('OnEnter', function ()
          this:SetBackdropColor(b.r, b.g, b.b, .7)
          this:SetBackdropBorderColor(b.r, b.g, b.b, 0)
          this:SetTextColor(1, 1, 1, 1)
          this:SetPoint('TOPLEFT', f.button, 'TOPRIGHT', 2, 0)
          this:SetPoint('BOTTOMRIGHT', 0, 0)
        end)
        f.bind:SetScript('OnLeave', function ()
          this:SetBackdropColor(b.r, b.g, b.b, 0)
          this:SetBackdropBorderColor(b.r, b.g, b.b, .7)
          this:SetTextColor(b.r, b.g, b.b, .7)
          this:SetPoint('TOPLEFT', f.button, 'TOPRIGHT', 1, 1)
          this:SetPoint('BOTTOMRIGHT', 1, -1)
          this:Hide()
          f.delete:Hide()
        end)
        f.bind:SetScript('OnClick', function ()
          showKeybindOverlay(idx)
        end)
        rings.list.frames[idx] = f
      end

      local i = idx
      f:Show()
      f:SetPoint('TOP', 0, (idx - 1) * -35)
      f.button:SetText(ring.name)
      f.button:SetScript('OnClick', function () PS.settings.editRing(i) end)
    end
  end

  function loadRingSlices()
    local r = rings.edit.content.ring

    for _, frame in r.slices do frame:Hide() end

    for i, sl in ipairs(rings.edit.ring.slices) do
      local idx = i
      local slice = sl
      local f = r.slices[idx]
      if not f then
        f = CreateFrame('Frame', r:GetName() .. 'Slice' .. idx, r)
        f:SetWidth(36)
        f:SetHeight(36)
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag('LeftButton')
        if not slice.noBorder then
          f.borderlow = f:CreateTexture(f:GetName() .. 'BorderLow', 'OVERLAY')
          f.borderlow:SetAllPoints(f)
          f.borderlow:SetTexture('Interface\\AddOns\\PizzaSlices\\img\\borderlo')
          f.borderlow:SetVertexColor(c.r, c.g, c.b, 1)
          f.borderhigh = f:CreateTexture(f:GetName() .. 'BorderHigh', 'OVERLAY')
          f.borderhigh:SetAllPoints(f)
          f.borderhigh:SetTexture('Interface\\AddOns\\PizzaSlices\\img\\borderhi')
          f.borderhigh:SetVertexColor(c.r, c.g, c.b, 1)
        end
        r.slices[idx] = f
      end

      f:Show()
      f:ClearAllPoints()
      f:SetPoint('TOP', 0, (idx - 1) * -40 - 4)
      f:SetScript('OnEnter', function ()
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
        if slice.spellId then
          GameTooltip:SetSpell(slice.spellId, 'spell')
        else
          GameTooltip:AddLine(PS.Colors.secondary .. slice.name)
        end
        GameTooltip:Show()
      end)
      f:SetScript('OnLeave', function ()
        GameTooltip:Hide()
      end)
      f:SetScript('OnDragStart', function ()
        rings.edit.content.browser:Hide()
        rings.edit.content.drop:Show()
        f:StartMoving()
      end)
      f:SetScript('OnDragStop', function ()
        local removed = handleDrop(slice, idx)
        if removed then
          f:Hide()
          loadRingSlices()
        end
        f:StopMovingOrSizing()
        f:ClearAllPoints()
        f:SetPoint('TOP', 0, (idx - 1) * -40 - 2)
        rings.edit.content.browser:Show()
        rings.edit.content.drop:Hide()
      end)

      if not f.tex then
        f.tex = f:CreateTexture(f:GetName() .. 'Tex', 'ARTWORK')
        f.tex:SetAllPoints(f)
      end
      f.tex:SetTexture(slice.tex)
    end
  end

  function handleDrop(slice, sliceIdx)
    local slices = rings.edit.ring.slices
    local dropFrame = rings.edit.content.drop
    local ringdropFrame = rings.edit.content.ringdrop

    if MouseIsOver(dropFrame) and dropFrame:IsVisible() then
      table.remove(slices, sliceIdx)
      return true
    elseif MouseIsOver(ringdropFrame) and ringdropFrame:IsVisible() then
      table.insert(slices, slice)
      loadRingSlices()
      return true
    end
    return false
  end

  function showBrowserSlices(slices)
    local s = rings.edit.content.browser.slices
    s.frames = s.frames or {}
    for _, frame in ipairs(s.frames) do frame:Hide() end

    for idx, slice in ipairs(slices) do
      local f = s.frames[idx]
      if not f then
        f = CreateFrame('Frame', s:GetName() .. 'Slice' .. idx, s)
        f:SetFrameLevel(20)
        f:SetWidth(36)
        f:SetHeight(36)
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag('LeftButton')
        if not slice.noBorder then
          f.borderlow = f:CreateTexture(f:GetName() .. 'BorderLow', 'OVERLAY')
          f.borderlow:SetAllPoints(f)
          f.borderlow:SetTexture('Interface\\AddOns\\PizzaSlices\\img\\borderlo')
          f.borderlow:SetVertexColor(c.r, c.g, c.b, 1)
          f.borderhigh = f:CreateTexture(f:GetName() .. 'BorderHigh', 'OVERLAY')
          f.borderhigh:SetAllPoints(f)
          f.borderhigh:SetTexture('Interface\\AddOns\\PizzaSlices\\img\\borderhi')
          f.borderhigh:SetVertexColor(c.r, c.g, c.b, 1)
        end
        s.frames[idx] = f
      end

      local name = slice.name
      local spellId = slice.spellId
      f:SetScript('OnEnter', function ()
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
        if spellId then
          GameTooltip:SetSpell(spellId, 'spell')
        else
          GameTooltip:AddLine(PS.Colors.secondary .. name)
        end
        GameTooltip:Show()
      end)
      f:SetScript('OnLeave', function ()
        GameTooltip:Hide()
      end)

      if f.borderlow and f.borderhigh then
        if not slice.noBorder then
          f.borderlow:Show()
          f.borderhigh:Show()
        else
          f.borderlow:Hide()
          f.borderhigh:Hide()
        end
      end

      f:Show()
      f:ClearAllPoints()
      local sl = slice
      local x = PS.utils.mod(idx - 1, 13) * 40 + 2
      local y = math.floor((idx - 1) / 13) * -42
      f:SetPoint('TOPLEFT', x, y)
      f:SetScript('OnDragStart', function ()
        local clone = f.clone
        if not clone then
          clone = CreateFrame('Frame', f:GetName() .. 'Clone', f)
          clone:SetWidth(f:GetWidth())
          clone:SetHeight(f:GetHeight())
          clone:SetMovable(true)
          clone.tex = clone:CreateTexture(clone:GetName() .. 'Tex', 'ARTWORK')
          clone.tex:SetAllPoints(clone)
          f.clone = clone
        end

        clone:ClearAllPoints()
        clone:SetPoint('CENTER', 0, 0)
        clone:Show()
        clone:StartMoving()
        clone.tex:SetTexture(sl.tex)

        rings.edit.content.ring:Hide()
        rings.edit.content.ringdrop:Show()
      end)
      f:SetScript('OnDragStop', function ()
        handleDrop(sl)
        rings.edit.content.ringdrop:Hide()
        rings.edit.content.ring:Show()
        f.clone:StopMovingOrSizing()
        f.clone:Hide()
      end)

      if not f.tex then
        f.tex = f:CreateTexture(f:GetName() .. 'Tex', 'ARTWORK')
        f.tex:SetAllPoints(f)
      end
      f.tex:SetTexture(slice.tex)
    end
  end

  function selectCategory(category)
    showBrowserSlices(PS.slices.categories[category])

    local c = rings.edit.content.browser.categories
    for _, f in c.frames do
      if f:GetText() == category then
        f:SetTextColor(1, 1, 1, 1)
        f:SetBackdropColor(1, 1, 1, .3)
        f:SetScript('OnLeave', function () this:SetBackdropColor(1, 1, 1, .3) end)
      else
        f:SetTextColor(1, 1, 1, .7)
        f:SetBackdropColor(1, 1, 1, .1)
        f:SetScript('OnLeave', function () this:SetBackdropColor(1, 1, 1, .1) end)
      end
    end
  end

  local function populateCategories()
    local idx = 1
    for category in pairs(PS.slices.categories) do
      local c = rings.edit.content.browser.categories
      c.frames = c.frames or {}
      local f = c.frames[idx]
      if not f then
        f = CreateFrame('Button', c:GetName() .. idx, c, 'UIPanelButtonTemplate')
        f:SetNormalTexture('')
        f:SetHighlightTexture('')
        f:SetPushedTexture('')
        f:SetDisabledTexture('')
        f:SetWidth(c:GetWidth())
        f:SetHeight(26)
        f:SetBackdrop(backdrop)
        f:SetBackdropColor(.1, .1, .1, 1)
        f:SetBackdropBorderColor(0, 0, 0, 0)
        f:SetFont(STANDARD_TEXT_FONT, 16)
        f:SetTextColor(1, 1, 1, .7)
        f:SetHighlightTextColor(1, 1, 1, 1)
        f:SetScript('OnMouseDown', function () this:SetBackdropColor(.3, .3, .3, .8) end)
        f:SetScript('OnMouseUp', function () this:SetBackdropColor(.3, .3, .3, 1) end)
        f:SetScript('OnEnter', function () this:SetBackdropColor(.3, .3, .3, 1) end)
        f:SetScript('OnLeave', function () this:SetBackdropColor(.1, .1, .1, 1) end)
        c.frames[idx] = f
      end

      local cat = category
      f:SetPoint('TOP', 0, (idx - 1) * -30)
      f:SetText(category)
      f:SetScript('OnClick', function () selectCategory(cat) end)
      idx = idx + 1
    end
  end

  function PS.settings.editRing(ringIdx)
    -- Clone the ring here because we only want to actually apply the changes
    -- once the player hits the save button.
    local ring = ringIdx and PS.utils.clone(PizzaSlices_rings[ringIdx]) or { name = 'New Ring', slices = {} }
    if not ring then
      PS:PrintError('Ring at index ' .. ringIdx .. ' doesn\'t exist!')
      return
    end

    local idx = ringIdx or PS.utils.length(PizzaSlices_rings) + 1
    if not rings.edit then rings.edit = createEditFrame(idx, ring) end
    rings.edit.header:SetScript('OnCursorChanged', function ()
      ring.name = this:GetText()
    end)

    rings.edit.ring = ring
    rings.edit.ringIdx = idx
    rings.edit.header:SetText(ring.name)
    if not rings.edit.content.browser.categories.frames then
      populateCategories()
    end

    local r = rings.edit.content.ring
    -- Hide all existing ring slice frames first, then add/show
    -- only the ones we need.
    r.slices = r.slices or {}
    for idx, sliceFrame in ipairs(r.slices) do sliceFrame:Hide() end
    loadRingSlices()

    rings.list:Hide()
    rings.new:Hide()
    rings.edit:Show()
  end

  function PS.settings.shiftBindings(fromIdx)
    for idx = fromIdx, PS.utils.length(PizzaSlices_rings) do
      local key = GetBindingKey('PIZZASLICES_RING' .. idx)
      local newKey = GetBindingKey('PIZZASLICES_RING' .. (idx + 1))
      if key then SetBinding(key) end
      if newKey then SetBinding(newKey, 'PIZZASLICES_RING' .. idx) end
    end
    SaveBindings(GetCurrentBindingSet())
  end

  function PS.settings.save(idx, ring)
    _G.PizzaSlices_rings[idx] = ring
    PS.settings.update()
  end

  function PS.settings.cancelEditing()
    rings.list:Show()
    rings.new:Show()
    rings.edit:Hide()
  end

  -----------------------------------------------------------------------------
  -- TABS LOGIC
  -----------------------------------------------------------------------------
  
  f.content.tabs = {
    general = general,
    rings = rings,
  }

  function PS.settings.selectTab(tabName)
    for name, tab in pairs(tabs) do
      tab.selected = name == tabName
      local r, g, b, a
      if tab.selected then
        r, g, b, a = c.r, c.g, c.b, 1
        f.content.tabs[name]:Show()
        tab:SetTextColor(1, 1, 1, 1)
      else
        f.content.tabs[name]:Hide()
        tab:SetTextColor(1, 1, 1, .7)
      end
      tab:SetBackdropColor(r or 0, g or 0, b or 0, a or 0)
    end
  end

  -----------------------------------------------------------------------------
  -- INIT
  -----------------------------------------------------------------------------
  
  function PS.settings.init()
    PS.settings.selectTab('general')
  end
end)
