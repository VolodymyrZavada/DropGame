local love = require 'love'
local Drop = {}

function Drop.new(self, x, y, showCollider)
    local texture = love.graphics.newImage('assets/droplet.png')

    local obj = {
        x = x or 0,
        y = y or 0,
        texture = texture,
        collided = false,
        offScreen = false,
        showCollider = showCollider or false,
        bounces = {
            x = x,
            y = y,
            width = texture:getWidth(),
            height = texture:getHeight()
        }
    }
    setmetatable(obj, { __index = Drop })
    return obj
end

function Drop.draw(self)
    if self.showCollider then
        love.graphics.rectangle('line', self.bounces.x, self.bounces.y, self.bounces.width, self.bounces.height)
    end

    love.graphics.draw(self.texture, self.x, self.y)
end

function Drop.update(self, dt)
    self.y = self.y + 200 * dt
    self.bounces.y = self.y

    if self.y > windowH then
        self.offScreen = true
        self.collided = true
    end
end

return Drop