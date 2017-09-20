function highscore_new(filename, places, name, score)
	local file=love.filesystem.newFile(filename)
	file:open("w")
	local a=1
	for a=1, places do
		file:write(name.."\n"..score.."\n")
	end
	file:close()
end

function highscore_load(filename)
	local file=love.filesystem.newFile(filename)
	file:open("r")
	local a=1
	local stringtype=1
	highscore_name={}
	highscore={}
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

function highscore_add(score, name)
	local a=1
	for a=1, highscore_places do
		if score>highscore[a] then
			local b=highscore_places
			for b=highscore_places, a+1, -1 do
				highscore_name[b]=highscore_name[b-1]
				highscore[b]=highscore[b-1]
			end
			highscore[a]=score
			highscore_name[a]=name
			break
		end
	end
end

A
10
B
9
C
8
D
7
E
6
F
5
G
4
H
3
I
2
J
1






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



function highscore_add(player_score, name)
	local i = 1
	local d = true
	for i = 1, highscore_places do
		if player_score>highscore[i] then
			if d then
				local a = 10
				local b = a - i
				local c = 10
				for j=1, b do
					highscore_name[c]=highscore_name[c-1]
					highscore[c]=highscore[c-1]
					c = c - 1
				end
				highscore[i]=player_score
				highscore_name[i]=name
				d = false
			end
		end
	end
end



local i = 10
	while highscore[i] < player_score do 
		highscore_name[i]=highscore_name[i-1]
		highscore[i]=highscore[i-1]
		i=i-1
	end
	highscore[i]=player_score
	highscore_name[i]=name