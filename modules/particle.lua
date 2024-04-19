local Particle = {}
Particle.__index = Particle

function Particle.new(element)
    local self = {}

    self.Lifetime = 0
    self.Frame = 0
    self.VX = 0
    self.VY = 0

    self.Element = element
    return setmetatable(self, Particle)
end

return Particle
