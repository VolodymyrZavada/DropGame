local love = require 'love'
local Drop = require 'Drop'
local Bucket = require 'Bucket'
local Button = require 'Button'

-- global
font = love.graphics.newFont("fonts/EvilEmpire-4BBVK.ttf", 45)
windowW = love.graphics.getWidth()
windowH = love.graphics.getHeight()

local drawColliderBox = false

local droplets = {}
local bucket = nil
local button = nil

local score = 0
local highScore = 0
local timer = 1
local lives = 3
local gameStarted = false

function love.load()
    math.randomseed(os.time())

    love.graphics.setFont( font )

    bucket = Bucket:new((windowW / 2) - 32, windowH - 80, drawColliderBox)
    button = Button:new("PLAY", 200, 60)
end

function love.draw()
    love.graphics.setBackgroundColor(.4, .2, .1, .2)

    if not gameStarted then

        if highScore > 0 then
            local gameOverText = "Game Over!"
            local gameOverWidth = font:getWidth(gameOverText)
            love.graphics.print(gameOverText, windowW / 2 - gameOverWidth / 2, 10)
            love.graphics.printf("High Score: " .. highScore, 0, font:getHeight(), windowW, "center")
        end

        button:draw()
    end

    if gameStarted then
        bucket:draw()
        for k, droplet in pairs(droplets) do
            droplet:draw()
        end
        love.graphics.printf("Score: " .. score, 0, font:getHeight(), windowW, "center")
        love.graphics.printf("Lives: " .. lives, 10, font:getHeight(), windowW, "left")
    end
end

function love.update(dt)
    button:update(dt)

    if button.clicked then
        gameStarted = true
    end

    if gameStarted and lives > 0 then
        bucket:keyPressed()

        timer = timer - dt
        if timer < 0 then
            timer = 1

            local positionX = math.random(0, windowW - 64)
            table.insert(droplets, Drop:new(positionX, 0, drawColliderBox))
        end

        if #droplets > 0 then
            for k, droplet in pairs(droplets) do
                droplet:update(dt)
            end
        end

        -- check collision
        bb = bucket.bounces
        for k, droplet in pairs(droplets) do
            if not droplet.collided then
                db = droplet.bounces
                local isCollision = checkCollision(bb.x, bb.y, bb.width, bb.height, db.x, db.y, db.width, db.height)
                if isCollision then
                    score = score + 1
                    droplets[k].collided = true

                    if highScore < score then
                        highScore = score
                    end
                end
            end
        end

        -- decrease lives
        for k, droplet in pairs(droplets) do
            if droplet.offScreen then
                lives = lives - 1
            end
        end

        -- remove collided droplets
        for k, droplet in pairs(droplets) do
            if droplet.collided then
                table.remove(droplets, k)
            end
        end
    else
        gameStarted = false
        button.clicked = false
        lives = 3

        score = 0

        bucket.x = (windowW / 2) - 32
        bucket.y = windowH - 80

        -- remove all droplets
        for k, droplet in pairs(droplets) do
            table.remove(droplets, k)
        end
    end
end

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
            x2 < x1 + w1 and
            y1 < y2 + h2 and
            y2 < y1 + h1
end