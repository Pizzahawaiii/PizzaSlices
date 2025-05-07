PizzaSlices:RegisterModule('utils', function ()
  PS.utils = {}

  -- TODO: Move math utils to separate math module?
  function PS.utils.mod(x, y)
    return x - math.floor(x / y) * y
  end

  function PS.utils.round(n)
    return math.floor(n + .5)
  end

  function PS.utils.pow(x)
    return x * x
  end

  function PS.utils.distance(x1, y1, x2, y2)
    return sqrt(PS.utils.pow(x1 - x2) + PS.utils.pow(y1 - y2))
  end

  function PS.utils.length(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
  end

  function PS.utils.strSplit(str, delimiter, asTable)
    if not str then return nil end
    local delimiter, fields = delimiter or ':', {}
    local pattern = string.format('([^%s]+)', delimiter)
    string.gsub(str, pattern, function(c) fields[table.getn(fields)+1] = c end)
    if asTable then return fields end
    return unpack(fields)
  end

  function PS.utils.capitalize(str)
    return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2, -1)
  end

  function PS.utils.clone(tbl)
    local clone = {}
    for k, v in pairs(tbl) do
      clone[k] = type(v) == 'table' and PS.utils.clone(v) or v
    end
    return clone
  end

  function PS.utils.getSliceCoords(idx, count, angle, radius)
    local angleRad = angle * math.pi / 180
    local x = radius * math.cos(angleRad)
    local y = radius * math.sin(angleRad)
    local nextAngle = angle - 360 / count
    return x, y, nextAngle
  end

  local function calculateCorner(angle)
    local r = rad(angle)
    return .5 + math.cos(r) / sqrt(2), .5 + math.sin(r) / sqrt(2)
  end

  function PS.utils.rotateTexture(texture, angle)
    local a = angle * -1
    local LRx, LRy = calculateCorner(a + 45)
    local LLx, LLy = calculateCorner(a + 135)
    local ULx, ULy = calculateCorner(a + 225)
    local URx, URy = calculateCorner(a - 45)

    texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
  end

  local function hue2rgb(p, q, t)
    if t < 0 then t = t + 1 end
    if t > 1 then t = t - 1 end
    if t < 1/6 then return p + (q - p) * 6 * t end
    if t < 1/2 then return q end
    if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
    return p
  end

  local function hsl2rgb(h, s, l)
    local r, g, b

    if s == 0 then
      r = g 
      g = b
      b = l
    else
      local q = l < .5 and l * (1 + s) or l + s - l * s
      local p = 2 * l - q
      r = hue2rgb(p, q, h + 1/3)
      g = hue2rgb(p, q, h)
      b = hue2rgb(p, q, h - 1/3)
    end

    return r, g, b
  end

  function PS.utils.getRandomColor()
    local h, s, l = math.random(0, 360) / 360, math.random(42, 98) / 100, math.random(40, 90) / 100
    local r, g, b = hsl2rgb(h, s, l)
    return { r = r, g = g, b = b }
  end

  function PS.utils.hasSpell(spellName)
    for i = 1, GetNumSpellTabs() do
      local _, _, offset, spellCount = GetSpellTabInfo(i)
      for spellId = offset + 1, offset + spellCount do
        if GetSpellName(spellId, 'spell') == spellName then
          return true, spellId
        end
      end
    end

    return false
  end

  function PS.utils.hasSuperWoW()
    return SetAutoloot ~= nil
  end
end)
