--Tiene todos los desafíos del piso 1.

local challenges = {}
---------------------------------------------------------------------------------Scripts locales

local playersInGame = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundEvent = ReplicatedStorage:WaitForChild("SoundEvent")
local SoundService = game:GetService("SoundService")
local floor = workspace:WaitForChild("F1")

-------------------------------------------------------------------------------Scripts globales

function challenges.addPlayers(playerAdded)
	table.insert(playersInGame, playerAdded)
end

function challenges.removePlayers(playerRemoved)
	for index, value in ipairs(playersInGame) do
		if value == playerRemoved then
			table.remove(playersInGame, index)
			break
		end
	end
end

local cooldownPlayers = {}

--------------------------------------------------------Lasers
local lasers = floor:WaitForChild("Lasers")
local laser1 = lasers:WaitForChild("Laser1")
local laser2 = lasers:WaitForChild("Laser2")
local laser3 = lasers:WaitForChild("Laser3")

for i, laser in pairs(lasers:GetChildren()) do
	laser.Touched:Connect(function(partTouched)
		local character = partTouched.Parent
		local player = Players:GetPlayerFromCharacter(character)
		local haveForceField = character:FindFirstChildWhichIsA("ForceField")
		if player and cooldownPlayers[player.Name] == false and player:GetAttribute("inGame") == true and not haveForceField then
			cooldownPlayers[player.Name] = true
			local humanoid = character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.Health = humanoid.Health - 25
				SoundEvent:FireClient(player, "LaserHit")
			end
			task.wait(0.5)
			cooldownPlayers[player.Name] = false
		end
	end)
end--En este for estan las funciones de daño.

function challenges.f1c1()
	cooldownPlayers = {}
	for index, value in ipairs(playersInGame) do
		cooldownPlayers[value.Name] = false
	end
	
	laser1.Transparency = 0
	for index, child in pairs(laser1:GetChildren()) do
		if child:IsA("BasePart") then
			child.Transparency = 0
		end
	end
	laser1.CanTouch = true
	laser1.CanCollide = true
	local info = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 5, true)
	local goalCFrame = laser1.CFrame * CFrame.new(0, 0, 83.5)
	local tween = TweenService:Create(laser1, info, {CFrame = goalCFrame})
	tween:Play()
	for i = 1, 4 do
		for i, plyer in ipairs(Players:GetPlayers()) do
			if plyer:GetAttribute("inGame") == true then
				SoundEvent:FireClient(plyer, "LaserMoving")
			end
		end
		task.wait(3)
	end
	laser2.Transparency = 0
	for index, child in pairs(laser2:GetChildren()) do
		if child:IsA("BasePart") then
			child.Transparency = 0
		end
	end
	laser2.CanTouch = true
	laser2.CanCollide = true
	local info2 = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 3, true)
	local goalCFrame2 = laser2.CFrame * CFrame.new(0, 0, 83.5)
	local tween2 = TweenService:Create(laser2, info2, {CFrame = goalCFrame2})
	tween2:Play()
	for i = 1, 4 do
		for i, plyer in ipairs(Players:GetPlayers()) do
			if plyer:GetAttribute("inGame") == true then
				SoundEvent:FireClient(plyer, "LaserMoving")
			end
		end
		task.wait(3)
	end
	laser3.Transparency = 0
	for index, child in pairs(laser3:GetChildren()) do
		if child:IsA("BasePart") then
			child.Transparency = 0
		end
	end
	laser3.CanTouch = true
	laser3.CanCollide = true
	local info3 = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 1, true)
	local goalCFrame3 = laser3.CFrame * CFrame.new(0, 0, 83.5)
	local tween3 = TweenService:Create(laser3, info3, {CFrame = goalCFrame3})
	tween3:Play()
	for i = 1, 4 do
		for i, plyer in ipairs(Players:GetPlayers()) do
			if plyer:GetAttribute("inGame") == true then
				SoundEvent:FireClient(plyer, "LaserMoving")
			end
		end
		task.wait(3)
	end
	local number = 0
	for i = 1, 3 do
		number = number + 1
		for index, value in pairs(lasers:WaitForChild("Laser" .. number):GetChildren()) do
			if value:IsA("BasePart") then
				value.Transparency = 1
			end
		end
		lasers:WaitForChild("Laser" .. number).Transparency = 1
		lasers:WaitForChild("Laser" .. number).CanTouch = false
		lasers:WaitForChild("Laser" .. number).CanCollide = false
	end
