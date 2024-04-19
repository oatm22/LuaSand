SDL = require("SDL")
Elements= require("data.elements")
Scene = require("modules.scene")

mouseX = 0
mouseY = 0
selectedElement = 1

fps = 0
frame = 0
lastFrame = 0
fpsTimer = 0
running = true

SDL.init(SDL.flags.Video)

window = SDL.createWindow{
    title = "LuaSand",
    width = 720,
    height = 720,
    flags = {}
}
renderer = SDL.createRenderer(window, 0, 0)

mainScene = Scene.new(80, 80)
renderer:setLogicalSize(mainScene.SizeX, mainScene.SizeY);

SDL.setRelativeMouseMode(true)

function math.clamp (v, min, max)
    if (v < min) then
        return min
    elseif (v > max) then
        return max
    else
        return v
    end
end

while running do
    renderer:present()

    frame = frame + 1
    deltaTime = os.clock() - lastFrame

    fpsTimer = fpsTimer + deltaTime

    if (fpsTimer >= 1) then
        fpsTimer = 0
        frame = 0
    end
    fps = frame / fpsTimer
    print(fps)

    lastFrame = os.clock()

    for event in SDL.pollEvent() do
        if (event.type == SDL.event.Quit) then
            running = false
        elseif (event.type == SDL.event.MouseMotion) then
            mouseX = math.clamp(event.x, 0, mainScene.SizeX-1)
            mouseY = math.clamp(event.y, 0, mainScene.SizeY-1)
        elseif (event.type == SDL.event.MouseWheel) then
            selectedElement = math.clamp(selectedElement + event.y, 1, #Elements)
        end
    end

    mainScene:Simulate(frame)
    mainScene:Render(renderer)

    renderer:setDrawColor(Elements[selectedElement].Color)
    renderer:drawPoint({x=mouseX, y=mouseY})

    if (mouseX > 0 and mouseY > 0) then
        if (SDL.getMouseState()[SDL.mouseMask.Left]) then
            if (mainScene.Matrix[mouseX+1][mouseY+1].Element == Elements[1]) then
                mainScene:PlaceParticle(mouseX+1, mouseY+1, Elements[selectedElement])
            else
                mainScene.Matrix[mouseX+1][mouseY+1].X1 = Elements[selectedElement]
            end
        elseif (SDL.getMouseState()[SDL.mouseMask.Right]) then
            mainScene.Matrix[mouseX+1][mouseY+1].Element = Elements[1]
        end
    end
end

SDL.quit()
