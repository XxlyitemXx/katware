local run = function(func) func() end
local cloneref = cloneref or function(obj) return obj end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local inputService = cloneref(game:GetService('UserInputService'))

local lplr = playersService.LocalPlayer
local katware = shared.katware
local entitylib = katware.Libraries.entity
local sessioninfo = katware.Libraries.sessioninfo
local bedwars = {}

local function notif(...)
	return katware:CreateNotification(...)
end

run(function()
	local function dumpRemote(tab)
		local ind = table.find(tab, 'Client')
		return ind and tab[ind + 1] or ''
	end

	local KnitInit, Knit
	repeat
		KnitInit, Knit = pcall(function() return debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6) end)
		if KnitInit then break end
		task.wait()
	until KnitInit
	if not debug.getupvalue(Knit.Start, 1) then
		repeat task.wait() until debug.getupvalue(Knit.Start, 1)
	end
	local Flamework = require(replicatedStorage['rbxts_include']['node_modules']['@flamework'].core.out).Flamework
	local Client = require(replicatedStorage.TS.remotes).default.Client

	bedwars = setmetatable({
		Client = Client,
		CrateItemMeta = debug.getupvalue(Flamework.resolveDependency('client/controllers/global/reward-crate/crate-controller@CrateController').onStart, 3),
		Store = require(lplr.PlayerScripts.TS.ui.store).ClientStore
	}, {
		__index = function(self, ind)
			rawset(self, ind, Knit.Controllers[ind])
			return rawget(self, ind)
		end
	})

	local kills = sessioninfo:AddItem('Kills')
	local beds = sessioninfo:AddItem('Beds')
	local wins = sessioninfo:AddItem('Wins')
	local games = sessioninfo:AddItem('Games')

	katware:Clean(function()
		table.clear(bedwars)
	end)
end)

for _, v in katware.Modules do
	if v.Category == 'Combat' or v.Category == 'Minigames' then
		katware:Remove(i)
	end
end

run(function()
	local Sprint
	local old
	
	Sprint = katware.Categories.Combat:CreateModule({
		Name = 'Sprint',
		Function = function(callback)
			if callback then
				if inputService.TouchEnabled then pcall(function() lplr.PlayerGui.MobileUI['2'].Visible = false end) end
				old = bedwars.SprintController.stopSprinting
				bedwars.SprintController.stopSprinting = function(...)
					local call = old(...)
					bedwars.SprintController:startSprinting()
					return call
				end
				Sprint:Clean(entitylib.Events.LocalAdded:Connect(function() bedwars.SprintController:stopSprinting() end))
				bedwars.SprintController:stopSprinting()
			else
				if inputService.TouchEnabled then pcall(function() lplr.PlayerGui.MobileUI['2'].Visible = true end) end
				bedwars.SprintController.stopSprinting = old
				bedwars.SprintController:stopSprinting()
			end
		end,
		Tooltip = 'Sets your sprinting to true.'
	})
end)
	
run(function()
	local AutoGamble
	
	AutoGamble = katware.Categories.Minigames:CreateModule({
		Name = 'AutoGamble',
		Function = function(callback)
			if callback then
				AutoGamble:Clean(bedwars.Client:GetNamespace('RewardCrate'):Get('CrateOpened'):Connect(function(data)
					if data.openingPlayer == lplr then
						local tab = bedwars.CrateItemMeta[data.reward.itemType] or {displayName = data.reward.itemType or 'unknown'}
						notif('AutoGamble', 'Won '..tab.displayName, 5)
					end
				end))
	
				repeat
					if not bedwars.CrateAltarController.activeCrates[1] then
						for _, v in bedwars.Store:getState().Consumable.inventory do
							if v.consumable:find('crate') then
								bedwars.CrateAltarController:pickCrate(v.consumable, 1)
								task.wait(1.2)
								if bedwars.CrateAltarController.activeCrates[1] and bedwars.CrateAltarController.activeCrates[1][2] then
									bedwars.Client:GetNamespace('RewardCrate'):Get('OpenRewardCrate'):SendToServer({
										crateId = bedwars.CrateAltarController.activeCrates[1][2].attributes.crateId
									})
								end
								break
							end
						end
					end
					task.wait(1)
				until not AutoGamble.Enabled
			end
		end,
		Tooltip = 'Automatically opens lucky crates, piston inspired!'
	})
end)

