debug = true

playerSpeed = 200
canShoot = true
canShootTimerMax = 0.5
canShootTimer = canShootTimerMax

-- bullets
bulletImg = nil
bulletSpeed = 200
spread = nil
fire = 1
shock = nil
nova = nil
blast = nil
bullets = {}
speedBulletTime = 5
randBulletTime = 0
createBulletTimer = randBulletTime

currWeapon = nil
infAmmo = true
currAmmo = 0

hasArmor = false

-- power up
powerImg = nil
powerImg1 = nil
powers = {}
randPowerTime = 0
createPowerTimer = randPowerTime
randSpeedTime = 0
createSpeedTimer = randSpeedTime
speedImg = nil
speedBoost = 100
speedUps = {}

-- player life
emptyHeart = nil
halfHeart = nil
wholeHeart = nil
playerLife = 3
heart1 = nil
heart2 = nil
heart3 = nil
heart4 = nil

-- damage done to player
healthdec = .5

-- set background img
background = love.graphics.newImage('assets/background.png')
createEnemyTimerMax = 1.0
createEnemyTimer = createEnemyTimerMax

-- image of first enemy
enemyImg = nil
-- image of 2nd enemy
enemyImg2 = nil
-- enemy image being displayed onscreen
enemyImg3 = nil
-- enemy image #4
enemyImg4 = nil
eneimg = nil
enemies = {}
-- enemies movement speed
enemySpeed = 100
--enemy Health
enemyHealth = 1

isAlive = true
score = 0
bulletscore = 0

--highscore filename
highscoreFile = 'highscore.txt'
--Number of places in the highscore table
highscore_places = 10
--Player name
playerName = "VCA"
--if false means the new score has not been added yet
--ensures the new highscore only gets added once
addhighscore = false

-- checks if there is a collision between two entities
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

-- scale of the window in the x direction
local function scaleX()
  return love.graphics.getWidth() / background:getWidth()
end

-- scale of the window in the y direction
local function scaleY()
  return love.graphics.getHeight() / background:getHeight()
end

-- updates the screen
function love.update(dt)

	--if esc key is pressed, exit
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	-- spaces out how fast the player can shoot bullets
	canShootTimer = canShootTimer - (1*dt)
	if canShootTimer < 0 then
		canShoot = true
	end

	--player movement
	--player can move left using the 'a' key or left arrow key
	if love.keyboard.isDown('left', 'a') then
		if player.x > (48.299480 * scaleX()) then
			player.x = player.x - (playerSpeed*dt)
		end
	--player can move right with 'd' key or right arrow key
	elseif love.keyboard.isDown('right','d') then
		if player.x < ((love.graphics.getWidth()- (59.664064*scaleX()) - player.img:getWidth())) then
			player.x = player.x +(playerSpeed*dt)
		end	
	end
	--player can move upwards with 'up' key or up arrow key
	if love.keyboard.isDown('up','w') then
		if player.y > (85.500981*scaleY()) then
			player.y = player.y +-(playerSpeed*dt)
		end
	-- player can move down with 's' key or down arrow key
	elseif love.keyboard.isDown('down','s') then
		if player.y < (love.graphics.getHeight() - (3.504138*scaleY()) - player.img:getHeight()) then
			player.y = player.y + (playerSpeed*dt)
		end
	end

	-- spaces out how fast the player can shoot bullets
	canShootTimer = canShootTimer - (1 * dt)
	if canShootTimer < 0 then
		canShoot = true
	end
	
	
