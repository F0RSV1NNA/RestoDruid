
local debuffsToCheck = {
    12345,
    123456,

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
    if hasDebuff() then
        spell:Cast()
    end
end)
