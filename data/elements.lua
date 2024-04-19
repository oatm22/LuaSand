local Element = require("modules.element")
local Behaviours = require("data.behaviours")

return {
    Element.new("Air", 0x000000, {}, nil, {}),
    Element.new("Sand", 0xEEDD11, {Flameable = true, Weight = 3}, nil, {Behaviours.Powder}),
    Element.new("Rock", 0x444444, {Weight = 30}, nil, {Behaviours.Powder}),
    Element.new("Water", 0x1111EE, {}, nil, {Behaviours.Liquid}),
    Element.new("Brick", 0x991111, {}, nil, {}),
    Element.new("Bird", 0x352b1a, {Flameable = true}, nil, {Behaviours.Gas}),
    Element.new("Cloner", 0xDD9911, {}, function (self, scene, x, y)
        if (self.X1) ~= nil then
            if (self.X1 ~= self.Element) then
                scene:PlaceParticle(x, y+1, self.X1)
            end
        end
    end, {})
}
