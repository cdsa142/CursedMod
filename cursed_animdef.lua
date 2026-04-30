

local function addAnimDef(animdef)
    animdef["curse_weaken"] = {
        lifetime = 1,
        draw = function(x,y,t,params)
            local a = math.min(1,1.5-math.pow(t,1.8))
            local r1 = math.pow(t,0.85)*420
            local r2 = 12+math.pow(t,1.4)*200
            local cx,cy = x+8,y+8
            love.graphics.setColor(1,1,1,a)
            love.graphics.setLineWidth(r2)
            love.graphics.ellipse("line",cx,cy,r1,r1)
        end
    }
end