end--estos son los lasers, son tweeen service y funciones que hacen que se muevan y hagan daño.
--------------------------------------------------------------------------------------------

-------------------------------------------------------------------------Químicos
local quadrants = floor:WaitForChild("Chemicals")

function challenges.f1c2()
	cooldownPlayers = {}
	local quadrant1
	local quadrant2
	local quadrant3
	local acid1
	local acid2
	local acid3
	for i, player in ipairs(playersInGame) do
		cooldownPlayers[player.Name] = false
	end
	------------------------
	local function quadrantsDamage(quadrant)
		task.wait(0.5)
		local isTouching = true
		
		while isTouching do
			local partsInPart = workspace:GetPartsInPart(quadrant)
			local playersInPart = {}
			local playerFound = false
			
			for i, part in pairs(partsInPart) do
				local character = part.Parent
				local humanoid = character:FindFirstChild("Humanoid")
				local haveForceField = character:FindFirstChild("ForceField")
				
				if humanoid and not haveForceField and humanoid.Health > 0 and not playersInPart[character]then
					humanoid.Health -= 10
					playersInPart[character] = true
					playerFound = true
				end
			end
			if playerFound == false and quadrant.CanTouch == false then
				isTouching = false
			end
			task.wait(0.25)
		end
	end--Es la funcion del daño, le mandas el cuadrante y detecta si los jugadores que y les quita vida.
	------------------------
	local function visible(first, second, third)
		local list = {first, second, third}

		for i, part in ipairs(list) do
			if part then
				part.Transparency = 0
				part.CanTouch = true
				part:WaitForChild("ParticulePart"):WaitForChild("ParticleEmitter").Enabled = true
				part:WaitForChild("ParticulePart"):WaitForChild("ParticleEmitter"):Emit(50)
			end
		end
	end--hace visible el que vos quieras
	local function invisible(first, second, third)
		local list = {first, second, third}

		for i, part in ipairs(list) do
			if part then
				part.Transparency = 1
				part.CanTouch = false
				part:WaitForChild("ParticulePart"):WaitForChild("ParticleEmitter").Enabled = false
			end
		end
	end--hace invisible el que vos quieras
	-----------------------------------------
	local function fTween1()	
		local info1 = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, true)
		local goalCFrame1 = acid1.CFrame * CFrame.new(0, 1.5, 0)
		local tween1 = TweenService:Create(acid1, info1, {CFrame = goalCFrame1})
		visible(acid1)
		tween1:Play()
		task.wait(6)
		invisible(acid1)
	end--tween1
	local function fTween2()
		local info2 = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, true)
		local goalCFrame2 = acid2.CFrame * CFrame.new(0, 1.5, 0)
		local tween2= TweenService:Create(acid2, info2, {CFrame = goalCFrame2})
		visible(acid2)
		tween2:Play()
		task.wait(6)
		invisible(acid2)
	end--tween2
	local function fTween3()
		local info3 = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, true)
		local goalCFrame3 = acid3.CFrame * CFrame.new(0, 1.5, 0)
		local tween3= TweenService:Create(acid3, info3, {CFrame = goalCFrame3})
		visible(acid3)
		tween3:Play()
		task.wait(6)
		invisible(acid3)
	end--tween3
	------------------------------
	local function review()
		repeat
			print("repeat")
			quadrant1 = quadrants:WaitForChild("Quadrant" .. math.random(1, 9))
			quadrant2 = quadrants:WaitForChild("Quadrant" .. math.random(1, 9))
			quadrant3 = quadrants:WaitForChild("Quadrant" .. math.random(1, 9))
		until
		quadrant1 ~= quadrant2 and quadrant1 ~= quadrant3 and quadrant2 ~= quadrant3
	end--revisa si que no sean iguales
	-------------------------------------
	local function quadrantsFunction(parameter)
		if parameter == 1 then
			quadrant1 = quadrants:WaitForChild("Quadrant" .. math.random(1, 9))
			acid1 = quadrant1:WaitForChild("Acid")
			task.spawn(fTween1)
			for i, player in ipairs(playersInGame) do
				if player:GetAttribute("inGame") == true then
					SoundEvent:FireClient(player, "Bubbles")
				end
			end
			quadrant1.CanTouch = true
			task.spawn(quadrantsDamage, quadrant1)
			task.wait(7)
			quadrant1.CanTouch = false
		end
		
		if parameter == 2 then
			quadrant1 = quadrants:WaitForChild("Quadrant" .. math.random(1, 9))
			quadrant2 = quadrants:WaitForChild("Quadrant" .. math.random(1, 9))
			review()
			acid1 = quadrant1:WaitForChild("Acid")
			acid2 = quadrant2:WaitForChild("Acid")
			task.wait(0.5)
			task.spawn(fTween1)
			task.spawn(fTween2)
			for i, player in ipairs(playersInGame) do
				if player:GetAttribute("inGame") == true then
					SoundEvent:FireClient(player, "Bubbles")
				end
			end
			quadrant1.CanTouch = true
			quadrant2.CanTouch = true
			task.spawn(quadrantsDamage, quadrant1)
			task.spawn(quadrantsDamage, quadrant2)
			task.wait(7)
			quadrant1.CanTouch = false
			quadrant2.CanTouch = false
		end
		
		if parameter == 3 then
			quadrant1 = quadrants:WaitForChild("Quadrant" .. math.random(1, 9))
			quadrant2 = quadrants:WaitForChild("Quadrant" .. math.random(1, 9))
			quadrant3 = quadrants:WaitForChild("Quadrant" .. math.random(1, 9))
			review()
			acid1 = quadrant1:WaitForChild("Acid")
			acid2 = quadrant2:WaitForChild("Acid")
			acid3 = quadrant3:WaitForChild("Acid")
			task.wait(0.5)
			task.spawn(fTween1)
			task.spawn(fTween2)
			task.spawn(fTween3)
			for i, player in ipairs(playersInGame) do
				if player:GetAttribute("inGame") == true then
					SoundEvent:FireClient(player, "Bubbles")
				end
			end
			quadrant1.CanTouch = true
			quadrant2.CanTouch = true
			quadrant3.CanTouch = true
			task.spawn(quadrantsDamage, quadrant1)
			task.spawn(quadrantsDamage, quadrant2)
			task.spawn(quadrantsDamage, quadrant3)
			task.wait(7)
			quadrant1.CanTouch = false
			quadrant2.CanTouch = false
			quadrant3.CanTouch = false
		end
	end
	quadrantsFunction(1)
	quadrantsFunction(2)
	quadrantsFunction(3)
