local Unlocker, awful, project = ...
local settings = project.settings
local player, target = awful.player, awful.target

if awful.player.spec ~= "Restoration" then return end

awful.DevMode = true

project.druid = {}
project.druid.resto = awful.Actor:New({ spec = 4, class = "druid" })
local druid = project.druid.resto

project.Lowest = awful.player

local function SetLowest()
    local function filter(unit) return unit.distance < 40 and unit.los end
    local lowest = awful.fullGroup.filter(filter).lowest 
    if lowest then
        project.Lowest = lowest
    else
        project.Lowest = awful.player
    end
end


print("[|cffFF6B33Zmizet|r PvE |cff3FC7EBResto|r]")

druid:Init(function()
  if player.mounted then return end 

  SetLowest()
  Rebirth()
  MarkOfWild()
  Natswift()

  if settings.DMG then
    Regrowth()
    Rejuvenation()
    Lifebloom()
    Swiftmend()
    Natcure()
    if target.enemy then
        Moonfire()
        Starfire()
        Wrath()
    end
end
    if not settings.DMG then
        Regrowth()
        Rejuvenation()
        Lifebloom()
        Swiftmend()
        Natcure()
    end




end)

