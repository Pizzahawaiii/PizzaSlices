PizzaSlices:RegisterModule('snowfall', function ()
  if PS.utils.hasPfUI() then
    if pfUI_config.bars.keydown ~= '1' then
      pfUI_config.bars.keydown = '1'
    end
    return
  end

  function _G.ActionButtonDown(id)
    PS.OnClose = function ()
      ActionButtonUp(id)
    end

    local button,pagedID
    if bongos == nil then
      if ( BonusActionBarFrame:IsShown() ) then
        local button = getglobal("BonusActionButton"..id);
        if ( button:GetButtonState() == "NORMAL" ) then
          button:SetButtonState("PUSHED");
          UseAction(ActionButton_GetPagedID(button), 0, 0);
        end
        return;
      end

      button = getglobal("ActionButton"..id)
      
      if (button:GetButtonState() == "NORMAL" ) then
        button:SetButtonState("PUSHED");
        UseAction(ActionButton_GetPagedID(button), 0, 0);
      end
    else
      button = getglobal("BActionButton"..id)
      pagedID = BActionButton.GetPagedID(id);
      if (button and button:GetButtonState() == "NORMAL" ) then
        button:SetButtonState("PUSHED");
      end
      UseAction(pagedID, 0);
    end
  end

  function _G.ActionButtonUp(id, onSelf)
    local button
    if bongos == nil then
      if ( BonusActionBarFrame:IsShown() ) then
        local button = getglobal("BonusActionButton"..id);
        if ( button:GetButtonState() == "PUSHED" ) then
          button:SetButtonState("NORMAL");
          if ( MacroFrame_SaveMacro ) then
            MacroFrame_SaveMacro();
          end
          if ( IsCurrentAction(ActionButton_GetPagedID(button)) ) then
            button:SetChecked(1);
          else
            button:SetChecked(0);
          end
        end
        return;
      end

      button = getglobal("ActionButton"..id)
      if ( button and button:GetButtonState() == "PUSHED" ) then
        button:SetButtonState("NORMAL");
        if ( MacroFrame_SaveMacro ) then
          MacroFrame_SaveMacro();
        end
        if ( IsCurrentAction(ActionButton_GetPagedID(button)) ) then
          button:SetChecked(1);
        else
          button:SetChecked(0);
        end
      end
    else
      button = getglobal("BActionButton"..id)
      if ( button and button:GetButtonState() == "PUSHED" ) then
        button:SetButtonState("NORMAL");
        if ( MacroFrame_SaveMacro ) then
          MacroFrame_SaveMacro();
        end
        button:SetChecked(IsCurrentAction(BActionButton.GetPagedID(id)));
      end
    end
  end

  function _G.MultiActionButtonDown(bar, id)
    PS.OnClose = function ()
      MultiActionButtonUp(bar, id)
    end

    local button = getglobal(bar.."Button"..id);
    if ( button:GetButtonState() == "NORMAL" ) then
      button:SetButtonState("PUSHED");
      UseAction(ActionButton_GetPagedID(button), 0, 0);
    end
  end

  function _G.MultiActionButtonUp(bar, id, onSelf)
    local button = getglobal(bar.."Button"..id);
    if ( button:GetButtonState() == "PUSHED" ) then
      button:SetButtonState("NORMAL");
      if ( MacroFrame_SaveMacro ) then
        MacroFrame_SaveMacro();
      end
      
      if ( IsCurrentAction(ActionButton_GetPagedID(button)) ) then
        button:SetChecked(1);
      else
        button:SetChecked(0);
      end
    end
  end
end)
