local Element = {}
Element.__index = Element

function Element.new (name, color, attributes, stepFunction, behaviours)
    local self = {}

    self.Attributes = attributes
    self.Behaviours = behaviours
    self.Step = stepFunction
    self.Name = name
    self.Color = color

    self.X1 = nil
    self.X2 = nil
    self.X3 = nil
    self.X4 = nil

    return setmetatable(self, Element)
end

return Element
