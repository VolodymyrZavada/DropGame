local love = require 'love'
local Bucket = {}

function Bucket.new(self, x, y, showCollider)
    local texture = love.graphics.newImage('assets/bucket.png')

    local obj = {
        x = x or 0,
        y = y or 0,
        texture = texture,
        showCollider = showCollider or false,
        bounces = {
            x = x,
            y = y + 15,
            width = texture:getWidth(),
            height = texture:getHeight() - 15
        }
    }
    setmetatable(obj, { __index = Bucket })
    return obj
end

function Bucket.draw(self)
    if self.showCollider then
        love.graphics.rectangle('line', self.bounces.x, self.bounces.y, self.bounces.width, self.bounces.height)
    end

    love.graphics.draw(self.texture, self.x, self.y)
end

function Bucket.keyPressed(self)
    local isRight = love.keyboard.isDown( 'right' )
    local isLeft = love.keyboard.isDown( 'left' )

    if isRight then
        if self.x < love.graphics.getWidth() - self.bounces.width then
            self.x = self.x + 5
            self.bounces.x = self.x
        end
    end

    if isLeft then
        if self.x > 0 then
            self.x = self.x - 5
            self.bounces.x = self.x
        end
    end
end

return Bucket