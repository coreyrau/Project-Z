debug = true

local function scaleX()
  return love.graphics.getWidth() / background:getWidth()
end

local function scaleY()
  return love.graphics.getHeight() / background:getHeight()
end

function load()
  background = love.graphics.newImage('assets/MainMenu.png')
  imgStartOn = love.graphics.newImage('assets/menuOnStart.png')
  imgStartOff = love.graphics.newImage('assets/menuOffStart.png')
  imgExitOn = love.graphics.newImage('assets/menuOnExit.png')
  imgExitOff = love.graphics.newImage('assets/menuOffExit.png')

  buttons = { {On = imgStartOn, Off = imgStartOff, x =(500*scaleX()), y = ((400 - imgStartOn:getHeight()) *scaleY()), w = imgStartOn:getWidth(), h = imgStartOn:getHeight(), action = "play"},
              {On = imgExitOn, Off = imgExitOff, x =(500*scaleX()), y = ((400 + imgExitOn:getHeight()) *scaleY()), w = imgExitOn:getWidth(), h = imgExitOn:getHeight(), action = "exit"}
            }
end

local function drawButtons(off, on, x, y, w, h, mx, my)
  local insert = onButton(mx, my, x - (w/2), y - (h/2), w, h)
  love.graphics.setColor(255, 255, 255, 255)

  if insert then
    love.graphics. draw(on, x, y, 0, 1, 1, (w/2), (h/2))
  else
    love.graphics. draw(off, x, y, 0, 1, 1, (w/2), (h/2))
  end
end

function onButton(px, py, x, y, wx, wy)
  if px > x and px < x+wx then
    if py > y and py < y+wy then
      return true
    end
  end
  return false
end

function love.mousepressed(x, y, button)
  if button == 1 then
    for i, j in pairs(buttons) do
      local insert = onButton(x, y, j.x - (j.w/2), j.y - (j.h/2), j.w, j.h)
      if insert then
        if j.action == "play" then
          Run("ProjectZ")
        elseif j.action == "exit" then
          love.event.push('quit')
        end
      end
    end
  end
end


function love.update(dt)
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end
end

function love.load(arg)
  love.window.setFullscreen(true, "desktop")
end

function love.draw(dt)
  local x = love.mouse.getX()
  local y = love.mouse.getY()
  local sx = love.graphics.getWidth() / background:getWidth()
  local sy = love.graphics.getHeight() / background:getHeight()
  love.graphics.draw(background,0,0,0,sx,sy)
  love.graphics.setColor(0,0,0)
  love.graphics.setNewFont('assets/computer.ttf', (20*scaleY()))
  love.graphics.setColor(255,255,255)
  for i, j in pairs(buttons) do
    drawButtons(j.Off, j.On, j.x, j.y, j.w, j.h, x, y)
  end
end