-- bullet shooting 
	if love.mouse.isDown(1) and canShoot then

		if score < 5 or currAmmo == 0 then

			fire = 1
			local startX = player.x + player.img:getWidth() / 2
			local startY = player.y + player.img:getHeight() / 2
			local mouseX = love.mouse.getX()
			local mouseY = love.mouse.getY()

			local angle = math.atan2((mouseY - startY), (mouseX - startX))

			local bulletDx = bulletSpeed * math.cos(angle)
			local bulletDy = bulletSpeed * math.sin(angle)

			table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})
			canShoot = false
			canShootTimer = canShootTimerMax
			shock = 0
			nova = 0
	
		else if currAmmo >= 1 and currAmmo <= 5 then

		--spread shot
			shock = 1
			spread = 100
			local startX = player.x + player.img:getWidth() / 2
			local startY = player.y + player.img:getHeight() / 2
			local mouseX = love.mouse.getX()
			local mouseY = love.mouse.getY()

			local angle = math.atan2((mouseY - startY), (mouseX - startX))

			local bulletDx = 2*bulletSpeed * math.cos(angle)
			local bulletDy = 2*bulletSpeed * math.sin(angle)
			
		--Quadrant 1/3
			if (bulletDx <= 0 and bulletDy >= 0) or (bulletDx >= 0 and bulletDy <= 0) then
			table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})
			table.insert(bullets, {x = startX, y = startY, dx = bulletDx+spread, dy = bulletDy+spread})
			table.insert(bullets, {x = startX, y = startY, dx = bulletDx-spread, dy = bulletDy-spread})
			end
			--Quadrant 2/4
			if (bulletDx >= 0 and bulletDy >= 0) or (bulletDx <= 0 and bulletDy <= 0) then
			table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})
			table.insert(bullets, {x = startX, y = startY, dx = bulletDx-spread, dy = bulletDy+spread})
			table.insert(bullets, {x = startX, y = startY, dx = bulletDx+spread, dy = bulletDy-spread})
			end
			--X			
			if (bulletDx == 0 and bulletDy >= 0) or (bulletDx == 0 and bulletDy <= 0) then
			table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})
			table.insert(bullets, {x = startX, y = startY, dx = bulletDx+spread, dy = bulletDx-spread})
			table.insert(bullets, {x = startX, y = startY, dx = bulletDx-spread, dy = bulletDx+spread})
			end
			--Y
			if (bulletDx >= 0 and bulletDy == 0) or (bulletDx <= 0 and bulletDy == 0) then
			table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})
			table.insert(bullets, {x = startX, y = startY, dx = bulletDy-spread, dy = bulletDy+spread})
			table.insert(bullets, {x = startX, y = startY, dx = bulletDy+spread, dy = bulletDy-spread})
			end
            
            		nova = 0
            		fire = 0
			currAmmo = currAmmo-1
			canShoot = false
			canShootTimer = 1
			
		else if currAmmo >= 5 then

		--nova
		    
		    nova = 1
        
	        local startX = player.x + player.img:getWidth() / 2
			local startY = player.y + player.img:getHeight() / 2
			local mouseX = love.mouse.getX()
			local mouseY = love.mouse.getY()

			local angle = math.atan2((mouseY - startY), (mouseX - startX))

			local bulletDx = 2*bulletSpeed * math.cos(1)
			local bulletDy = 2*bulletSpeed * math.sin(1)

			
		    table.insert(bullets, {x = startX, y = startY, dx = 200, dy = 100})
			table.insert(bullets, {x = startX, y = startY, dx = 200, dy = 200})
			table.insert(bullets, {x = startX, y = startY, dx = 200, dy = 0})
			table.insert(bullets, {x = startX, y = startY, dx = 200, dy = -100})
			table.insert(bullets, {x = startX, y = startY, dx = 200, dy = -200})
			table.insert(bullets, {x = startX, y = startY, dx = 200, dy = 0})

			table.insert(bullets, {x = startX, y = startY, dx = -200, dy = 100})
			table.insert(bullets, {x = startX, y = startY, dx = -200, dy = 200})
			table.insert(bullets, {x = startX, y = startY, dx = -200, dy = 0})
			table.insert(bullets, {x = startX, y = startY, dx = -200, dy = -100})
			table.insert(bullets, {x = startX, y = startY, dx = -200, dy = -200})
			table.insert(bullets, {x = startX, y = startY, dx = -200, dy = 0})

			table.insert(bullets, {x = startX, y = startY, dx = -100, dy = 100})
			table.insert(bullets, {x = startX, y = startY, dx = -100, dy = 200})
			table.insert(bullets, {x = startX, y = startY, dx = -100, dy = 0})
			table.insert(bullets, {x = startX, y = startY, dx = -100, dy = -100})
			table.insert(bullets, {x = startX, y = startY, dx = -100, dy = -200})
			table.insert(bullets, {x = startX, y = startY, dx = -100, dy = 0})

			table.insert(bullets, {x = startX, y = startY, dx = 100, dy = 100})
			table.insert(bullets, {x = startX, y = startY, dx = 100, dy = 200})
			table.insert(bullets, {x = startX, y = startY, dx = 100, dy = 0})
			table.insert(bullets, {x = startX, y = startY, dx = 100, dy = -100})
			table.insert(bullets, {x = startX, y = startY, dx = 100, dy = -200})
			table.insert(bullets, {x = startX, y = startY, dx = 100, dy = 0})

			table.insert(bullets, {x = startX, y = startY, dx = 00, dy = 100})
			table.insert(bullets, {x = startX, y = startY, dx = 00, dy = 200})
			table.insert(bullets, {x = startX, y = startY, dx = 00, dy = -100})
			table.insert(bullets, {x = startX, y = startY, dx = 00, dy = -200})
			
			fire = 0
			shock = 0
			currAmmo = currAmmo-5
			canShoot = false
			canShootTimer = 1
			
			end
			end	

		end
	end

    --ammo addition
	for i, bullet in ipairs(powers) do
		if CheckCollision(bullet.x, bullet.y, bullet.img:getWidth(),
			bullet.img:getHeight(), player.x, player.y, 
			player.img:getWidth(), player.img:getHeight())
		and isAlive then
			table.remove(powers, i)
			currAmmo = currAmmo + 5
		end
	end

	-- upgrade armor at score of 70
	if score == 50  then
		playerLife = 4
		player.heart1 = wholeHeart
		player.heart2 = wholeHeart
		player.heart3 = wholeHeart
		player.heart4 = wholeHeart
	end

	if score >= 50 then
		hasArmor = true
		if hasArmor then 
			player.img = player.img2
		end
	end
	

	-- regenerate health if powerup is grabbed
	for i, powerUp in ipairs(powers) do
		if CheckCollision(powerUp.x, powerUp.y, powerUp.img:getWidth(),
			powerUp.img:getHeight(), player.x, player.y, 
			player.img:getWidth(), player.img:getHeight())
		and isAlive then
			table.remove(powers, i)
			if hasArmor == false then
				playerLife = 3
				player.heart1 = wholeHeart
				player.heart2 = wholeHeart
				player.heart3 = wholeHeart
			end
			if hasArmor then 
				playerLife = 4
				player.heart1 = wholeHeart
				player.heart2 = wholeHeart
				player.heart3 = wholeHeart
				player.heart4 = wholeHeart
			end
		end
	end

	-- speed boost if power up is grabbed
	for i, speedUp in ipairs(speedUps) do
		if CheckCollision(speedUp.x, speedUp.y, speedUp.img:getWidth(),
			speedUp.img:getHeight(), player.x, player.y, 
			player.img:getWidth(), player.img:getHeight())
		and isAlive then
			table.remove(speedUps, i)
			playerSpeed = playerSpeed + speedBoost
		end
	end


	
	-- collision of enemy with bullets
	for i, enemy in ipairs(enemies) do
		for j, bullet in ipairs(bullets) do
			if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bulletImg:getWidth(), bulletImg:getHeight()) then
				table.remove(bullets, j)
				enemyHealth = enemyHealth - 1
				if enemyHealth == 0 then
			    	table.remove(enemies, i)
			    	if score >= 15 then
			    	    enemyHealth = 2
			    	elseif score < 15 then
			    	    enemyHealth = 1
			    	end
			    end
				score = score + 1
				bulletscore = bulletscore + 1
			end
		end
	
		-- if an enemy hits player, take away life
		if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight())
		and isAlive then
			table.remove(enemies, i)
			playerLife = playerLife - healthdec
			if playerLife == 3.5 then
				player.heart4 = halfHeart
			elseif playerLife == 3 then
				player.heart4 = emptyHeart
			elseif playerLife == 2.5 then
				player.heart3 = halfHeart
			elseif playerLife == 2 then
				player.heart3 = emptyHeart
			elseif playerLife == 1.5 then
				player.heart2 = halfHeart
			elseif playerLife == 1 then
				player.heart2 = emptyHeart
			elseif playerLife == .5 then
				player.heart1 = halfHeart
			elseif playerLife <= 0 then
				player.heart1 = emptyHeart
				player.heart2 = emptyHeart
				player.heart3 = emptyHeart
				player.heart4 = emptyHeart
			end

			if playerLife < .5 then
				isAlive = false
			end
		end
	end
	
	--if score is < 15 use first enemy
	if score < 5 then
		eneimg = enemyImg
		healthdec = .5
	--if score i == 15, use end enemy
	elseif score == 10 then
		eneimg = enemyImg2
		enemySpeed = 150
		healthdec = 1
	-- when player score = 30, spawn enemy3
	elseif score == 15 then
		eneimg = enemyImg3
		enemySpeed = 200
		createEnemyTimerMax = .75
	elseif score == 30 then
	    eneimg = enemyImg4
	    enemySpeed = 200
	end
	
	
