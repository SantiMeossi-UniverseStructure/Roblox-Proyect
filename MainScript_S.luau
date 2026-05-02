--Modifica el cartel y inicia la ronda, asigna los jugadores a un array aqui y al del ModuleScript, organiza todo.
--Maneja también los datos que se guardan a cada jugador, el DataStoreService.
--NOTA: no olvides que si pones el cartel en algo más aparte del workspace, modificar.
--NOTA: si cambias el nombre al ModuleScript, modificar.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local F1Module = require(ReplicatedStorage.F1Challenges)
local F2Module = require(ReplicatedStorage.F2Challenges)
local F3Module = require(ReplicatedStorage.F3Challenges)
local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("DataStore")
local SoundService = game:GetService("SoundService")
local SoundEvent = ReplicatedStorage:WaitForChild("SoundEvent")
local MarketPlaceService = game:GetService("MarketplaceService")
local ServerStorage = game:GetService("ServerStorage")

game:BindToClose(function()
	task.wait(2)
end)
--Esto lo da tiempo al ultimo jugador que salga de que se guarden sus datos.

local playersInGame = {}

local function addPlayers(playerAdded)
	F1Module.addPlayers(playerAdded)
	F2Module.addPlayers(playerAdded)
	F3Module.addPlayers(playerAdded)
	table.insert(playersInGame, playerAdded)
	local playerId = "Player_" .. playerAdded.UserId
	local succes, data = pcall(function()
		return DataStore:GetAsync(playerId)
	end)
	if succes then
		local finalData = data or {Cards = 0}--aqui pones mas.
		playerAdded:SetAttribute("Cards", finalData.Cards)
		--Agrega si hace falta.
		print("Datos de " .. playerAdded.Name .. " cargados correctamente")
	else
		warn("No se cargaron los datos de " .. playerAdded.Name)
	end
	
	local successVer, havePass = pcall(MarketPlaceService.UserOwnsGamePassAsync, MarketPlaceService, playerAdded.UserId, 1772045606)
	if not successVer then
		warn("Error while checking if player has pass")
	else
		if havePass == true then
			local potion = ServerStorage:WaitForChild("Potion"):Clone()
			local potion2 = ServerStorage:WaitForChild("Potion"):Clone()
			potion.Parent = playerAdded:WaitForChild("Backpack")
			potion2.Parent = playerAdded:WaitForChild("StarterGear")
		end
	end
	print("Se unió el jugador: " .. playerAdded.Name)
end
--------------------------agrega players y carga los datos y los pone en atributos.

local function removePlayers(playerRemoved)
	F1Module.removePlayers(playerRemoved)
	F2Module.removePlayers(playerRemoved)
	F3Module.removePlayers(playerRemoved)
	for index, value in ipairs(playersInGame) do
		if value == playerRemoved then
			table.remove(playersInGame, index)
			print("Salió el jugador: " .. playerRemoved.Name)
			break
		end
	end
	local playerId = "Player_" .. playerRemoved.UserId
	
	local dataToSave = {
		Cards = playerRemoved:GetAttribute("Cards") or 0
		--Aqui agregas los demas que hagan falta.
	}

	local succes, error = pcall(function()
		DataStore:SetAsync(playerId, dataToSave)
	end)
	
	if succes then
		print("Datos de " .. playerRemoved.Name .. " guardados correctamente")
	else
		warn("Error al guardar los datos de " .. playerRemoved.Name .. ": " .. error)
	end
end
-----------------------------quita players y gurda los datos y los pone en un DataStore.

Players.PlayerAdded:Connect(addPlayers)
Players.PlayerRemoving:Connect(removePlayers)

SoundService:WaitForChild("BackgroundMusic"):WaitForChild("LobbyMusic"):Play()

local poster = workspace.P
local frame = poster.SurfaceGui.Frame
local text = frame.RemainingTime

while true do
text.Text = " Remaining time: 20"

for index = 20, 0, -1 do
	task.wait(1)
	text.Text = " Remaining time: " .. index
	if index == 0 then
		text.Text = " Teleporting..."
		for index, player in ipairs(playersInGame) do
			local character = playersInGame[index].Character
			local humanoid = character.Humanoid
			if humanoid.Health ~= 0 then
				player:SetAttribute("inGame", true)
				character:PivotTo(CFrame.new(Vector3.new(0 + math.random(-30, 30), 1, 135 + math.random(-30, 30))))
				SoundEvent:FireClient(player, "LobbyMusicOff")
			end
		end
		ReplicatedStorage:SetAttribute("Floor", 1)
		local challengeNum = math.random(1, 3)
		if challengeNum == 1 then
			ReplicatedStorage:SetAttribute("Challenge", "Lasers")
			
		elseif challengeNum == 2 then
			ReplicatedStorage:SetAttribute("Challenge", "Chemicals")
			
		elseif challengeNum == 3 then
			ReplicatedStorage:SetAttribute("Challenge", "Wind")
			
		elseif challengeNum == 4 then
			ReplicatedStorage:SetAttribute("Challenge", "")
			
		elseif challengeNum == 5 then
			ReplicatedStorage:SetAttribute("Challenge", "")
			
		end--Selecciona un challenge aleatorio cambia el atributo y lo ejecuta.
		break
	end
end
-------------empieza el piso uno al terminarse el tiempo.
task.wait(3)

text.Text = "  Round in game"
text.Text = "  In game"

local timeCamera = 30
ReplicatedStorage:SetAttribute("TimeCamera", timeCamera)

ReplicatedStorage:SetAttribute("Camera", "1s")

for i, player in ipairs(playersInGame) do
	if player:GetAttribute("inGame") == true then
		task.wait(timeCamera + 5)
		break
	end
end

timeCamera = 0
ReplicatedStorage:SetAttribute("TimeCamera", timeCamera)--Este sistema manda cuanto tiene que esperar la cámara del jugador.

for i, player in ipairs(playersInGame) do
	if player:GetAttribute("inGame") == true then
		SoundEvent:FireClient(player, "ChallengeMusicOn")
	end
end

for i, player in ipairs(playersInGame) do
	if player:GetAttribute("inGame") == true then
		if ReplicatedStorage:GetAttribute("Challenge") == "Lasers" then
			task.wait(1)
			F1Module.f1c1()
			task.wait(2.5)
		elseif ReplicatedStorage:GetAttribute("Challenge") == "Chemicals" then
			task.wait(1)
			F1Module.f1c2()
			task.wait(2.5)
		elseif ReplicatedStorage:GetAttribute("Challenge") == "Wind" then
			task.wait(1)
			F1Module.f1c3()
			task.wait(2.5)
		end
		break
	end
end

ReplicatedStorage:SetAttribute("Camera", "1e")
for i, player in ipairs(playersInGame) do
	if player:GetAttribute("inGame") == true then
		SoundEvent:FireClient(player, "ChallengeMusicOff")
	end
end

timeCamera = 15
ReplicatedStorage:SetAttribute("TimeCamera", timeCamera)

ReplicatedStorage:SetAttribute("Floor", 0)

for i, player in ipairs(playersInGame) do
	if player:GetAttribute("inGame") == true then
		task.wait(timeCamera + 5)
		break
	end
end

timeCamera = 0
ReplicatedStorage:SetAttribute("TimeCamera", timeCamera)

SoundEvent:FireAllClients("ChallengeMusicOff")
for i, player in ipairs(playersInGame) do
	if player:GetAttribute("inGame") == true then
		player:SetAttribute("inGame", false)
		player:LoadCharacterAsync()
		SoundEvent:FireClient(player, "LobbyMusicOn")
	end
end
end