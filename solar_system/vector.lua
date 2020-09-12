local vectorclass={x=0,y=0}
vectorclass.__index=vectorclass

function vectorclass:__add(v)
	return Vector(self.x+v.x,self.y+v.y)
end

function vectorclass:__sub(v)
	return Vector(self.x-v.x,self.y-v.y)
end

function vectorclass:__mul(s)
	return Vector(self.x*s,self.y*s)
end

function vectorclass:Length2()
	return self.x*self.x+self.y*self.y
end

function Vector(x,y)
	return setmetatable({x=x,y=y},vectorclass)
end