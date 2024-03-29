local Unlocker, awful, project = ...
local resto = project.druid.resto
local player, target, focus, healer = awful.player, awful.target, awful.focus, awful.healer
local party1, party2, party3, party4 = awful.party1, awful.party2, awful.party3, awful.party4
local fullGroup = awful.fullGroup
local Spell = awful.Spell

awful.Populate({
--## Cooldowns ##
    Rebirth = Spell(20484, {beneficial = true, castByID = true}),
    Natswift = Spell(132158, {beneficial = true, castByID = true}),
   -- Flourish = Spell(197721, {beneficial = true, castByID = true}),
   -- Incarn = Spell(33891, {beneficial = true, castByID = true}),
   -- Renewal = Spell(108238, {beneficial = true, castByID = true}),
   -- Innervate = Spell(29166, {beneficial = true, castByID = true}),
--## defensives ##
    Ironbark = Spell(102342, {beneficial = true, castByID = true}),
    Barkskin = Spell(22812, {beneficial = true, castByID = true}),
--## Dispell ##
    Natcure = Spell(88423,{beneficial = true, castByID = true}),
--## Buff's ##
    MarkOfWild = Spell(1126, {beneficial = true, castByID = true}),
--## AoE Heals ##
    WildGrowth = Spell(48438, {heal = true, castByID = true}),
    Tranq = Spell(740, {heal = true, castByID = true}),
    Efflore = Spell(145205, {heal = true, radius = 10, AoE = true, castByID = true}),
--## HoT Heals ##
    Lifebloom  = Spell(33763, {heal = true, castByID = true}),
    Rejuvenation = Spell(774, {heal = true, castByID = true}),
--## Regular heals ##
    Regrowth = Spell(8936, {heal = true, castByID = true}),
    Swiftmend = Spell(18562, {heal = true, castByID = true}),
--## Damage Abilities ##
    Moonfire = awful.Spell(8921, {castByID = true, ranged = true}),
    Sunfire = awful.Spell(93402, {castByID = true, ranged = true}),
    Wrath = awful.Spell(5176, {castByID = true, ranged = true}),
    Starsurge = awful.Spell(197626, {castByID = true, ranged = true}),
    Starfire = awful.Spell(197628, {castByID = true, ranged = true}),

}, resto, getfenv(1))

--## HoT's ##

Rejuvenation:Callback(function(spell)
    if spell:Castable(project.Lowest) then
        if project.Lowest.buff(spell.id) then return end
        if project.Lowest.hp < 90 then
            if spell:Cast(project.Lowest) then
                return true
            end
        end
    end
end)

Lifebloom:Callback(function(spell)
    if spell:Castable(project.Lowest) then
        if project.Lowest.hp < 95 and not project.Lowest.buff(spell.id) then
            if spell:Cast(project.Lowest) then
                return true
            end
        end
    end
end)

--## Regular HEALS ##

Regrowth:Callback(function(spell)
    if spell:Castable(project.Lowest) and project.Lowest.hp < 70 then
        return spell:Cast(project.Lowest)
    end
end)

Swiftmend:Callback(function(spell)
    if spell:Castable(project.Lowest) and project.Lowest.buff(774) and project.Lowest.hp < 55 then
        return spell:Cast(project.Lowest)
    end
end)


--## Cooldowns ##

Rebirth:Callback(function(spell)
    if awful.tank.dead and spell:Castable(awful.tank) then 
        return spell:Cast(awful.tank)
    end
end)

Natswift:Callback(function(spell)
    if project.Lowest.hp < 65 and spell:Castable(project.Lowest) then 
        return spell:Cast(project.Lowest)
    end
end)

--## AoE ## 

local function tranqHit(obj)
    return obj.hp < 80 
end

local tranqready = fullGroup.around(player, 40, tranqHit)

Tranq:Callback(function(spell)
    if not spell:Castable() then return end
    if tranqready >= 3 then
        return spell:Cast()
    end
end)

local function WildGrowthHit(obj)
    return obj.hp < 90 
end

local WildGrowthready = fullGroup.around(project.Lowest, 30, WildGrowthHit)

WildGrowth:Callback(function(spell)
    if not spell:Castable(project.Lowest) then return end
    if WildGrowthready >= 2 then
        return spell:Cast(project.Lowest)
    end
end)

Efflore:Callback(function(spell)
    if player.buff(spell.id) then return end
    if spell:Castable(awful.tank) and awful.tank.hp < 85 then 
        return spell:SmartAoE(awful.tank)
    end
end)

--## Defensive's ##

Ironbark:Callback(function(spell)
    if tank.buff(spell.id) then return end
    if spell:Castable(awful.tank) and awful.tank.hp < 65 then 
        return spell:Cast(awful.tank)
    end
end)

Barkskin:Callback(function(spell)
    if player.buff(spell.id) then return end
    if spell:Castable(player) and player.hp < 60 then 
        return spell:Cast(player)
    end
end)

--## BUFF ##

MarkOfWild:Callback(function(spell)
    awful.group.loop(function(player)
        if not player.buff(spell.id) and spell:Castable(player) then
            return spell:Cast(player)
        end
    end)
end)

local debuffsToCheck = {

    413544,
    164965,
    405696,
    413607,
    265881,
    412378,
    265880,
    200182,
    76820,
    418200,
    198904,
    427376,
    416716,
    225908,
    264390,
    255041,
    427459,
    260702

}

local function hasDebuff()
    for _, debuffID in ipairs(debuffsToCheck) do
        if player.debuff(debuffID) then
            return true
        end
    end
    return false
end


Natcure:Callback(function(spell)
    awful.fullGroup.loop(function(member)
        if hasDebuff(member) and spell:Castable(member) then
            return spell:Cast(member)
        end
    end)
end)


--## DAMAGE ABILITIES ##

Moonfire:Callback(function(spell)
    if target.Combat then
        awful.enemies.loop(function(unit)
            if spell:Castable(unit) and not unit.debuff(164812) and unit.Combat then
                return spell:Cast(unit)
            end
        end)
    end
end)

Sunfire:Callback(function(spell)
    if target.Combat then
        awful.enemies.loop(function(unit)
            if spell:Castable(unit) and not unit.debuff(164815) and unit.Combat then
                return spell:Cast(unit)
            end
        end)
    end
end)

Wrath:Callback(function(spell)
    if spell:Castable(target) and target.Combat then
        spell:Cast(target)
    end
end)

Starsurge:Callback(function(spell)
    if spell:Castable(target) and target.Combat then
        spell:Cast(target)
    end
end)
    
Starfire:Callback(function(spell)
    if spell:Castable(target) then
        if target.Combat then
            if awful.enemies.around(target, 5) >= 3 then
                spell:Cast(target)
            end
        end
    end
end)