--generates ammo drop
	
	createBulletTimer = createBulletTimer - (1*dt)
	if createBulletTimer < 0 then
		randBulletTime = math.random(5,10)
		createBulletTimer = randBulletTime
		xcoord1 = math.random((48 * scaleX()), love.graphics.getWidth() - 100*scaleX())
		ycoord1 = math.random((85 * scaleY()), love.graphics.getHeight() - (65*scaleY()))
		xcoord2 = math.random((48 * scaleX()), love.graphics.getWidth() - 100*scaleX())
		ycoord2 = math.random((85 * scaleY()), love.graphics.getHeight() - (65*scaleY()))		
		
		if score > 5 then
			newBullet = { x = xcoord2, y = ycoord2, img = bulletImg4}
		end
		table.insert(powers, newBullet)
	end
	
		
	--generates enemies
	createEnemyTimer = createEnemyTimer - (1*dt)
	if createEnemyTimer < 0 then
		createEnemyTimer = createEnemyTimerMax
		--where the enemy spawns from
		--1=left 2=top 3=right 4 = bottom
		randomSide = math.random(1,4)
		if randomSide == 1 then
			randomNumber = math.random((85.500981 * scaleY()), love.graphics.getHeight() - (3.504138*scaleY()))
			newEnemy = { x = (48.299480*scaleX()), y = randomNumber, img = eneimg}
		elseif randomSide == 2 then
			randomNumber = math.random((48.299480 * scaleX()), love.graphics.getWidth() - (59.66464*scaleX()))
			newEnemy = { x = randomNumber, y = (85.500981*scaleY()), img = eneimg}
		elseif randomSide == 3 then
			randomNumber = math.random((85.500981 * scaleY()), love.graphics.getHeight() - (3.504138*scaleY()))
			newEnemy = { x = love.graphics.getWidth() - (59.66464*scaleX())-enemyImg:getWidth(), y = randomNumber, img = eneimg}
		elseif randomSide == 4 then
			randomNumber = math.random(48.299480 * scaleX(), love.graphics.getWidth() - 59.66464*scaleX())
			newEnemy = { x = randomNumber, y = love.graphics.getHeight() - (3.504138*scaleY())-enemyImg:getHeight(), img = eneimg}
		end
		--add the enemy to the table
		table.insert(enemies, newEnemy)
	end

	-- generate power ups


	-- speed at random time intervals
	createPowerTimer = createPowerTimer - (1*dt)
	if createPowerTimer < 0 then
		randPowerTime = math.random(5,8)
		createPowerTimer = randPowerTime
		xcoord1 = math.random((48 * scaleX()), love.graphics.getWidth() - 100*scaleX())
		ycoord1 = math.random((85 * scaleY()), love.graphics.getHeight() - (65*scaleY()))		
		if score > 5 then
			newPower = { x = xcoord2, y = ycoord2, img = powerImg}
		end
		table.insert(powers, newPower)
	end

	createSpeedTimer = createSpeedTimer - (1*dt)
	if createSpeedTimer < 0 then
		randSpeedTime = math.random(8,10)
		createSpeedTimer = randSpeedTime
		xcoord2 = math.random((48 * scaleX()), love.graphics.getWidth() - 100*scaleX())
		ycoord2 = math.random((85 * scaleY()), love.graphics.getHeight() - (65*scaleY()))
		if score > 8 then
			newSpeed = { x = xcoord1, y = ycoord1, img = speedImg}
		end
		table.insert(speedUps, newSpeed)
	end
		

	--enemy image update on screen
	for i, enemy in ipairs(enemies) do
		local enemyDx = player.x - enemy.x
		local enemyDy = player.y - enemy.y
		distance = math.sqrt(enemyDx*enemyDx+enemyDy*enemyDy)
		enemy.y = enemy.y + (enemyDy/distance * enemySpeed *dt)
		enemy.x = enemy.x + (enemyDx/distance * enemySpeed *dt)
	end
	
	--bullet image update on screen
	for i,v in ipairs(bullets) do
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)
	end
	
	--if player is dead and presses the 'r' key
	--restart the game
	if not isAlive and love.keyboard.isDown('r') then
		
		bullets = {}
		enemies = {}
		powers = {}
		speedUps = {}

		canShootTimer = canShootTimerMax
		createEnemyTimer = createEnemyTimerMax
		createPowerTimer = randPowerTime
		createSpeedTimer = randSpeedTime

		player.x = love.graphics.getWidth()/2
		player.y = (love.graphics.getHeight()/2)

		score = 0
		playerLife = 3
		player.heart1 = wholeHeart
		player.heart2 = wholeHeart
		player.heart3 = wholeHeart
		player.heart4 = wholeHeart
		isAlive = true
		player.img = player.img1
		hasArmor = false
		
		--reset addhighscore
		addhighscore = false
	end
