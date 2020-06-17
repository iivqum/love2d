local scnw = 512
local scnh = 512

local image = love.graphics.newCanvas(scnw,scnh)
local asp = scnw/scnh

local aa_samples = 10
local objects = {}

function P3D(x,y,z)
	return {x=x,y=y,z=z}
end

function PDot(a,b)
	return a.x*b.x+a.y*b.y+a.z*b.z
end

function PMul(a,b)
	return P3D(a.x*b.x,a.y*b.y,a.z*b.z)
end

function PAdd(a,b)
	return P3D(a.x+b.x,a.y+b.y,a.z+b.z)
end

function PScl(a,s)
	a.x = a.x*s
	a.y = a.y*s
	a.z = a.z*s
end

function PSub(a,b)
	return P3D(a.x-b.x,a.y-b.y,a.z-b.z)
end

function ColorPixel(x,y,r,g,b,a)
	love.graphics.setColor(r,g,b,a)
	love.graphics.points(x,y)
end

function RandFract()
	return math.random(1,10)/11
end

function RandFractSign()
	return 2*RandFract()-1
end

function RandPointInSphere()
	local theta = RandFract()*2*math.pi
	local z = RandFractSign()
	local r = math.sqrt(1-z*z)
	return P3D(r*math.cos(theta),r*math.sin(theta),z)
end

function RayHitSphere(ro,rd,o,r)
	local oc = PSub(ro,o)
	local a = PDot(rd,rd)
	local b = 2*PDot(oc,rd)
	local c = PDot(oc,oc)-r*r
	local d = b*b-4*a*c
	if d<=0 then
		return
	end
	local d2 = math.sqrt(d)
	a = 1/(2*a)
	local root = (-b-d2)*a
	if root>1e-3 then
		return root
	end
	root = (-b+d2)*a
	if root>1e-3 then
		return root
	end
end

function RayHitPlane(ro,rd,p,n)
	local denom = PDot(n,rd)
	if denom>0 or denom>-1e-3 then
		return
	end
	local t = PDot(PSub(p,ro),n)/denom
	if t<1e-3 then
		return 
	end
	return t
end

function RayPoint(ro,rd,t)
	local p = P3D(rd.x,rd.y,rd.z)
	PScl(p,t)
	return PAdd(p,ro)
end

function AddPlane(x,y,z,nx,ny,nz,material)
	table.insert(objects, {
		p = P3D(x,y,z),
		n = P3D(nx,ny,nz),
		material = material,
		HitFunc = function(self,ro,rd)
			return RayHitPlane(ro,rd,self.p,self.n)
		end,
		GetNormal = function(self)
			return self.n
		end
	})
end

function AddSphere(x,y,z,radius,material)
	table.insert(objects, {
		p = P3D(x,y,z),
		r = radius,
		material = material,
		HitFunc = function(self,ro,rd)
			return RayHitSphere(ro,rd,self.p,self.r)
		end,
		GetNormal = function(self,p)
			local n = PSub(p,self.p)
			PScl(n,1/self.r)
			return n
		end
	})
end

function Ray(ro,rd,depth)
	if depth<=0 then
		return P3D(0,0,0)
	end
	local d = math.huge
	local hit
	for k,obj in pairs(objects) do
		local t = obj:HitFunc(ro,rd)
		if t and t<d then
			d = t
			hit = obj
		end
	end
	if hit then
		local p = RayPoint(ro,rd,d)
		local dir = hit.material:Scatter(rd,p,hit:GetNormal(p))
		if not dir then
			return P3D(0,0,0)
		end
		return PMul(Ray(p,dir,depth-1),hit.material.albedo)
	end
	return P3D(1,1,1)
end

function Reflect(v,n)
	local a = P3D(n.x,n.y,n.z)
	PScl(a,2*PDot(v,n))
	return PSub(v,a)
end

function Lambertian(r,g,b)
	return {
		albedo = P3D(r,g,b),
		Scatter = function(self,rd,p,n)
			local d = RandPointInSphere()
			local s = PAdd(p,PAdd(n,d))
			local dir = PSub(s,p)
			if PDot(dir,n)>0 then
				return dir
			end			
		end
	}
end

function Metallic(r,g,b)
	return {
		albedo = P3D(r,g,b),
		Scatter = function(self,rd,p,n)
			local dir = Reflect(rd,n)
			if PDot(dir,n)>0 then
				return dir
			end			
		end
	}	
end

AddSphere(0,0,-40,10,Metallic(0.85,0.85,0.85))
AddSphere(-20,0,-30,10,Lambertian(0.85,0.85,0.85))
AddSphere(20,0,-30,10,Lambertian(0.85,0.85,0.85))
AddPlane(0,-10,0,0,1,0,Lambertian(0.85,0.85,0.85))

love.window.setMode(scnw,scnh)
love.graphics.setCanvas(image)

local rayorigin = P3D(0,0,0)
local raydir = P3D(0,0,0)

function Clamp(n,min,max)
	if n<min then
		return min
	elseif n>max then
		return max
	end
	return n
end

for i=0,scnw-1 do
for j=0,scnh-1 do
	local color = P3D(0,0,0)
	for k=1,aa_samples do
		local u = (2*((i+RandFract())/(scnw-1))-1)*asp
		local v = -(2*((j+RandFract())/(scnh-1))-1)
		raydir.x = u
		raydir.y = v
		raydir.z = -1
		color = PAdd(color,Ray(rayorigin,raydir,50))
	end
	PScl(color,1/aa_samples)
	ColorPixel(i,j,Clamp(math.sqrt(color.x),0,1),Clamp(math.sqrt(color.y),0,1),Clamp(math.sqrt(color.z),0,1))
end
end

love.graphics.reset()

function love.draw()
	love.graphics.draw(image)
end
