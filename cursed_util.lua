local function addUtils(util)
    print("adding utils")
    util.roundVal = function(val)
        local trueExponent = math.floor(math.log10(math.abs(val)))
        local exponent = 10^(trueExponent - trueExponent % 3)
        return math.floor(val / (10^exponent)) * 10^exponent
    end
end