end

--player size
player = { x = love.graphics.getWidth()/2, y = (love.graphics.getHeight()/2), speed = 150, img = nil, heart1 = nil, heart2 = nil, heart3 = nil, heart4 = nil}

--initializes all images and assets
function load(arg)

	--creates highscore file if it does not exist
	if not love.filesystem.exists(highscoreFile) then
		highscore_new(highscoreFile, highscore_places, playerName, score)
	end
	--loads the highscore file into arrays of name and score
	highscore_load(highscoreFile)
	
	love.window.setFullscreen(true, "desktop")
	player.img1 = love.graphics.newImage('assets/player.png')
	player.img = player.img1
	player.img2 = love.graphics.newImage('assets/player2.png')
	bulletImg = love.graphics.newImage('assets/fireball.png')
	bulletImg2 = love.graphics.newImage('assets/lightn.png')
	bulletImg3 = love.graphics.newImage('assets/nova.png')
	bulletImg4 = love.graphics.newImage('assets/magic.png')
	enemyImg = love.graphics.newImage('assets/skull.png')
	enemyImg2 = love.graphics.newImage('assets/enemy2.png')
	enemyImg3 = love.graphics.newImage('assets/enemy3.png')
	enemyImg4 = love.graphics.newImage('assets/enemy4.png')
	currWeapon = love.graphics.newImage('assets/fireball.png')
	infSymbol = love.graphics.newImage('assets/inf.png')
	emptyHeart = love.graphics.newImage('assets/emptyHeart.png')
	halfHeart = love.graphics.newImage('assets/halfHeart.png')
	wholeHeart = love.graphics.newImage('assets/wholeHeart.png')
	powerImg = love.graphics.newImage('assets/wholeHeart.png')
	speedImg = love.graphics.newImage('assets/shoe.png')
	armorImg = love.graphics.newImage('assets/armor.png')
	player.heart1 = wholeHeart
	player.heart2 = wholeHeart
	player.heart3 = wholeHeart
	player.heart4 = wholeHeart
	local sx = love.graphics.getWidth() / background:getWidth()
	local sy = love.graphics.getHeight() / background:getHeight()
	love.graphics.draw(background,0,0,0,sx,sy)
	love.graphics.draw(currWeapon,450*scaleX(),30*scaleY(),0,sx,sy)

	if isAlive then
		love.graphics.draw(player.img,player.x,player.y)
		love.graphics.draw(player.heart1, 50*scaleX(), 35*scaleY(),0,sx,sy)
		love.graphics.draw(player.heart2, 90*scaleX(), 35*scaleY(),0,sx,sy)
		love.graphics.draw(player.heart3, 130*scaleX(), 35*scaleY(),0,sx,sy)
		if hasArmor then
			love.graphics.draw(player.heart4, 170*scaleX(), 35*scaleY(),0,sx,sy)
		end
	else
	
		--ensure the new highscore is only added and written once
		if not addhighscore then
			highscore_add(score, playerName)
			highscore_write(highscoreFile)
			addhighscore = true
		end
		
		love.graphics.draw(player.heart1, 50*scaleX(), 35*scaleY(),0,sx,sy)
		love.graphics.draw(player.heart2, 90*scaleX(), 35*scaleY(),0,sx,sy)
		love.graphics.draw(player.heart3, 130*scaleX(), 35*scaleY(),0,sx,sy)
		if hasArmor then
			love.graphics.draw(player.heart4, 170*scaleX(), 35*scaleY(),0,sx,sy)
		end
		love.graphics.setColor(0,0,0)
		love.graphics.setNewFont('assets/computer.ttf', (20*scaleY()))
		
		love.graphics.print("FINAL SCORE: " .. tostring(score), love.graphics:getWidth()/2-100*scaleX(), love.graphics:getHeight()/2-200*scaleY())
		love.graphics.print("Press 'r' to Restart", love.graphics:getWidth()/2-100*scaleX(), love.graphics:getHeight()/2-170*scaleY())
		
		--prints the highscore table
		love.graphics.print("High Scores", love.graphics:getWidth()/2-100*scaleX(), love.graphics:getHeight()/2-100*scaleY())
		z = -70
		for i = 1, 10 do
			love.graphics.print(tostring(i)..".  "..tostring(highscore_name[i])..":  " .. tostring(highscore[i]), love.graphics:getWidth()/2-100*scaleX(), love.graphics:getHeight()/2+z*scaleY())
			z = z + 30
		end
		
		enemies = {}
		bullets = {}
		powers = {}
		speedUps = {}
		createEnemyTimer = 0
		createPowerTimer = 0
		createSpeedTimer = 0
		playerSpeed = 150
		enemySpeed = 100
		hasArmor = false
		player.img = player.img1
	end
