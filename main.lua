repeat task.wait() until game:IsLoaded()
if shared.vape then shared.vape:Uninject() end
print("Injecting Katware | BIG THANKS TO 7GrandDadPGN! Check out his work vapeV4!")
print("https://github.com/7GrandDadPGN/VapeV4ForRoblox")

local playersService = cloneref(game:GetService('Players'))
local vape
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then
		vape:CreateNotification('Katware', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
local queue_on_teleport = queue_on_teleport or function() end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local cloneref = cloneref or function(obj)
	return obj
end


local function downloadFile(file, path)
    if isfile(path) then
        local suc, res = pcall(function()
            return game:HttpGet('https://github.com/XxlyitemXx/katware/raw/main/'..file, true)
        end)
        if not suc or res == "404: Not Found" then
            error(res)
        end
        writefile(path, res)
    end
    return readfile(path)
end


local function finishLoading()
	vape.Init = nil
	vape:Load()
	task.spawn(function()
		repeat
			vape:Save()
			task.wait(10)
		until not vape.Loaded
	end)

	local teleportedServers
	vape:Clean(playersService.LocalPlayer.OnTeleport:Connect(function()
		if (not teleportedServers) and (not shared.VapeIndependent) then
			teleportedServers = true
			local teleportScript = [[
				shared.vapereload = true
				if shared.VapeDeveloper then
					loadstring(readfile('katware/loader.lua'), 'loader')()
				else
					loadstring(game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/katware/refs/heads/main/loader.lua', true), 'loader')()
				end
			]]
			if shared.VapeDeveloper then
				teleportScript = 'shared.VapeDeveloper = true\n'..teleportScript
			end
			if shared.VapeCustomProfile then
				teleportScript = 'shared.VapeCustomProfile = "'..shared.VapeCustomProfile..'"\n'..teleportScript
			end
			vape:Save()
			queue_on_teleport(teleportScript)
		end
	end))
end

if not isfile('katware/profiles/gui.txt') then
	writefile('katware/profiles/gui.txt', 'new')
end
local gui = readfile('katware/profiles/gui.txt')

if not isfolder('katware/assets/'..gui) then
	makefolder('katware/assets/'..gui)
end

if not isfile('katware/profiles/gui.txt') then
	writefile('katware/profiles/gui.txt', 'new')
end
local gui = readfile('katware/profiles/gui.txt')

if not isfolder('katware/assets/new/') then
	makefolder('katware/assets/new/')
end
vape = loadstring(downloadFile('guis/new.lua', 'katware/guis/'))()
shared.vape = vape
if not shared.VapeIndependent then
	downloadFile('games/universal.lua', 'katware/games/')
	loadfile('katware/games/universal.lua')()
	if isfile('katware/games/'..game.PlaceId..'.lua') then
		downloadFile('games/'..game.PlaceId..'.lua', 'katware/games/')
		loadfile('katware/games/'..game.PlaceId..'.lua')()
	else
		if not shared.VapeDeveloper then
			local suc, res = pcall(function()
				return game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/katware/raw/main'..'/games/'..game.PlaceId..'.lua', true)
			end)
			if suc and res ~= '404: Not Found' then
				downloadFile('katware/games/'..game.PlaceId..'.lua', 'katware/games/')
				loadfile('katware/games/'..game.PlaceId..'.lua')()
			end
		end
	end
	finishLoading()
else
	vape.Init = finishLoading
	return vape
end
vape:CreateNotification('Katware Finished Loading', vape.VapeButton and 'Press the button in the top right to open GUI (whatever i did)' or 'Press '..table.concat(vape.Keybind, ' + '):upper()..' to open GUI', 5)
