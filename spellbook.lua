local Unlocker, awful, project = ...
local resto = project.druid.resto
local player, target = awful.player, awful.target
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
    --Ironbark = Spell(102342, {beneficial = true, castByID = true}),
   -- Barkskin = Spell(22812, {beneficial = true, castByID = true}),
--## Dispell ##
    --Natcure = Spell(88423,{beneficial = true, castByID = true}),
--## Buff's ##
    MarkOfWild = Spell(1126, {beneficial = true, castByID = true}),
--## AoE Heals ##
    WildGrowth = Spell(48438, {heal = true, AoE = true, castByID = true}),
    --Tranq = Spell(740, {heal = true, castByID = true}),
    Efflore = Spell(145205, {heal = true, AoE = true, castByID = true}),
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

--## AoE Heals ##

Efflore:Callback(function(spell)
    if awful.party.members:Count(function(member) return member.hp < 80 end) > 2 then
        if player.buff(spell.id) then return end
        if spell:Castable() then
            return spell:SmartAoE(awful.player)
        end
    end
end)

WildGrowth:Callback(function(spell)
    if awful.party.members:Count(function(member) return member.hp < 70 end) > 2 then
        if spell:Castable() then
            return spell:cast()
        end
    end
end)

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
        if player.Buff(16870) or project.Lowest.hp < 75 then -- clearcast
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

--## BUFF ##

MarkOfWild:Callback(function(spell)
    awful.group.loop(function(player)
        if not player.buff(spell.id) then
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