end

--draws non-moving parts of the screen
function love.draw(dt)
	local sx = love.graphics.getWidth() / background:getWidth()
	local sy = love.graphics.getHeight() / background:getHeight()
	love.graphics.draw(background,0,0,0,sx,sy)
	love.graphics.draw(currWeapon,450*scaleX(),30*scaleY(),0,sx,sy)

	if isAlive then
		love.graphics.draw(player.img,player.x,player.y)
		love.graphics.draw(player.heart1, 50*scaleX(), 35*scaleY(),0,sx,sy)
		love.graphics.draw(player.heart2, 90*scaleX(), 35*scaleY(),0,sx,sy)
		love.graphics.draw(player.heart3, 130*scaleX(), 35*scaleY(),0,sx,sy)
		if hasArmor then
			love.graphics.draw(player.heart4, 170*scaleX(), 35*scaleY(),0,sx,sy)
		end
	else
	
		--ensure new highscore is only added once and written once
		if not addhighscore then
			highscore_add(score, playerName)
			highscore_write(highscoreFile)
			addhighscore = true
		end
		
		love.graphics.draw(player.heart1, 50*scaleX(), 35*scaleY(),0,sx,sy)
		love.graphics.draw(player.heart2, 90*scaleX(), 35*scaleY(),0,sx,sy)
		love.graphics.draw(player.heart3, 130*scaleX(), 35*scaleY(),0,sx,sy)
		if hasArmor then
			love.graphics.draw(player.heart4, 170*scaleX(), 35*scaleY(),0,sx,sy)
		end
		love.graphics.setColor(255,255,255)
		love.graphics.setNewFont('assets/computer.ttf', (20*scaleY()))
		love.graphics.print("FINAL SCORE: " .. tostring(score), love.graphics:getWidth()/2-100*scaleX(), love.graphics:getHeight()/2-200*scaleY())
		love.graphics.print("Press 'r' to Restart", love.graphics:getWidth()/2-100*scaleX(), love.graphics:getHeight()/2-170*scaleY())
		
		--prints the highscore table
		love.graphics.print("High Scores", love.graphics:getWidth()/2-100*scaleX(), love.graphics:getHeight()/2-100*scaleY())
		z = -70
		for i = 1, 10 do
			love.graphics.print(tostring(i)..".  "..tostring(highscore_name[i])..":  " .. tostring(highscore[i]), love.graphics:getWidth()/2-100*scaleX(), love.graphics:getHeight()/2+z*scaleY())
			z = z + 30
		end
		
		enemies = {}
		bullets = {}
		powers = {}
		speedUps = {}
		createEnemyTimer = 0
		createPowerTimer = 0
		createSpeedTimer = 0
		playerSpeed = 150
		enemySpeed = 100
		hasArmor = false
		player.img = player.img1
	end

    --bullet draw
    

	if fire == 1 then
	
		currWeapon = love.graphics.newImage('assets/fireball.png')
	
		for i,v in ipairs(bullets) do
			love.graphics.draw(currWeapon, v.x, v.y, 3)	
	end
	end
  
	if shock == 1 then 

		currWeapon = love.graphics.newImage('assets/lightn.png')
 
		for i,v in ipairs(bullets) do
			love.graphics.draw(currWeapon, v.x, v.y, 3)
	end
	end

	if nova == 1 then 

		currWeapon = love.graphics.newImage('assets/nova.png')
 
		for i,v in ipairs(bullets) do
			love.graphics.draw(currWeapon, v.x, v.y, 3)
	end
	end

    --enemy draw
	for i, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.img, enemy.x, enemy.y)
	end

	for i, powerUp in ipairs(powers) do
		love.graphics.draw(powerUp.img, powerUp.x, powerUp.y)
	end

	for i, speedUp in ipairs(speedUps) do
		love.graphics.draw(speedUp.img, speedUp.x, speedUp.y)
	end



	love.graphics.setColor(255,255,255)
	love.graphics.setNewFont('assets/computer.ttf', (20*scaleY()))
	love.graphics.print("SCORE: " .. tostring(score), 800*scaleX(), 10*scaleY())
	love.graphics.print("HIGH SCORE: " .. tostring(highscore[1]), 800*scaleX(), 30*scaleY())
	love.graphics.setNewFont('assets/computer.ttf', (16*scaleY()))
	love.graphics.print("WEAPON", 430*scaleX(), 10*scaleY())
	love.graphics.print("AMMO", 540*scaleX(), 10*scaleY())
	if fire == 1 then
		love.graphics.draw(infSymbol,550*scaleX(), 30*scaleY(),0,sx,sy)
	end
	if shock == 1 or nova == 1 then
		love.graphics.print(tostring(currAmmo),550*scaleX(), 30*scaleY(),0,sx,sy)
	end
	love.graphics.setColor(255,255,255)
