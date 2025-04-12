PizzaSlices:RegisterModule('rings', function ()
  PS.rings = {}
  PS.rings.default = {}

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
    
    -- If player doesn't have any rings, use the default ones initially.
    -- But only if we know that the player's spellbook has already been
    -- populated. Otherwise we won't be able to load the mounts yet.
    if withSpells and not _G.PizzaSlices_rings then
      _G.PizzaSlices_rings = PS.rings.default
    end

    -- Update the settings frame so it shows all rings.
    PS.settings.update()
  end

  function PS.rings.init()
    PS.rings.load()
  end
end)
