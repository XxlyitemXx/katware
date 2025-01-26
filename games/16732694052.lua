print('Starting Fishy Business')
local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local httpService = cloneref(game:GetService('HttpService'))
local textChatService = cloneref(game:GetService('TextChatService'))
local collectionService = cloneref(game:GetService('CollectionService'))
local contextActionService = cloneref(game:GetService('ContextActionService'))
local coreGui = cloneref(game:GetService('CoreGui'))
local starterGui = cloneref(game:GetService('StarterGui'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local assetfunction = getcustomasset

local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local uipallet = vape.Libraries.uipallet
local tween = vape.Libraries.tween
local color = vape.Libraries.color
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local getfontsize = vape.Libraries.getfontsize
local getcustomasset = vape.Libraries.getcustomasset

run(function()
    local autoShake = false
    local autoShakeDelay = 0.1
    local autoShakeMethod = "KeyCodeEvent"
    local autoShakeClickOffsetX = 0
    local autoShakeClickOffsetY = 0
    local autoReel = false
    local autoReelDelay = 2
    local autoCast = false
    local autoCastMode = "Legit"
    local autoCastDelay = 2
    local ZoneCast = false
    local Zone = "Brine Pool"
    local Noclip = false
    local AntiDrown = false
    local CollarPlayer = false
    local Target = ""
    local FreezeChar = false
    local itemSpots = {
        Bait_Crate = CFrame.new(384.57513427734375, 135.3519287109375, 337.5340270996094),
        Carbon_Rod = CFrame.new(454.083618, 150.590073, 225.328827, 0.985374212, -0.170404434, 1.41561031e-07, 1.41561031e-07, 1.7285347e-06, 1, -0.170404434, -0.985374212, 1.7285347e-06),
        Crab_Cage = CFrame.new(474.803589, 149.664566, 229.49469, -0.721874595, 0, 0.692023814, 0, 1, 0, -0.692023814, 0, -0.721874595),
        Fast_Rod = CFrame.new(447.183563, 148.225739, 220.187454, 0.981104493, 1.26492232e-05, 0.193478703, -0.0522461236, 0.962867677, 0.264870107, -0.186291039, -0.269973755, 0.944674432),
        Flimsy_Rod = CFrame.new(471.107697, 148.36171, 229.642441, 0.841614008, 0.0774728209, -0.534493923, 0.00678436086, 0.988063335, 0.153898612, 0.540036798, -0.13314943, 0.831042409),
        GPS = CFrame.new(517.896729, 149.217636, 284.856842, 7.39097595e-06, -0.719539165, -0.694451928, -1, -7.39097595e-06, -3.01003456e-06, -3.01003456e-06, 0.694451928, -0.719539165),
        Long_Rod = CFrame.new(485.695038, 171.656326, 145.746109, -0.630167365, -0.776459217, -5.33461571e-06, 5.33461571e-06, -1.12056732e-05, 1, -0.776459217, 0.630167365, 1.12056732e-05),
        Lucky_Rod = CFrame.new(446.085999, 148.253006, 222.160004, 0.974526405, -0.22305499, 0.0233404674, 0.196993902, 0.901088715, 0.386306256, -0.107199371, -0.371867687, 0.922075212),
        Plastic_Rod = CFrame.new(454.425385, 148.169739, 229.172424, 0.951755166, 0.0709736273, -0.298537821, -3.42726707e-07, 0.972884834, 0.231290117, 0.306858391, -0.220131472, 0.925948203),
        Training_Rod = CFrame.new(457.693848, 148.357529, 230.414307, 1, -0, 0, 0, 0.975410998, 0.220393807, -0, -0.220393807, 0.975410998)
    }

    local fisktable = {}
    local playersService = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local GuiService = game:GetService("GuiService")
    local Workspace = game:GetService("Workspace")
	local lplr = playersService.LocalPlayer
    local SafeZone = Instance.new("Part")
    SafeZone.Parent = Workspace
    SafeZone.Size = Vector3.new(50, 2, 50)
    SafeZone.CFrame = CFrame.new(9999, 9999, 9999)
    SafeZone.Anchored = true
	local HumanoidRootPart
	
	local function getHRP()
		HumanoidRootPart = lplr.Character:WaitForChild("HumanoidRootPart")
	end
    
	local function notif(...)
		vape:CreateNotification(...)
	end
	local function setclipboard(text)
        setclipboard(text)
    end
	
    local AutoShake = vape.Categories.Minigames:CreateModule({
        Name = 'AutoShake',
		Function = function()
			getHRP()
		end,
    })
	local AutoShakeToggle = AutoShake:CreateToggle({
        Text = 'Enabled',
        Default = false,
        Tooltip = 'Automatically clicks the shake button for you',
        Function = function(Value)
            autoShake = Value
        end
	})
	local AutoShakeSettings = AutoShake:CreateDependencyBox()
	AutoShakeSettings:AddDropdown('AutoShakeMode', {
		Text = 'Auto Shake Method',
		Tooltip = 'Method to click on the shake button',
		List = {'ClickEvent', 'KeyCodeEvent' },
		Default = autoShakeMethod,
		Function = function(Value)
			autoShakeMethod = Value
		end
	})
	local AutoShakeKeyCodeEventText = AutoShakeSettings:CreateDependencyBox()
	AutoShakeKeyCodeEventText:AddLabel('Inspired from rblxscripts.net!')
	AutoShakeKeyCodeEventText:AddLabel('Huge shoutout to them.')
	AutoShakeKeyCodeEventText:SetupDependencies({{AutoShakeToggle, true}, {AutoShakeSettings.AutoShakeMode, "KeyCodeEvent"}})
	AutoShakeSettings:CreateSlider('AutoShakeDelay', {
		Text = 'AutoShake Delay',
		Default = 0.1,
		Min = 0,
		Max = 10,
		Decimal = 1,
		Function = function(Value)
			autoShakeDelay = Value
		end
	})
	AutoShakeSettings:SetupDependencies({
    	{ AutoShakeToggle, true }
	})
	
    local AutoReel = vape.Categories.Minigames:CreateModule({
        Name = 'AutoReel',
		Function = function()
			getHRP()
		end
	})
    local AutoReelToggle = AutoReel:CreateToggle({
        Text = 'Enabled',
        Default = false,
        Tooltip = 'Automatically reels in the fishing rod',
        Function = function(Value)
            autoReel = Value
        end
    })
	local AutoReelSettings = AutoReel:CreateDependencyBox()
	AutoReelSettings:AddSlider('AutoReelDelay', {
		Text = 'AutoReel Delay',
		Default = 2,
		Min = 0,
		Max = 10,
		Decimal = 1,
		Function = function(Value)
			autoReelDelay = Value
		end
	})
	AutoReelSettings:SetupDependencies({
		{ AutoReelToggle, true }
	})

    local AutoCast = vape.Categories.Minigames:CreateModule({
        Name = 'AutoCast',
		Function = function()
			getHRP()
		end
	})
    local AutoCastToggle = AutoCast:CreateToggle({
        Text = 'Enabled',
        Default = false,
        Tooltip = 'Automatically throws the rod',
        Function = function(Value)
            autoCast = Value
			if Value then
                local Tool = lplr.Character:FindFirstChildOfClass("Tool")
                if Tool ~= nil and Tool:FindFirstChild("events"):WaitForChild("cast") ~= nil then
                    task.wait(autoCastDelay)
                    if autoCastMode == "Legit" then
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, lplr, 0)
                        if HumanoidRootPart then
							HumanoidRootPart.ChildAdded:Connect(function()
								if HumanoidRootPart:FindFirstChild("power") ~= nil and HumanoidRootPart.power.powerbar.bar ~= nil then
									HumanoidRootPart.power.powerbar.bar.Changed:Connect(function(property)
										if property == "Size" then
											if HumanoidRootPart.power.powerbar.bar.Size == UDim2.new(1, 0, 1, 0) then
												VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, lplr, 0)
											end
										end
									end)
								end
							end)
						end
                    elseif autoCastMode == "Rage" then
                        Tool.events.cast:FireServer(100)
                    end
                end
            end
        end
    })
	local AutoCastSettings = AutoCast:CreateDependencyBox()
	AutoCastSettings:AddSlider('AutoCastDelay', {
		Text = 'AutoCast Delay',
		Default = 2,
		Min = 0,
		Max = 10,
		Decimal = 1,
		Function = function(Value)
			autoCastDelay = Value
		end
	})
	AutoCastSettings:AddDropdown('AutoCastMode', {
		Text = 'Auto Cast Mode',
		Tooltip = 'Change the mode of the AutoCast',
		List = {'Legit', 'Rage'},
		Default = autoCastMode,
		Function = function(Value)
			autoCastMode = Value
		end
	})
	AutoCastSettings:SetupDependencies({
		{ AutoCastToggle, true }
	})
	
	local FishUtilities = vape.Categories.Minigames:CreateModule({Name = 'Fish Utilities'})
    FishUtilities:CreateButton({
        Text = 'Sell a fish',
        Func = function()
            Workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"):WaitForChild("merchant"):WaitForChild("sell"):InvokeServer()
        end,
		Tooltip = 'Sells the fish you are holding'
    })
    FishUtilities:CreateButton({
        Text = 'Sell ALL fish',
        Func = function()
            Workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"):WaitForChild("merchant"):WaitForChild("sellall"):InvokeServer()
        end,
		Tooltip = 'Sells all your fish'
    })
    FishUtilities:CreateButton({
        Text = 'Appraise fish 🐟 (450C$)',
        Func = function()
            Workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Appraiser"):WaitForChild("appraiser"):WaitForChild("appraise"):InvokeServer()
        end,
        Tooltip = 'Appraises the fish you are holding'
    })
	
	local ZoneCastModule = vape.Categories.Minigames:CreateModule({Name = 'ZoneCast'})
	local ZoneCastToggle = ZoneCastModule:CreateToggle({
		Text = 'Enabled',
		Default = false,
		Tooltip = 'Throws the rod to another zone',
		Function = function(Value)
			ZoneCast = Value
		end
	})
	local ZoneCastDropdowns = ZoneCastModule:CreateDependencyBox()
	ZoneCastDropdowns:AddDropdown('ZoneCastValue', {
		Text = 'Zone',
		Tooltip = nil,
		List = fisktable,
		Default = Zone,
		Function = function(Value)
			Zone = Value
		end
	})
	ZoneCastDropdowns:SetupDependencies({
		{ZoneCastToggle, true}
	})

	local CollarPlayerModule = vape.Categories.Minigames:CreateModule({Name = 'CollarPlayer'})
	local CollarPlayerToggle = CollarPlayerModule:CreateToggle({
        Text = 'Enabled',
        Default = false,
        Tooltip = "Collar's the player making them look like your pet :3",
        Function = function(Value)
            CollarPlayer = Value
        end
    })
	local CollarPlayerDropdown = CollarPlayerModule:CreateDependencyBox()
    CollarPlayerDropdown:AddDropdown('CollarTarget', {
        SpecialType = 'Player',
        Text = 'Player',
        Tooltip = 'Select the player you will collar',
		Function = function(Value)
			Target = Value
		end
    })
	CollarPlayerDropdown:SetupDependencies({
    	{CollarPlayerToggle, true}
	})

	local Teleports = vape.Categories.Blatant:CreateModule({Name = "Teleports"})
	Teleports:CreateDropdown('PlaceTeleport', {
		Name = 'Place teleport',
		Tooltip = 'Teleport to a place',
		List = teleportSpots,
		Default = '',
		Function = function(Value)
			if teleportSpots ~= nil and HumanoidRootPart ~= nil then
				HumanoidRootPart.CFrame = Workspace:WaitForChild("world"):WaitForChild("spawns"):WaitForChild("TpSpots"):FindFirstChild(Value).CFrame + Vector3.new(0, 5, 0)
			end
		end
	})
	Teleports:CreateDropdown('NPCTeleport', {
		Name = 'Teleport to Npc',
		Tooltip = 'Teleport to a rod',
		List = racistPeople,
		Default = '',
		Function = function(Value)
			if racistPeople ~= nil and HumanoidRootPart ~= nil then
				HumanoidRootPart.CFrame = Workspace:WaitForChild("world"):WaitForChild("npcs"):FindFirstChild(Value):WaitForChild("HumanoidRootPart").CFrame + Vector3.new(0, 1, 0)
			end
		end
	})
	Teleports:CreateDropdown('ItemTeleport', {
		Name = 'Teleport to item',
		Tooltip = 'Teleport to a rod',
		List = {"Bait_Crate", "Carbon_Rod", "Crab_Cage", "Fast_Rod", "Flimsy_Rod", "GPS", "Long_Rod", "Lucky_Rod", "Plastic_Rod", "Training_Rod"},
		Default = '',
		Function = function(Value)
			if itemSpots ~= nil and HumanoidRootPart ~= nil then
				HumanoidRootPart.CFrame = itemSpots[Value]
			end
		end
	})

	local SafeZoneModule = vape.Categories.Blatant:CreateModule({Name = 'Safe Zone'})
	SafeZoneModule:CreateButton({
        Text = 'Teleport to safe zone',
        Func = function()
            if HumanoidRootPart then
				HumanoidRootPart.CFrame = SafeZone.CFrame + Vector3.new(0, 2, 0)
            end
        end,
        DoubleClick = false,
        Tooltip = 'Teleports you to a safe zone'
    })

    local LocalPlayer = vape.Categories.Blatant:CreateModule({Name = 'LocalPlayer'})
	LocalPlayer:CreateToggle('Noclip', {
        Text = 'Noclip',
        Default = false,
        Tooltip = 'Allows you to go through walls',
        Function = function(Value)
            Noclip = Value
			if Noclip == false then
				if lplr.Character ~= nil then
					for i, v in pairs(lplr.Character:GetDescendants()) do
						if v:IsA("BasePart") and v.CanCollide == false then
							v.CanCollide = true
						end
					end
				end
			end
        end
    })
	LocalPlayer:CreateToggle('AntiDrown', {
        Text = 'Disable Oxygen',
        Default = false,
        Tooltip = 'Allows you to stay in water infinitely',
        Function = function(Value)
            AntiDrown = Value
            if Value == true then
                if lplr.Character ~= nil and lplr.Character:FindFirstChild("client"):WaitForChild("oxygen") ~= nil and lplr.Character:FindFirstChild("client"):WaitForChild("oxygen").Enabled == true then	
                    lplr.Character.client.oxygen.Enabled = false	
                end	
                local CharAddedAntiDrownCon
				CharAddedAntiDrownCon = lplr.CharacterAdded:Connect(function()	
                    if lplr.Character ~= nil and lplr.Character:FindFirstChild("client"):WaitForChild("oxygen") ~= nil and lplr.Character:FindFirstChild("client"):WaitForChild("oxygen").Enabled == true and AntiDrown == true then	
                        lplr.Character.client.oxygen.Enabled = false	
                    end	
				end)
				
				LocalPlayer:Clean(function()
					if CharAddedAntiDrownCon then
						CharAddedAntiDrownCon:Disconnect()
					end
				end)
            else	
                if lplr.Character ~= nil and lplr.Character:FindFirstChild("client"):WaitForChild("oxygen") ~= nil and lplr.Character:FindFirstChild("client"):WaitForChild("oxygen").Enabled == false then	
                    lplr.Character.client.oxygen.Enabled = true	
                end	
            end
        end
    })
	
	local ResetRod = vape.Categories.Blatant:CreateModule({Name = 'Reset'})
    ResetRod:CreateButton({
        Text = 'Reset rod',
        Func = function()
            local tool = lplr.Character:FindFirstChildOfClass("Tool")

            if tool:FindFirstChild("events"):WaitForChild("reset") ~= nil then
                tool.events.reset:FireServer()
            end
        end,
        DoubleClick = false,
        Tooltip = 'Resets your rod'
    })
	
	local AntiAFKModule = vape.Categories.Blatant:CreateModule({Name = 'AntiAFK'})
    AntiAFKModule:CreateButton({
        Text = 'Anti-AFK',
        Func = function()
            notif("AntiAFK", "Anti-AFK is now running!", 10)
            lplr.Idled:Connect(function()
                VirtualInputManager:CaptureController()
                VirtualInputManager:ClickButton2(Vector2.new())
            end)
        end,
        DoubleClick = false,
        Tooltip = 'Disables idle kick'
    })
	
    local FreezeCharacter = vape.Categories.Blatant:CreateModule({Name = 'Freeze Character'})
    FreezeCharacter:CreateToggle({
        Text = 'Enabled',
        Default = false,
        Tooltip = "Freezes your character in current location",
        Function = function(Value)
            local oldpos = HumanoidRootPart and HumanoidRootPart.CFrame or CFrame.new()
            FreezeChar = Value
            task.wait()
            while task.wait() and FreezeChar and HumanoidRootPart ~= nil do
                HumanoidRootPart.CFrame = oldpos
            end
        end
    })

	local Settings = vape.Categories.Blatant:CreateModule({Name = 'Settings'})
	Settings:CreateButton('Unload', function() vape:Unload() end)

	local Credits = vape.Categories.Blatant:CreateModule({Name = 'Credits'})
	Credits:AddLabel('Made by kylosilly and netpa!')
	Credits:AddLabel('Made with love and hate :3')
	Credits:CreateButton({
		Text = 'Copy Fisch Discord Link',
		Func = function()
			setclipboard('https://discord.gg/DEkfE99JFh')
		end,
		DoubleClick = false,
		Tooltip = 'Join our fisch discord!'
	})
	Credits:CreateButton({
		Text = 'Copy Main Discord link',
		Func = function()
			setclipboard('https://discord.gg/VudXCDCaBN')
		end,
		DoubleClick = false,
		Tooltip = 'Join our main discord!'
	})
	Credits:AddLabel('البرود يا جماعه هو الحل')

	local function autoreel_function(GUI)
         if GUI:IsA("ScreenGui") and GUI.Name == "reel" then
            if autoReel and ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished") ~= nil then
                repeat task.wait(autoReelDelay) ReplicatedStorage.events.reelfinished:FireServer(100, false) until GUI == nil
            end
        end
	end
	local function autoShake_function(GUI)
        if GUI:IsA("ScreenGui") and GUI.Name == "shakeui" then
            if GUI:FindFirstChild("safezone") ~= nil then
                GUI.safezone.ChildAdded:Connect(function(child)
                    if child:IsA("ImageButton") and child.Name == "button" then
                        if autoShake == true then
                            task.wait(autoShakeDelay)
                            if child.Visible == true then
                                if autoShakeMethod == "ClickEvent" then
                                    local pos = child.AbsolutePosition
                                    local size = child.AbsoluteSize
                                    VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, true, lplr, 0)
                                    VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, false, lplr, 0)
                                --[[elseif autoShakeMethod == "firesignal" then
                                    firesignal(child.MouseButton1Click)]]
                                elseif autoShakeMethod == "KeyCodeEvent" then
                                    while task.wait() and autoShake and GUI.safezone:FindFirstChild(child.Name) ~= nil  do
                                        pcall(function()
                                            GuiService.SelectedObject = child
                                            if GuiService.SelectedObject == child then
                                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.ButtonA, false, game)
                                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.ButtonA, false, game)
                                            end
                                        end)
                                    end
                                    GuiService.SelectedObject = nil
                                end
                            end
                        end
                    end
                end)
            end
        end
	end
	
	local autoCastfunction = function(child)
		if child:IsA("Tool") and child:FindFirstChild("events"):WaitForChild("cast") ~= nil and autoCast then
			task.wait(autoCastDelay)
			if autoCastMode == "Legit" then
				VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, lplr, 0)
				if HumanoidRootPart then
				HumanoidRootPart.ChildAdded:Connect(function()
					if HumanoidRootPart:FindFirstChild("power") ~= nil and HumanoidRootPart.power.powerbar.bar ~= nil then
						HumanoidRootPart.power.powerbar.bar.Changed:Connect(function(property)
							if property == "Size" then
								if HumanoidRootPart.power.powerbar.bar.Size == UDim2.new(1, 0, 1, 0) then
									VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, lplr, 0)
								end
							end
						end)
					end
					end)
				end
			elseif autoCastMode == "Rage" then
				child.events.cast:FireServer(100)
			end
		end
	end
	
	
	
    local autoReelCon
    local autoShakeCon
    local autoCastCon
	local autoCastCon2
    local zoneCon
    local collarCon
    local NoclipCon
	
	Main:Clean(function()
		if autoReelCon then autoReelCon:Disconnect() end
		if autoShakeCon then autoShakeCon:Disconnect() end
		if autoCastCon then autoCastCon:Disconnect() end
		if autoCastCon2 then autoCastCon2:Disconnect() end
		if zoneCon then zoneCon:Disconnect() end
		if collarCon then collarCon:Disconnect() end
		if NoclipCon then NoclipCon:Disconnect() end
	end)
    
	autoReelCon = lplr.PlayerGui.ChildAdded:Connect(autoreel_function)
    autoShakeCon = lplr.PlayerGui.ChildAdded:Connect(autoShake_function)
    autoCastCon = lplr.Character.ChildAdded:Connect(autoCastfunction)
    autoCastCon2 = lplr.PlayerGui.ChildRemoved:Connect(function(GUI)
        if GUI.Name == "reel" and autoCast == true and lplr.Character:FindFirstChildOfClass("Tool") ~= nil and lplr.Character:FindFirstChildOfClass("Tool"):FindFirstChild("events"):WaitForChild("cast") ~= nil then
			task.spawn(autoCastfunction, lplr.Character:FindFirstChildOfClass("Tool"))
        end
	end)

    zoneCon = lplr.Character.ChildAdded:Connect(function(child)
        if ZoneCast and child:IsA("Tool") and Workspace:WaitForChild("zones"):WaitForChild("fishing"):FindFirstChild(Zone) ~= nil then
            child.ChildAdded:Connect(function(blehh)
                if blehh.Name == "bobber" then
                    local RopeConstraint = blehh:FindFirstChildOfClass("RopeConstraint")
                    if ZoneCast and RopeConstraint ~= nil then
                        RopeConstraint.Changed:Connect(function(property)
                            if property == "Length" then
                                RopeConstraint.Length = math.huge
                            end
                        end)
                        RopeConstraint.Length = math.huge
                    end
                    task.wait(1)
                    while task.wait() and ZoneCast and blehh.Parent ~= nil do
                        blehh.CFrame = Workspace:WaitForChild("zones"):WaitForChild("fishing")[Zone].CFrame
                    end
                end
            end)
        end
    end)

    collarCon = lplr.Character.ChildAdded:Connect(function(child)
        if CollarPlayer and child:IsA("Tool") and Players:FindFirstChild(Target) and Players:FindFirstChild(Target).Character:FindFirstChild("Head") ~= nil then
            child.ChildAdded:Connect(function(blehh)
                if blehh.Name == "bobber" then
                    local RopeConstraint = blehh:FindFirstChildOfClass("RopeConstraint")
                    if CollarPlayer and RopeConstraint ~= nil then
                        RopeConstraint.Changed:Connect(function(property)
                            if property == "Length" then
                                RopeConstraint.Length = math.huge
                            end
                        end)
                        RopeConstraint.Length = math.huge
                    end
                    task.wait(1)
                    while task.wait() and CollarPlayer and blehh.Parent ~= nil and Players:FindFirstChild(Target) and Players:FindFirstChild(Target).Character:FindFirstChild("Head") ~= nil do
                        blehh.CFrame = Players:FindFirstChild(Target).Character:FindFirstChild("Head").CFrame + Vector3.new(0, -1, 0)
                    end
                end
            end)
        end
    end)
	
    NoclipCon = RunService.Stepped:Connect(function()
        if Noclip == true then
            if lplr.Character ~= nil then
                for i, v in pairs(lplr.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide == true then
                        v.CanCollide = false
                    end
                end
            end
        end
    end)
    
    for i, v in pairs(Workspace:WaitForChild("zones"):WaitForChild("fishing"):GetChildren()) do
        if table.find(fisktable, v.Name) == nil then
            table.insert(fisktable, v.Name)
        end
    end
end)