end

--highscore functions
highscore_name={}
highscore={}
	
function highscore_new(filename, places, name, player_score)
	local file=love.filesystem.newFile(filename)
	file:open("w")
	local a=1
	for a=1, places do
		file:write(name.."\n"..player_score.."\n")
	end
	file:close()
end

function highscore_load(filename)
	local file=love.filesystem.newFile(filename)
	file:open("r")
	local a=1
	local stringtype=1
	for line in file:lines() do
		if stringtype==1 then
			highscore_name[a]=line
			stringtype=2
		else
			highscore[a]=tonumber(line)
			stringtype=1
			a=a+1
		end
	end
	highscore_places=a-1
	file:close()
end

function highscore_write(filename)
	local file=love.filesystem.newFile(filename)
	file:open("w")
	local a=1
	for a=1, highscore_places do
		file:write(highscore_name[a].."\n"..highscore[a].."\n")
		a=a+1
	end
	file:close()
end

function highscore_add(player_score, name)
	
	local a=1
	local c=1
	for a=1, highscore_places do
		if player_score>highscore[a] then
			local b=highscore_places
			for b=highscore_places, a+1, -1 do
				highscore_name[b]=highscore_name[b-1]
				highscore[b]=highscore[b-1]
			end
			highscore[a]=player_score
			highscore_name[a]=name
			break
		end
		c = c + 1
	end
end