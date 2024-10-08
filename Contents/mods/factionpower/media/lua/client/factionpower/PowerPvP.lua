-- PowerPvP.lua
local utils = require 'lib/Utils'
local thefaction

local function forcePvP()
  thefaction = getSandboxOptions():getOptionByName("FactionPower.name"):getValue()
  if not isClient() then
    return
  end

  local player = getPlayer()
  local username = player:getUsername()

  print("Calling forcePvP for user: " .. tostring(username))
  local faction = utils.getFaction(username, thefaction)
  if faction then
    if getSandboxOptions():getOptionByName("FactionPower.PvPForced"):getValue() then
      local old_ISSafetyUI_prerender = ISSafetyUI.prerender
      function ISSafetyUI:prerender()
        old_ISSafetyUI_prerender(self)
        if self.character:getSafety():isEnabled() then
          self.character:getSafety():setEnabled(true)
          getPlayerSafetyUI(0):toggleSafety()
        end
        self.character:getSafety():setEnabled(false)
        self:drawTexture(self.disableTexture, 0, 0, 1, 1, 1, 1)
        self.radialIcon:setVisible(false)

        if self:isMouseOver() then
          self:drawText("DIO CANE", self.width + 10, self.height / 2, 1, 0, 0, 1, self.Small)
        end
      end
    else
      local old__old_ISSafetyUI_prerender = ISSafetyUI.prerender
      function ISSafetyUI:prerender()
        old__old_ISSafetyUI_prerender(self)
      end
    end
  end
end

local function forceDisplayName()
  thefaction = getSandboxOptions():getOptionByName("FactionPower.name"):getValue()
  if not isClient() then
    return
  end

  local player = getPlayer()
  local username = player:getUsername()

  print("Calling forceDisplayName for user: " .. tostring(username))
  local faction = utils.getFaction(username, thefaction)
  if faction then
    if getSandboxOptions():getOptionByName("FactionPower.DisplayName"):getValue() then
      player:setHaloNote(username, 0, 255, 0, 4000)
    end
  end
end

local function checkPowers()
  forcePvP()
  forceDisplayName()
end

Events.OnGameStart.Add(checkPowers)
Events.EveryTenMinutes.Add(checkPowers)
