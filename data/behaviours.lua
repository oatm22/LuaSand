return {
    ["Liquid"] = function (self, scene, x, y)
        if (self.Lifetime == 0) then
            self.RenderColor = self.Element.Color * math.random(1, 3)
        end

        if (scene:IsAir(x, y+1)) then
            self.VX = 0
            self.VY = 1
        else
            self.VY = 0
            self.VX = math.clamp(math.random(-1, 1), scene:IsAir(x-1, y) and -1 or 0, scene:IsAir(x+1, y) and 1 or 0)
        end
    end,

    ["Powder"] = function (self, scene, x, y)
        local weight = self.Element.Attributes.Weight
        self.VY = 1
        self.VX = 0

        if (self.Lifetime == 0) then
            self.RenderColor = self.Element.Color * math.random(1, 4)
        end

        if (weight > 0) then
            local dir = math.random(-weight, weight)

            if (dir == -weight) then
                self.VX = -1
            elseif (dir == weight) then
                self.VX = 1
            end
        end
    end,

    ["Gas"] = function (self, scene, x, y)
        self.VX = math.clamp(math.random(-1, 1), scene:IsAir(x-1, y) and -1 or 0, scene:IsAir(x+1, y) and 1 or 0)
        self.VY = math.clamp(math.random(-1, 1), scene:IsAir(x+self.VX, y-1) and -1 or 0, scene:IsAir(x+self.VX, y+1) and 1 or 0)
    end
}
