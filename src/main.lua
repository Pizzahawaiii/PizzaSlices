PizzaSlices = CreateFrame('Frame', 'PizzaSlices', UIParent)
local PS = PizzaSlices

PS.name = PS:GetName()
PS.open = false
PS.fps = 60

PS.modules = {}
PS.moduleNames = {}
PS.frames = {}
PS.env = {}

PS.Colors = {
  primary = '|cffa050ff',
  secondary = '|cffffffff',
  red = '|cffff462e',
  grey = '|cffaaaaaa',
  green = '|cff00ff98',
}

BINDING_HEADER_PIZZASLICES = 'PizzaSlices'
BINDING_NAME_PIZZASLICES_RING1 = 'Ring 1'
BINDING_NAME_PIZZASLICES_RING2 = 'Ring 2'
BINDING_NAME_PIZZASLICES_RING3 = 'Ring 3'
BINDING_NAME_PIZZASLICES_RING4 = 'Ring 4'
BINDING_NAME_PIZZASLICES_RING5 = 'Ring 5'
BINDING_NAME_PIZZASLICES_RING6 = 'Ring 6'
BINDING_NAME_PIZZASLICES_RING7 = 'Ring 7'
BINDING_NAME_PIZZASLICES_RING8 = 'Ring 8'
BINDING_NAME_PIZZASLICES_RING9 = 'Ring 9'
BINDING_NAME_PIZZASLICES_RING10 = 'Ring 10'
BINDING_NAME_PIZZASLICES_RING11 = 'Ring 11'
BINDING_NAME_PIZZASLICES_RING12 = 'Ring 12'
BINDING_NAME_PIZZASLICES_RING13 = 'Ring 13'
BINDING_NAME_PIZZASLICES_RING14 = 'Ring 14'
BINDING_NAME_PIZZASLICES_RING15 = 'Ring 15'

setmetatable(PS.env, { __index = function (self, key)
  if key == 'T' then return end
  return getfenv(0)[key]
end})

function PS:GetEnv()
  if not PS.env.T then
    local locale = GetLocale() or 'enUS'
    PS.env.T = setmetatable({}, {
      __index = function(tbl, key)
        local value = tostring(key)
        rawset(tbl, key, value)
        return value
      end
    })
  end

  PS.env._G = getfenv(0)
  PS.env.C = PizzaSlices_config
  PS.env.PS = PizzaSlices

  return PS.env
end

setfenv(1, PS:GetEnv())

function PS:Print(msg, withPrefix)
  local prefix = withPrefix == false and '' or PS.Colors.primary .. 'Pizza' .. PS.Colors.secondary .. 'Slices:|r '
  DEFAULT_CHAT_FRAME:AddMessage(prefix .. msg)
end

function PS:PrintClean(msg)
  PS:Print(msg, false)
end

function PS:PrintError(msg)
  PS:Print(PS.Colors.red .. msg)
end

function PS:RegisterModule(name, module)
  if PS.modules[name] then return end
  PS.modules[name] = module
  table.insert(PS.moduleNames, name)
end

function PS:LoadModule(name)
  setfenv(PS.modules[name], PS:GetEnv())
  PS.modules[name]()
end

function PS:SelectSlice(selectedIdx)
  if not PS.ring then return end

  PS.selectedIdx = selectedIdx
  for idx, slice in PS.ring.slices do
    slice.selected = idx == selectedIdx
  end
end

function PS:Deselect()
  PS:SelectSlice()
end

local actions = {
  spell = function (v, slice)
    local spellName = v == '<name>' and slice.name or v
    CastSpellByName(spellName)
  end,

  raidmark = function (v)
    if v == 'clear' then
      for i = 1, 8, 1 do
        if UnitExists('mark' .. i) then
          SetRaidTarget('mark' .. i, 0)
        end
      end
    else
      SetRaidTarget('target', tonumber(v))
    end
  end,

  itemrack = function (v, slice)
    if v == '<name>' then
      local _, _, setName = PS.utils.strSplit(slice.name, ' ')
      if setName then Rack.EquipSet(setName) end
    else
      Rack.EquipSet(v)
    end
  end,

  macro = function (v, slice)
    if v == '<name>' then
      local _, macroName = PS.utils.strSplit(slice.name, ' ')
      if macroName then RunMacro(macroName) end
    else
      RunMacro(v)
    end
  end,
}


function PS:TriggerSliceAction(idx)
  if not idx or not PS.ring or not PS.ring.slices or not PS.ring.slices[idx] or not PS.ring.slices[idx].action then
    return
  end
  local slice = PS.ring.slices[idx]
  local actionType, actionValue = PS.utils.strSplit(slice.action, ':')
  local action = actions[actionType]
  if not action then
    return
  end
  action(actionValue, slice)
end

PS.lastToggleTime = 0
PS.toggleCooldown = 0.5
PS.holdState = false

function PS:Open(ringIdx, keystate)
  if not PizzaSlices_rings[ringIdx] then
    return
  end

  local ring = PS.utils.clone(PizzaSlices_rings[ringIdx])
  if not ring or PS.utils.length(ring.slices) == 0 then
    PS.open = false
    PS:Deselect()
    if PS.frame then
      PS.frame:Hide()
    end
    return
  end


  if not PS.frame then
    return
  end

  if C.triggerOnClick then
    local currentTime = GetTime()
    if currentTime < PS.lastToggleTime + PS.toggleCooldown then return end
    PS.open = not PS.open
    PS.lastToggleTime = currentTime
    if PS.open then
      PS.frame.open(ring)
      PS.frame:Show()
    else
      PS:Deselect()
      PS.frame:Hide()
    end
  else
    PS.holdState = not PS.holdState
    if PS.holdState then
      PS.open = true
      PS.frame.open(ring)
      PS.frame:Show()
    else
      if PS.selectedIdx then
        PS:TriggerSliceAction(PS.selectedIdx)
      end
      PS:Deselect()
      PS.open = false
      PS.frame:Hide()
    end
  end
end

function PS:TriggerOnClick(button)
  if not PS.open then
    return
  end
  if not PS.ring then
    return
  end
  if not PS.selectedIdx then
    return
  end
  if not PS.ring.slices or not PS.ring.slices[PS.selectedIdx] then
    return
  end
  if button == "LeftButton" then
    PS:TriggerSliceAction(PS.selectedIdx)
    PS:Deselect()
    PS.open = false
    if PS.frame then
      PS.frame:Hide()
    end
  else
  end
end

PS:RegisterEvent('ADDON_LOADED')
PS:SetScript('OnEvent', function ()
  if event == 'ADDON_LOADED' and arg1 == PS.name then
    PS:LoadConfig()

    if PS.modules['frame'] then
      PS:LoadModule('frame')
    end

    for _, moduleName in ipairs(PS.moduleNames) do
      if moduleName ~= 'frame' then
        PS:LoadModule(moduleName)
      end
    end

    for _, moduleName in ipairs(PS.moduleNames) do
      if PS[moduleName] and PS[moduleName].init then
        PS[moduleName].init()
      end
    end
  end
end)

PS:RegisterEvent('ADDON_LOADED')
PS:SetScript('OnEvent', function ()
  if event == 'ADDON_LOADED' and arg1 == PS.name then
    PS:LoadConfig()

    for _, moduleName in PS.moduleNames do
      PS:LoadModule(moduleName)
    end

    for _, moduleName in PS.moduleNames do
      if PS[moduleName] and PS[moduleName].init then
        PS[moduleName].init()
      end
    end
  end
end)
