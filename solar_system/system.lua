local screen_center=Vector(0,0)
--semi major axis is in AU
local planets={
	{name="Mercury",eccentricity=0.205,semi_major_axis=0.38,period=88.8},
	{name="Venus",eccentricity=0.007,semi_major_axis=0.72,period=224.7},
	{name="Earth",eccentricity=0.017,semi_major_axis=1,period=365.2},
	{name="Mars",eccentricity=0.094,semi_major_axis=1.52,period=687},
	{name="Jupiter",eccentricity=0.049,semi_major_axis=5.2,period=4331},
	{name="Saturn",eccentricity=0.057,semi_major_axis=9.55,period=10747},
	{name="Uranus",eccentricity=0.046,semi_major_axis=19.23,period=30589},
	{name="Neptune",eccentricity=0.011,semi_major_axis=30.11,period=59800},
	{name="Pluto",eccentricity=0.244,semi_major_axis=39.55,period=90650},
}
local pixels_per_au=64
local days_per_step=10
local sun_pos=Vector(0,0)
local scale=1
--elapsed time in days
local time=0

function SysScreenDelta(x,y)
	screen_center.x=screen_center.x+x/scale
	screen_center.y=screen_center.y+y/scale
end

function SysScaleDelta(s)
	scale=scale+s*scale
end

local function ScreenCoord(p)
	local width,height=love.window.getMode()
	local d=(p-screen_center)*scale
	d.y=d.y*-1
	return d+(Vector(width,height)*0.5)
end

local function EccentricAnomaly(e,t)
	return 2*math.atan(math.sqrt((1+e)/(1-e))*math.tan(t*0.5))
end

local function MeanAnomaly(e,epsilon)
	return e-epsilon*math.sin(e)
end

function SysUpdatePlanets(dt)
	time=time+dt*days_per_step
end	
	
function SysDrawPlanets()
	for k,p in pairs(planets) do
		local a=p.semi_major_axis*pixels_per_au
		local focus=p.eccentricity*a
		local b=math.sqrt(a*a-focus*focus)
		local ea=EccentricAnomaly(p.eccentricity,(2*math.pi)/p.period*time)

		local x=a*(math.cos(ea)-p.eccentricity)
		local y=b*math.sin(ea)

		local orbit=(Vector(x,y)+sun_pos)
		orbit=ScreenCoord(orbit)

		local elips_pos=Vector(sun_pos.x-focus,sun_pos.y)
		elips_pos=ScreenCoord(elips_pos)

		love.graphics.circle("fill",orbit.x,orbit.y,1*scale)
		love.graphics.ellipse("line",elips_pos.x,elips_pos.y,a*scale,b*scale)
		love.graphics.print(p.name,orbit.x,orbit.y,0,0.75,0.75)
	end

	local sun_srn=ScreenCoord(sun_pos)
	love.graphics.circle("fill",sun_srn.x,sun_srn.y,2*scale)
end