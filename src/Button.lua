local love = require 'love'
local Button = {}

function Button.new(self, text, width, height)
    local obj = {
        text = text or "Default",
        x = 0,
        y = 0,
        width = width or 100,
        height = height or 100,
        clicked = false,
        isHover = false,
        colors = {
            default = {
                button = {0, .7, .6, .4},
                text = {.9, 1, .1, 1}
            },
            hover = {
                button = {.7, .8, .2, .4},
                text = {.8, .4, .1, 1}
            }
        },
        bounces = {
            x = x,
            y = y,
            width = width,
            height = height
        }
    }
    setmetatable(obj, { __index = Button })
    return obj
end

function Button.draw(self)
    if self.isHover then
        love.graphics.setColor(unpack(self.colors.hover.button))
    else
        love.graphics.setColor(unpack(self.colors.default.button))
    end
    -- use global "windowW" and "windowH"
    local bPosX = windowW / 2 - self.width / 2
    local bPosY = windowH / 2 - self.height / 2
    love.graphics.rectangle('fill', bPosX, bPosY, self.width, self.height, 20, 20)

    if self.isHover then
        love.graphics.setColor(unpack(self.colors.hover.text))
    else
        love.graphics.setColor(unpack(self.colors.default.text))
    end

    -- use global "font"
    local textWidth = font:getWidth(self.text)
    local textHeight = font:getHeight(self.text)

    local posX = bPosX + self.width / 2 - textWidth / 2
    local posY = bPosY + self.height / 2 - textHeight / 2 + 4
    love.graphics.print(self.text, posX, posY)
    love.graphics.setColor(1, 1, 1, 1)

    -- Update object x and y
    self.x = bPosX
    self.y = bPosY
end

function Button.update(self, dt)
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    if checkPointToRectangleCollision(mouseX, mouseY, self.x, self.y, self.width, self.height) then
        self.isHover = true

        local clicked = love.mouse.isDown(1)
        if clicked then
            self.clicked = true
        end
    else
        self.isHover = false
        self.clicked = false
    end
end

function checkPointToRectangleCollision(mX, mY, rX, rY, rW, rH)
    return mX >= rX and mX <= rX + rW and mY >= rY and mY <= rY + rH
end

return Button