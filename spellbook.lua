local Unlocker, awful, project = ...
local resto = project.druid.resto
local player, target = awful.player, awful.target
local Spell = awful.Spell

awful.Populate({
--## Cooldowns ##
    Natswift = Spell(132158,{beneficial = true, castByID = true}),
--## Buff's ##
    MarkOfWild = Spell(1126,{beneficial = true, castByID = true}),
--## AoE Heals ##
    WildGrowth = Spell(48438, {heal = true, AoE = true, castByID = true}),
--## HoT Heals ##
    Lifebloom  = Spell(33763, {heal = true, castByID = true}),
    Rejuvenation = Spell(774, {heal = true, castByID = true}),
--## Regular heals ##
    Regrowth = Spell(8936, {heal = true, castByID = true}),
    Swiftmend = Spell(18562, {heal = true, castByID = true}),
--## Damage Abilities ##
    Moonfire = awful.Spell(8921,{castByID = true, ranged = true}),
    Wrath = awful.Spell(5176,{castByID = true, ranged = true}),

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
    if player.buff(16870) then --clearcast
        return spell:Cast(project.Lowest)
    elseif project.Lowest.hp < 70 then
        return spell:Cast(project.Lowest)
    end
end)

--## Cooldowns ##

Natswift:Callback(function(spell)
    if project.Lowest.hp < 45 then
    if spell:Castable() then 
        if spell:Cast() then
            return true
            end
        end
    end
end)

--## BUFFS ##

MarkOfWild:Callback(function(spell)
    awful.group.loop(function(player)
        if not player.buff(spell.id) then
            return spell:Cast()
        end
    end)
end)



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

Wrath:Callback(function(spell)
    if target.Combat then
        spell:Cast(target)
    end
end)