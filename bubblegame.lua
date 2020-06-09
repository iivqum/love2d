local bubble_rad = 32
local bubble_amount = 8
local bubble_speed = 32
local bubbles = {}

local window_width = 512
local window_height = 512

local score = 0
local clk = 0

math.randomseed(os.time())
function PickRandomSign()
	return ({-1,1})[math.random(1,2)]
end

function BubbleDie(b)
	b.dx = PickRandomSign()
	b.dy = PickRandomSign()
	b.dead = false
	if b.dx==-1 then 
		b.x = math.random(window_width*0.5, window_width) 
	else
		b.x = math.random(0, window_width*0.5)	
	end
	if b.dy==-1 then b.y = window_height+bubble_rad else b.y = -bubble_rad end
end

function BubbleMove(b,dt)
	b.x = b.x+b.dx*bubble_speed*dt
	b.y = b.y+b.dy*bubble_speed*dt
	if b.dx==-1 and b.x+bubble_rad <= 0 then BubbleDie(b)
	elseif b.x-bubble_rad>=window_width then BubbleDie(b) end
	if b.dy==-1 and b.y+bubble_rad <= 0 then BubbleDie(b) 
	elseif b.y-bubble_rad>=window_height then BubbleDie(b) end
end

function BubbleCheckPoint(b,x,y)
	local dx = b.x-x
	local dy = b.y-y
	local dsqr = dx*dx+dy*dy
	if dsqr <= bubble_rad*bubble_rad then
		return true
	end
	return false
end

function BubbleDraw(b)
	love.graphics.circle("line", b.x, b.y, bubble_rad)
end

function love.load()
	for i=1,bubble_amount do
		bubbles[i] = {
			dead = true,
			x = 0, y = 0,
			dx = 1, dy = 1
		}
	end
	love.window.setMode(window_width, window_height)
	love.window.setVSync(0)
end

function love.mousepressed(x,y,c)
	if c~=1 then
	return end
	for i=1,bubble_amount do
		local bub = bubbles[i]
		if bub.dead==false and BubbleCheckPoint(bub,x,y) then
			BubbleDie(bub)
			score = score + 1
			return
		end
	end
end

function love.draw()
	local dt = os.clock()-clk
	clk = os.clock()
	for i=1,bubble_amount do
		local bub = bubbles[i]
		if bub.dead then
			BubbleDie(bub)
		else
			BubbleMove(bub, dt)
			BubbleDraw(bub)
		end
	end
	love.graphics.print("Score: "..score, 0, 0)
end