run(function()
	local AutoQueueDuels
	local AutoQueueDuelsNotification = { Enabled = true }
	local AutoQueuedelay
	local delay
	AutoQueueDuels = katware.Categories.Utility:CreateModule({
		Name = "AutoQueueDuels",
		Function = function(callback)
			if callback then
				notif('AutoQueueDuels', 'Queueing for Duels in '..delay..'s', delay)
				task.wait(delay)
				local args = {
					[1] = {	
						["queueType"] = "bedwars_duels"
					}
				}
				game:GetService("ReplicatedStorage"):WaitForChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events"):WaitForChild("joinQueue"):FireServer(unpack(args))
				
			end
		end,
		Tooltip = 'Automatically queues for duels.'
	})
	AutoQueuedelay = AutoQueueDuels:CreateSlider({
		Name = 'Delay',
		Min = 1,
		Max = 120,
		Function = function(val)
			delay = val
		end
	})
end)
run(function()
    local SetEmote = {}
    local SetEmoteList = {}
    local oldemote
    local emo2 = {}
    local emoting = false

    -- Function to check if player is alive
    local function IsAlive(plr)
        plr = plr or lplr
        if not plr.Character then return false end
        if not plr.Character:FindFirstChild("Head") then return false end
        if not plr.Character:FindFirstChild("Humanoid") then return false end
        if plr.Character:FindFirstChild("Humanoid").Health < 0.11 then return false end
        return true
    end

    SetEmote = katware.Categories.Utility:CreateModule({
        Name = 'SetEmote',
        Function = function(callback)
            if callback then
                -- Store original emote
                oldemote = lplr:GetAttribute('EmoteTypeSlot1')
                -- Set new emote
                lplr:SetAttribute('EmoteTypeSlot1', emo2[SetEmoteList.Value])

                -- Handle emote animation
                SetEmote:Clean(lplr.PlayerGui.ChildAdded:Connect(function(v)
                    local anim
                    if tostring(v) == 'RoactTree' and IsAlive(lplr) and not emoting then 
                        v:WaitForChild('1'):WaitForChild('1')
                        if not v['1']:IsA('ImageButton') then 
                            return 
                        end
                        v['1'].Visible = false
                        emoting = true

                        -- Call emote server event
                        bedwars.Client:Get('Emote'):CallServer({
                            emoteType = lplr:GetAttribute('EmoteTypeSlot1')
                        })

                        local oldpos = lplr.Character:WaitForChild("HumanoidRootPart").Position 

                        -- Special handling for nightmare emote
                        if tostring(lplr:GetAttribute('EmoteTypeSlot1')):lower():find('nightmare') then 
                            anim = Instance.new('Animation')
                            anim.AnimationId = 'rbxassetid://9191822700'
                            anim = lplr.Character:WaitForChild("Humanoid").Animator:LoadAnimation(anim)
                            
                            task.spawn(function()
                                repeat 
                                    anim:Play()
                                    anim.Completed:Wait()
                                until not anim
                            end)
                        end

                        -- Wait until player moves or dies
                        repeat 
                            task.wait() 
                        until ((lplr.Character:WaitForChild("HumanoidRootPart").Position - oldpos).Magnitude >= 0.3 or not IsAlive(lplr))

                        -- Clean up animation
                        pcall(function() 
                            if anim then
                                anim:Stop() 
                            end
                        end)
                        anim = nil
                        emoting = false

                        -- Cancel emote server event
                        bedwars.Client:Get('EmoteCancelled'):CallServer({
                            emoteType = lplr:GetAttribute('EmoteTypeSlot1')
                        })
                    end
                end))
            else
                -- Restore original emote when disabled
                if oldemote then 
                    lplr:SetAttribute('EmoteTypeSlot1', oldemote)
                    oldemote = nil 
                end
            end
        end,
        Tooltip = 'Sets your emote animation'
    })
end)