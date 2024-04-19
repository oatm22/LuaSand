local Elements = require("data.elements")
local Particle = require("modules.particle")

local Scene = {}
Scene.__index = Scene

function Scene.new (sizeX, sizeY)
    local self = {}

    self.SizeX = sizeX
    self.SizeY = sizeY
    self.Matrix = {}

    for x = 1, self.SizeX do
        self.Matrix[x] = {}

        for y = 1, self.SizeY do
            self.Matrix[x][y] = Particle.new(Elements[1])
        end
    end

    return setmetatable(self, Scene)
end

function Scene:Render (renderer)
    renderer:setDrawColor(0x000000)
    renderer:clear()

    for x = 1, self.SizeX do
        for y = 1, self.SizeY do
            local particle = self.Matrix[x][y]

            renderer:setDrawColor(particle.RenderColor ~= 0x000000 and particle.RenderColor or particle.Element.Color)
            renderer:drawPoint({x = x-1, y = y-1})
        end
    end
end

function Scene:PlaceParticle (x, y, element)
    self.Matrix[x][y].Element = element
    self.Matrix[x][y].Lifetime = 0
end

function Scene:DestroyParticle (x, y)
    self.Matrix[x][y].Element = Elements[1]
end

function Scene:GetParticle (x, y)
    return self.Matrix[x][y]
end

function Scene:IsAir (x, y)
    if (x > 0 and y > 0 and x <= self.SizeX and y <= self.SizeY) then
        if (self.Matrix[x][y]) then
            return self.Matrix[x][y].Element == Elements[1]
        else
            return nil
        end
    else
        return nil
    end
end

function Scene:Simulate (frame)
    for x = 1, self.SizeX do
        for y = 1, self.SizeY do
            local particle = self.Matrix[x][y]

            if (particle.Frame ~= frame) then
                particle.Frame = frame

                for i in pairs(particle.Element.Behaviours) do
                    particle.Element.Behaviours[i](particle, self, x, y)
                end

                if (particle.Element.Step) then
                    particle.Element.Step(particle, self, x, y)
                end

                nextX = x + particle.VX
                nextY = y + particle.VY

                if (nextX < self.SizeX and nextY < self.SizeY and nextX > 0 and nextY > 0) then
                    if (nextX ~= x or nextY ~= y) and (self:IsAir(nextX, nextY)) then
                        self.Matrix[nextX][nextY] = particle
                        self.Matrix[x][y] = Particle.new(Elements[1])
                    end
                else
                    self.Matrix[x][y] = Particle.new(Elements[1])
                end

                particle.Lifetime = particle.Lifetime + 1
            end
        end
    end
end

return Scene
