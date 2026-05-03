--Administra que pasa al morir y las compras.
--NOTA: Si cambias el spawn point acordate de cambiar aqui.
--NOTA: acordate de sumar los CFrames de los otros pisos.

local diedEvent = game:GetService("ReplicatedStorage"):WaitForChild("DiedEvent")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundEvent = ReplicatedStorage:WaitForChild("SoundEvent")

diedEvent.OnServerEvent:Connect(function(player, action)
	-----------Esto cambia el atributo del piso que mueres apenas mueres y el de inGame.
	if action == "attribute" then
		task.wait(0.1)
		local humanoid = player.Character:WaitForChild("Humanoid")
		if humanoid and humanoid.Health <= 0 then
			player:SetAttribute("inGame", false)
			player:SetAttribute("deadFloor", ReplicatedStorage:GetAttribute("Floor"))
		end
	end
	------------------------Esto solo es para cambiar (y asegurar) que los atributos cambien para el servidor.
	
	if action == "false" then
		task.wait(2)
		player:LoadCharacterAsync()
		player:SetAttribute("inGame", false)
		SoundEvent:FireClient(player, "LobbyMusicOn")
		SoundEvent:FireClient(player, "ChallengeMusicOff")
	---------------------------------si estas en el lobby
	elseif action == "nothing" then
		player:LoadCharacterAsync()
		player:SetAttribute("inGame", false)
		SoundEvent:FireClient(player, "LobbyMusicOn")
		SoundEvent:FireClient(player, "ChallengeMusicOff")
	---------------------------------------si no pagaste
	elseif action == "usedCard" then
		if player:GetAttribute("Cards") > 0 then
			player:SetAttribute("Cards", player:GetAttribute("Cards") - 1)
			if ReplicatedStorage:GetAttribute("Floor") == 1 then
				player:LoadCharacterAsync()
				local character = player.Character or player.CharacterAdded:Wait()
				character:PivotTo(CFrame.new(Vector3.new(0 + math.random(-25, 25), 1, 135 + math.random(-25, 25))))
				player:SetAttribute("inGame", true)

			elseif ReplicatedStorage:GetAttribute("Floor") == 2 then

			elseif ReplicatedStorage:GetAttribute("Floor") == 3 then

			elseif ReplicatedStorage:GetAttribute("Floor") == 4 then

			end
		end
		--------------------------------------------si usas una tarjeta
	end
end)

--------------------
local function giveCard(player)--si no estas n el piso en el que moriste
	player:SetAttribute("Cards", player:GetAttribute("Cards") + 1)
	player:LoadCharacterAsync()
	SoundEvent:FireClient(player, "LobbyMusicOn")
	SoundEvent:FireClient(player, "ChallengeMusicOff")
	local playerGui = player:WaitForChild("PlayerGui")
	local cardGui = playerGui:WaitForChild("Card")
	cardGui.Enabled = true
	task.wait(10)
	cardGui.Enabled = false
end
------------------
local function buy(player)--si pagaste
	if ReplicatedStorage:GetAttribute("Floor") == 1 then
		player:LoadCharacterAsync()
		local character = player.Character or player.CharacterAdded:Wait()
		character:PivotTo(CFrame.new(Vector3.new(0 + math.random(-25, 25), 1, 135 + math.random(-25, 25))))
		player:SetAttribute("inGame", true)
		
	elseif ReplicatedStorage:GetAttribute("Floor") == 2 then
	
	elseif ReplicatedStorage:GetAttribute("Floor") == 3 then
	
	elseif ReplicatedStorage:GetAttribute("Floor") == 4 then
	
	end
end
--------------------
local function processPurchase(receiptInfo)
	local player = game.Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	
	if receiptInfo.ProductId == 3508409122 then--revivir
		local deadFloor = player:GetAttribute("deadFloor")
		local currentFloor = ReplicatedStorage:GetAttribute("Floor")
		if deadFloor == currentFloor then
			buy(player)
		else
			giveCard(player)
		end
	end
	
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

MarketplaceService.ProcessReceipt = processPurchase
----------------------------------------------------------Pone si compró o no al final, si lo compró le da lo que pago, si no,
----------------------------------------------------------el resto lo hace el local script. 
