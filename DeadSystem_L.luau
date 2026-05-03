--Maneja el sistema de cuando el juador entra en la ronda y al server, y cuando muere.

--NOTA IMPORTANTE: ACORDATE DE CUANDO LE PONGAS VIDA AL CIENTIFICO O ALGO ASI, HACER QUE SI ES POCA, NO ACTIVE EL
--SISTEMA DE REVIVIR, NI ACTIVE EL PROMPT.PRODUCT.PURCHASE, SINO QUE VAYA COMO SI ESTUVIERA EN EL LOBBY.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

if not player:GetAttribute("inGame") then
	player:SetAttribute("inGame", false)
end

local diedEvent = game.ReplicatedStorage.DiedEvent
local reviveId = 3508409122
local info = MarketplaceService:GetProductInfoAsync(reviveId, Enum.InfoType.Product)
local PlayerGui = player.PlayerGui
local reviveGUI = PlayerGui.Revive
local buyButton = reviveGUI.Frame.FrameI.TextButtonBuy
local cardButton = reviveGUI.Frame.FrameI.TextButtonCard
local priceText = reviveGUI.Frame.FrameI.TextButtonBuy.TextLabel
local timer = reviveGUI.Frame.FrameI.Timer
local heart = reviveGUI.Frame.Frame.ImageLabel
local playerBuy = false
local cardGUI = PlayerGui.Card
---------------------------------------------------------
buyButton.MouseButton1Click:Connect(function()
	buyButton.Interactable = false
	playerBuy = true
	MarketplaceService:PromptProductPurchase(player, reviveId)
end)
--------------------------------------------------si tocaste el boton para comprar cambia una variable y se detiene
--------------------------------------------------la funcion un poco mas adelante.
cardButton.MouseButton1Click:Connect(function()
	cardButton.Interactable = false
	playerBuy = true
	reviveGUI.Enabled = false
	GuiService.SelectedObject = nil
	diedEvent:FireServer("usedCard")
end)
-------------Si tocaste el boton para gastar una tarjeta, cambia una variable y se detiene la funcion de abajo.
local function died()
	diedEvent:FireServer("attribute")
	playerBuy = false
	if player:GetAttribute("inGame") == false then
		diedEvent:FireServer("false")

	elseif player:GetAttribute("inGame") == nil then
		diedEvent:FireServer("false")

	else
		timer.Text = 5
		if player:GetAttribute("Cards") == 0 then
			buyButton.Interactable = true
			buyButton.Visible = true
			cardButton.Interactable = false
			cardButton.Visible = false
			priceText.Text = info.PriceInRobux
			heart.Size = UDim2.new(1, 0, 1, 0)
		else
			buyButton.Interactable = false
			buyButton.Visible = false
			cardButton.Interactable = true
			cardButton.Visible = true
		end
		
		reviveGUI.Enabled = true
		
		if UserInputService.GamepadEnabled then
			if buyButton.Interactable == true then
				GuiService.SelectedObject = buyButton
			elseif cardButton.Interactable == true then
				GuiService.SelectedObject = cardButton
			end
		end

		for index = 5, 0, -1 do
			if playerBuy == true then return end
			timer.Text = index
			local goalSize1 = UDim2.new(1.2, 0, 1.2, 0)
			local info1 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, true)
			local tween1 = TweenService:Create(heart, info1, {Size = goalSize1})
			tween1:Play()
			task.wait(1)
		end
		
		reviveGUI.Enabled = false
		GuiService.SelectedObject = nil
		
		if playerBuy == false then
			diedEvent:FireServer("nothing")
		end
	end
end

local function character(newCharacter)
	if player.Character then
		character = newCharacter
		humanoid = character:WaitForChild("Humanoid")
		humanoid.Died:Connect(died)--si moriste.
	end
end

player.CharacterAdded:Connect(character)
--------------------------esto actualiza el humanoid y el character y el sensor de muerte.

if player.Character then
	character(player.Character)
end
--------------------------esto hace que la funcion de arriba se ejecute solo una vez con el primer character.

local function completePurchase(userId, productId, isPurchased)
	local player = game.Players:GetPlayerByUserId(userId)
	if productId == reviveId then
		if isPurchased == true then
			reviveGUI.Enabled = false
			GuiService.SelectedObject = nil
			print("Thanks " .. player.Name .. " for buy the second chance")
		else
			reviveGUI.Enabled = false
			GuiService.SelectedObject = nil
			diedEvent:FireServer("nothing")
		end
	end
end

MarketplaceService.PromptProductPurchaseFinished:Connect(completePurchase)
-------------------------------------------------------------------------esto es una vez hecha la compra. 