end--es la funcion de los cuadrantes que selecciona allgunos y los sube, ademas del daño.

-----------------------------
local floorR = floor:WaitForChild("MainModel"):WaitForChild("Floor")
local acid = floor:WaitForChild("MainModel"):WaitForChild("Acid")
local fansFolder = floor:WaitForChild("Fans")

local function collitions()
	for i, v in pairs(fansFolder:GetChildren()) do
		if v:IsA("BasePart") then
			v.Touched:Connect(function(part)
				local character = part.Parent
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart then
					for i, v in ipairs(humanoidRootPart:GetChildren()) do
						if v:IsA("VectorForce") then
							v:Destroy()
						end
					end
				end
			end)
		end
	end
end
collitions()-----Esta función es de las zonas d muerte que te quitan el VectorForce.

acid.Touched:Connect(function(part)
	local character = part.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if humanoid and humanoid.Health > 0 then
		humanoid.Health = 0
		local force = humanoidRootPart:FindFirstChild("VectorForce")
		if force then
			force:Destroy()
		end
		local player = Players:GetPlayerFromCharacter(character)
		SoundEvent:FireClient(player, "WindOff")
	end
end)------Este es que te mate el ácido.



function challenges.f1c3()
	for i, v in ipairs(fansFolder:GetChildren()) do
		if v:IsA("BasePart") then
			v.CanTouch = true
		end
	end
	
	local info = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local goalSize = Vector3.new(60, 1, 60)
	local tween = TweenService:Create(floorR, info, {Size = goalSize})
	tween:Play()
	
	task.wait(3)
	local forceX = 0
	local forceZ = 0
	
	local function fansOn(player)
		if player then
			local character = player.Character or player.CharacterAdded:Wait()
			local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
			local humanoid = character:WaitForChild("Humanoid")
			if HumanoidRootPart and humanoid then
				humanoid.JumpHeight = 0
				local force = Instance.new("VectorForce")
				local attachment = Instance.new("Attachment")
				force.Enabled = false
				attachment.Parent = HumanoidRootPart
				force.Parent = HumanoidRootPart
				force.Attachment0 = attachment
				force.RelativeTo = Enum.ActuatorRelativeTo.World
				force.ApplyAtCenterOfMass = true
				force.Force = Vector3.new(forceX, 0, forceZ)
				force.Enabled = true
				SoundEvent:FireClient(player, "WindOn")
			end
		else
			for i, player in ipairs(playersInGame) do
				if player:GetAttribute("inGame") == true then
					local character = player.Character
					local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
					local humanoid = character:WaitForChild("Humanoid")
					if HumanoidRootPart and humanoid then
						humanoid.JumpHeight = 0
						local force = Instance.new("VectorForce")
						local attachment = Instance.new("Attachment")
						force.Enabled = false
						attachment.Parent = HumanoidRootPart
						force.Parent = HumanoidRootPart
						force.Attachment0 = attachment
						force.RelativeTo = Enum.ActuatorRelativeTo.World
						force.ApplyAtCenterOfMass = true
						force.Force = Vector3.new(forceX, 0, forceZ)
						force.Enabled = true
						SoundEvent:FireClient(player, "WindOn")
					end
				end
			end
		end
	end--Esta función se usa para encender los ventiladores y la fuerza.
	
	local function fansOff(quitJump)
		forceX = 0
		forceZ = 0
		for i, player in ipairs(playersInGame) do
			if player:GetAttribute("inGame") == true then
				local character = player.Character or player.CharacterAdded:Wait()
				local humanoid = character:WaitForChild("Humanoid")
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				local force = humanoidRootPart:FindFirstChild("VectorForce")
				SoundEvent:FireClient(player, "WindOff")
				if force then
					force:Destroy()
				end
				if quitJump then
					if humanoid then
						humanoid.JumpHeight = 7.2
					end
				end
			end
		end
	end---------Esta función le quita la fuerza a todos los jugadores.
	
	local playersConnections = {}--En este array están todas las conexiones de los jugadores para que al revivir se les de la fuerza. 

	for i, player in ipairs(playersInGame) do
		if player:GetAttribute("inGame") == true then
			local connection
			connection =  player.CharacterAdded:Connect(function(character)--Cuando respawnea el character.
				if player:GetAttribute("inGame") == true then
					task.wait(2)
					fansOn(player)
				else
					connection:Disconnect()
					local index = table.find(playersConnections, connection)
					if index then
						table.remove(playersConnections, index)
					end
				end
			end)-----------------------------------------------------------
			table.insert(playersConnections, connection)
		end
	end--Esta función guarda en el array las conexiones de los jugadores.
	
	local function endChallenge()
		local info = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		local goalSize = Vector3.new(86, 1, 86)
		local tween = TweenService:Create(floorR, info, {Size = goalSize})
		tween:Play()
	end
	
	local num = math.random(1, 4)
	if num == 1 then
		forceX = 5000
		forceZ = 0
		fansOn()
	elseif num == 2 then
		forceX = -5000
		forceZ = 0
		fansOn()
	elseif num == 3 then
		forceX = 0
		forceZ = 5000
		fansOn()
	elseif num == 4 then
		forceX = 0
		forceZ = -5000
		fansOn()
	end
	
	task.wait(10)
	
	fansOff()
	task.wait(1)
	
	local num = math.random(1, 4)
	if num == 1 then
		forceX = 7500
		forceZ = 0
		fansOn()
	elseif num == 2 then
		forceX = -7500
		forceZ = 0
		fansOn()
	elseif num == 3 then
		forceX = 0
		forceZ = 7500
		fansOn()
	elseif num == 4 then
		forceX = 0
		forceZ = -7500
		fansOn()
	end
	
	task.wait(10)

	fansOff()
	task.wait(1)
	
	local num = math.random(1, 4)
	if num == 1 then
		forceX = 8000
		forceZ = 0
		fansOn()
	elseif num == 2 then
		forceX = -8000
		forceZ = 0
		fansOn()
	elseif num == 3 then
		forceX = 0
		forceZ = 8000
		fansOn()
	elseif num == 4 then
		forceX = 0
		forceZ = -8000
		fansOn()
	end
	
	task.wait(10)

	fansOff(true)
	endChallenge()
	task.wait(1)
	
	for i, playerConnection in ipairs(playersConnections) do
		playerConnection:Disconnect()
	end
	playersConnections = {}
end




return challenges
