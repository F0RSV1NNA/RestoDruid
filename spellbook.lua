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
    --Natcure = Spell(88423,{beneficial = true, castByID = true}),
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
    if project.Lowest.hp < 95 then
    if project.Lowest.buff(spell.id) then return end
    if spell:Castable(project.Lowest) then 
        if spell:Cast(project.Lowest) then
            return true
            end
        end
    end
end)

Lifebloom:Callback(function(spell)
    if project.Lowest.hp < 90 then
    if project.Lowest.buff(spell.id) then return end
    if spell:Castable(project.Lowest) then 
        if spell:Cast(project.Lowest) then
            return true
            end
        end
    end
end)

--## Regular HEALS ##

Regrowth:Callback(function(spell)
    if spell:Castable(project.Lowest) then
        if project.Lowest.hp < 70 then
            return spell:Cast(project.Lowest)
        end
    end
end)

Swiftmend:Callback(function(spell)
    if project.Lowest.hp < 55 then
        if project.Lowest.buff(774) then
            if spell:Castable(project.Lowest) then
                if spell:Cast(project.Lowest) then
                    return true
                end
            end
        end
    end
end)


--## Cooldowns ##

Rebirth:Callback(function(spell)
    if awful.tank.dead then
        if spell:Castable(awful.tank) then 
            if spell:Cast(awful.tank) then
                return true
            end
        end
    end
end)

Natswift:Callback(function(spell)
    if project.Lowest.hp < 65 and spell:Castable(project.Lowest) then 
        return spell:Cast(project.Lowest)
    end
end)

--## AoE ## 

local function tranqHit(obj)
    return obj.hp < 50 
end

local tranqready = fullGroup.around(player, 40, tranqHit)

Tranq:Callback(function(spell)
    if not spell:Castable() then return end
    if tranqready < 3 then
        return spell:Cast()
    end
end)

local function WildGrowthHit(obj)
    return obj.hp < 70 
end

local WildGrowthready = fullGroup.around(project.Lowest, 10, WildGrowthHit)

WildGrowth:Callback(function(spell)
    if not spell:Castable(project.Lowest) then return end
    if WildGrowthready < 3 then
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
        if not player.buff(spell.id) and spell:Castable() then
            return spell:Cast()
        end
    end)
end)

-- Natcure:Callback(function(spell)
--     awful.fullGroup.loop(function(member)
--         if member:DebuffType("Disease") then
--             if spell:Castable(member) then
--                 if spell:Cast(member) then
--                     return true
--                 end
--             end
--         end
--     end)
-- end)

--## DAMAGE ABILITIES ##

Moonfire:Callback(function(spell)
    if target.Combat then
        awful.enemies.loop(function(unit, i, uptime)
            if not spell:Castable(unit) then return end
            if unit.debuff(164812) then return end
            if spell:Cast(unit) then
                return true
            end
        end)
    end
end)

Sunfire:Callback(function(spell)
    if target.Combat then
        awful.enemies.loop(function(unit, i, uptime)
            if not spell:Castable(unit) then return end
            if unit.debuff(164815) then return end
            if spell:Cast(unit) then
                return true
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
