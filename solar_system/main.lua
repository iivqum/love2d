require("vector")
require("system")

love.window.setMode(512,512)

function love.mousemoved(x,y,dx,dy)
	if love.mouse.isDown(1) then
		SysScreenDelta(-dx,dy)
	end
end

function love.wheelmoved(x,y)
	SysScaleDelta(y*0.1)
end

function love.update(dt)
	SysUpdatePlanets(dt)
end

function love.draw()
	SysDrawPlanets()
end