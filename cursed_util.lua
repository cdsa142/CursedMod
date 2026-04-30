local function addUtils(util)
    print("adding utils")
    util.roundVal = function(val)
        local trueExponent = math.log10(math.abs(val))
        local exponent = trueExponent - trueExponent % 3
        return math.floor(val / (10^exponent)) * 10^exponent
    end

    util.getValueString = function(val)
        if val < 1000 then
            return val .. ""
        elseif val < 1000000 then
            return (util.roundVal(val) / 1000) .. "k"
        elseif val < 1000000000 then
            return (util.roundVal(val) / 1000000) .. "M"
        else
            return (util.roundVal(val) / 1000000000) .. "G"
        end
    end
end