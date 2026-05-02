--Maneja los sondidos y la musica del juego.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local soundEvent = ReplicatedStorage:WaitForChild("SoundEvent")
local SoundService = game:GetService("SoundService")
local SoundEffects = SoundService:WaitForChild("SoundEffects")
local BackgroundMusic = SoundService:WaitForChild("BackgroundMusic")

soundEvent.OnClientEvent:Connect(function(signal)
	----------------Musica ambiental
	if signal == "LobbyMusicOff" then
		BackgroundMusic.LobbyMusic:Stop()
	elseif signal == "LobbyMusicOn" then
		BackgroundMusic.LobbyMusic:Play()
	elseif signal == "ChallengeMusicOn" then
		BackgroundMusic.ChallengeMusic:Play()
	elseif signal == "ChallengeMusicOff" then
		BackgroundMusic.ChallengeMusic:Stop()
	end
	----------------Efectos de sonido
	if signal == "LaserHit" then
		SoundEffects.LaserHit:Play()
	elseif signal == "LaserMoving" then
		SoundEffects.LaserMoving:Play()
	elseif signal == "WindOn" then
		SoundEffects.Wind:Play()
	elseif signal == "WindOff" then
		SoundEffects.Wind:Stop()
	elseif signal == "Bubbles" then
		SoundEffects.Bubbles:Play()
		task.wait(0.5)
		SoundEffects.Bubbles1:Play()
	elseif signal == "Drink" then
		SoundEffects.Drink:Play()
	end
end)