--Este script maneja la cámara.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = player.PlayerGui
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local LocalizationService = game:GetService("LocalizationService")
local translator = nil
local SoundService = game:GetService("SoundService")
local SoundEffects = SoundService:WaitForChild("SoundEffects")

local function loadTranslator()
	local success, result = pcall(function()
		return LocalizationService:GetTranslatorForPlayer(player)
	end)
	
	if success then
		translator = result
	else
		warn("Error al obtener el traductor de: " .. player.Name)
	end
end

task.spawn(loadTranslator)

local function character(newCharacter)
	if player.Character then
		character = newCharacter
		humanoid = character:WaitForChild("Humanoid")
	end
end
--------------------------esto actualiza el humanoid y el character.
player.CharacterAdded:Connect(character)

if player.Character then
	character(player.Character)
end

local camera = workspace.CurrentCamera
local tweenTime = 2
local dialogueGui = PlayerGui:WaitForChild("Dialogue")
local messageText = ""
local function translate(message)
	if translator then
		messageText = translator:Translate(game, message)
		return messageText
	end
end
----------Es lo que traduce el mensaje.

local function resetButton(boolean)
	pcall(function()
		StarterGui:SetCore("ResetButtonCallback", boolean)
	end)
end
-------------es la función del botón de resetear personaje.
----------------
local function cameraP1s()
	resetButton(false)
	local F1 = workspace:WaitForChild("F1")
	local goalCFrame = CFrame.new(Vector3.new(0, 16, 176.5), Vector3.new(0, 16, 182.5))
	humanoid.JumpHeight = 0
	humanoid.WalkSpeed = 0
	camera.CameraType = Enum.CameraType.Scriptable
	local info = TweenInfo.new(tweenTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local tween = TweenService:Create(camera, info, {CFrame = goalCFrame})
	local glass = F1:WaitForChild("MainModel"):WaitForChild("Glass")
	glass.Transparency = 1
	tween:Play()
	
	local function dialogue(label, message, speed)
		label.Text = ""
		for i = 1, #message do
			if player:GetAttribute("inGame") == false then
				PlayerGui.Dialogue.Enabled = false
				camera.CameraType = Enum.CameraType.Custom
				glass.Transparency = 0.6
				return	
			end
			label.Text = string.sub(message, 1, i)
			SoundEffects.Text:Play()
			task.wait(speed)
		end
	end
	
	local text1 = "Hahaha, I locked you all in my laboratory, but for now some parts are under construction."
	local text2 = "For now, only the first floor and three of its challenges have been created."
	local text3 = "So, your challenge for the first floor will be:..."
	local lasersText1 = "The lasers!"
	local lasersText2 = "You must dodge the lasers, and if you don't make it, you will die."
	local chemicalsText1 = "The chemicals!"
	local chemicalsText2 = "Chemicals will be spilled in random places on the floor, and if you touch them, you will die."
	local windText1 = "The wind!"
	local windText2 = "You must fight against the wind, otherwise it will throw you to a certain death."
	
	local time1 = 3.5
	local time2 = 3
	local time3 = 2.5
	local timeChallenges = 2
	local time4 = 5
	
	
	local messageText = text1
	local messageLabel = dialogueGui.FrameD.TextLabel
	local textSpeed = ReplicatedStorage:GetAttribute("TimeCamera")
	
	textSpeed = textSpeed - time1 - time2 - time3 - timeChallenges - time4 - tweenTime - 5
	
	local characters = #text1 + #text2 + #text3
	if ReplicatedStorage:GetAttribute("Challenge") == "Lasers" then
		characters = characters + #lasersText1 + #lasersText2
	elseif ReplicatedStorage:GetAttribute("Challenge") == "Chemicals" then
		characters = characters + #chemicalsText1 + #chemicalsText2
	elseif ReplicatedStorage:GetAttribute("Challenge") == "Fans" then
		characters = characters + #windText1 + #windText2
	end
	
	local time = textSpeed / characters
	task.wait(tweenTime)
	
	translate(messageText)
	dialogueGui.Enabled = true
	dialogue(messageLabel, messageText, time)
	task.wait(time1)
	messageText = text2
	translate(messageText)
	dialogue(messageLabel, messageText, time)
	task.wait(time2)
	messageText = text3
	translate(messageText)
	dialogue(messageLabel, messageText, time)
	task.wait(time3)
	if ReplicatedStorage:GetAttribute("Challenge") == "Lasers" then
		messageText = lasersText1
		translate(messageText)
		dialogue(messageLabel, messageText, time)
		task.wait(timeChallenges)
		messageText = lasersText2
		translate(messageText)
		dialogue(messageLabel, messageText, time)
	elseif ReplicatedStorage:GetAttribute("Challenge") == "Chemicals" then
		messageText = chemicalsText1
		translate(messageText)
		dialogue(messageLabel, messageText, time)
		task.wait(timeChallenges)
		messageText = chemicalsText2
		translate(messageText)
		dialogue(messageLabel, messageText, time)
	elseif ReplicatedStorage:GetAttribute("Challenge") == "Wind" then
		messageText = windText1
		translate(messageText)
		dialogue(messageLabel, messageText, time)
		task.wait(timeChallenges)
		messageText = windText2
		translate(messageText)
		dialogue(messageLabel, messageText, time)
	end

	task.wait(time4)
	camera.CameraType = Enum.CameraType.Custom
	dialogueGui.Enabled = false
	glass.Transparency = 0.6
	humanoid.JumpHeight = 7.2
	humanoid.WalkSpeed = 16
	resetButton(true)
end

local function cameraP2s()

end

local function cameraP3s()

end

local function cameraP4s()

end
--------------
local function cameraP1e()
	resetButton(false)
	local F1 = workspace:WaitForChild("F1")
	local goalCFrame = CFrame.new(Vector3.new(0, 16, 176.5), Vector3.new(0, 16, 182.5))
	humanoid.JumpHeight = 0
	humanoid.WalkSpeed = 0
	camera.CameraType = Enum.CameraType.Scriptable
	local info = TweenInfo.new(tweenTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local tween = TweenService:Create(camera, info, {CFrame = goalCFrame})
	local glass = F1:WaitForChild("MainModel"):WaitForChild("Glass")
	glass.Transparency = 1
	tween:Play()

	local function dialogue(label, message, speed)
		label.Text = ""
		for i = 1, #message do
			if player:GetAttribute("inGame") == false then
				PlayerGui.Dialogue.Enabled = false
				camera.CameraType = Enum.CameraType.Custom
				glass.Transparency = 0.6
				return	
			end
			label.Text = string.sub(message, 1, i)
			SoundEffects.Text:Play()
			task.wait(speed)
		end
	end
	
	local text1 = "That was easy, right? It was supposed to be that way."
	local text2 = "Thank you for trying my Beta!, I hope you liked it."
	
	local time1 = 3
	local textSpeed = ReplicatedStorage:GetAttribute("TimeCamera")
	textSpeed = textSpeed - time1 - time1 - tweenTime - 5
	
	local characters = #text1 + #text2
	local textTime = textSpeed / characters
	
	local messageText = text1
	local messageLabel = dialogueGui.FrameD.TextLabel
	task.wait(tweenTime)
	translate(messageText)
	dialogueGui.Enabled = true
	dialogue(messageLabel, messageText, textTime)
	task.wait(time1)
	messageText = text2
	translate(messageText)
	dialogue(messageLabel, messageText, textTime)
	task.wait(time1)
	camera.CameraType = Enum.CameraType.Custom
	dialogueGui.Enabled = false
	glass.Transparency = 0.6
	humanoid.JumpHeight = 7.2
	humanoid.WalkSpeed = 16
	resetButton(true)
end

local function cameraP2e()

end

local function cameraP3e()

end

local function cameraP4e()

end
-------------
local function admistration(attribute)
	if attribute ~= "Camera" then return end
	if player:GetAttribute("inGame") == true then
		if ReplicatedStorage:GetAttribute("Camera") == "1s" then
			cameraP1s()
		elseif ReplicatedStorage:GetAttribute("Camera") == "2s" then
			cameraP2s()
		elseif ReplicatedStorage:GetAttribute("Camera") == "3s" then
			cameraP3s()
		elseif ReplicatedStorage:GetAttribute("Camera") == "4s" then
			cameraP4s()
		elseif ReplicatedStorage:GetAttribute("Camera") == "1e" then
			cameraP1e()
		elseif ReplicatedStorage:GetAttribute("Camera") == "2e" then
			cameraP2e()
		elseif ReplicatedStorage:GetAttribute("Camera") == "3e" then
			cameraP3e()
		elseif ReplicatedStorage:GetAttribute("Camera") == "4e" then
			cameraP4e()
		end
	end
end

ReplicatedStorage.AttributeChanged:Connect(admistration)
-----------------------------------------------las camaras, depende que piso es y si es al empezar o al terminar.