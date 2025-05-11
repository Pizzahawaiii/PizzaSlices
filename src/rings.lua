PizzaSlices:RegisterModule('rings', function ()
  PS.rings = {}
  PS.rings.default = {}

  function PS.rings.migrate()
    if not PizzaSlices_rings then return end

    local version = PS.utils.getVersionNumber()

    if version < 10201 then
      for ringIdx, ring in ipairs(PizzaSlices_rings) do
        for sliceIdx, slice in ipairs(ring.slices) do
          if string.sub(slice.action, 1, 5) == 'item:' then
            if slice.id then
              if not slice.itemId then
                _G.PizzaSlices_rings[ringIdx].slices[sliceIdx].itemId = slice.id
              end
              slice.id = nil
            end
          end
        end
      end
    end

    PS.rings.migrated = true
  end

  function PS.rings.load(withSpells)
    -- (Re)populate default rings
    PS.rings.default = {}
    local defaultRingNames = { 'Raid Marks', 'Mounts', 'ItemRack Sets' }
    for _, name in ipairs(defaultRingNames) do
      local slices = PS.slices.categories[name]
      if slices and PS.utils.length(slices) > 0 then
        table.insert(PS.rings.default, {
          name = name,
          slices = slices,
        })
      end
    end

    if withSpells and not PS.rings.migrated then
      PS.rings.migrate()
    end
    
    -- If player doesn't have any rings, use the default ones initially.
    -- But only if we know that the player's spellbook has already been
    -- populated. Otherwise we won't be able to load the mounts yet.
    if withSpells and not _G.PizzaSlices_rings then
      _G.PizzaSlices_rings = PS.rings.default
    end

    -- Update the settings frame so it shows all rings.
    PS.settings.update()
  end

  function PS.rings.remove(idx)
    if not PizzaSlices_rings then return end
    local rings = PS.utils.clone(PizzaSlices_rings)
    local removed = table.remove(rings, idx)
    _G.PizzaSlices_rings = rings
    return removed
  end

  function PS.rings.init()
    PS.rings.load()
  end
end)
