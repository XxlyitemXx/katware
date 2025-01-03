-- loader.lua
local rootFolder = "katware/" -- Define the root folder

repeat task.wait() until game:IsLoaded()
if shared.vape then shared.vape:Uninject() end

if identifyexecutor and ({identifyexecutor()})[1] == 'Argon' then
	getgenv().setthreadidentity = nil
end

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
local playersService = cloneref(game:GetService('Players'))

local function  downloadFile(path, func)
    local fullPath = rootFolder .. path
    if not isfile(fullPath) then
        local suc, res = pcall(function()
            return game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/katware/refs/heads/main/'..path, true)
        end)
        if not suc or res == "404: Not Found" then
            error(res)
        end
        writefile(fullPath, res)
    end
    return (func or readfile)(fullPath)
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
					loadstring(game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/katware'..'/loader.lua', true), 'loader')()
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

	if not shared.vapereload then
		if not vape.Categories then return end
		if vape.Categories.Main.Options['GUI bind indicator'].Enabled then
			vape:CreateNotification('Kittykat Finished Loading', vape.VapeButton and 'Press the button in the top right to open GUI (whatever i did)' or 'Press '..table.concat(vape.Keybind, ' + '):upper()..' to open GUI', 5)
		end
	end
end

local guiProfilePath = rootFolder .. 'profiles/gui.txt' -- Define gui profile path
if not isfile(guiProfilePath) then
	writefile(guiProfilePath, 'new')
end
local gui = readfile(guiProfilePath)

local assetsPath = rootFolder .. 'assets/'..gui
if not isfolder(assetsPath) then
	makefolder(assetsPath)
end
vape = loadstring(downloadFile('guis/'..gui..'.lua'), 'gui')()
shared.vape = vape

if not shared.VapeIndependent then
	loadstring(downloadFile('games/universal.lua'), 'universal')()
    local gameSpecificPath = 'games/'..game.PlaceId..'.lua'
	if isfile(rootFolder..gameSpecificPath) then
		loadstring(readfile(rootFolder..gameSpecificPath), tostring(game.PlaceId))(...)
    else
		if not shared.VapeDeveloper then
			local suc, res = pcall(function()
				return game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/katware'..'/games/'..game.PlaceId..'.lua', true)
			end)
			if suc and res ~= '404: Not Found' then
                downloadFile(gameSpecificPath)
				loadstring(readfile(rootFolder..gameSpecificPath), tostring(game.PlaceId))(...)
			end
		end
	end
	finishLoading()
else
	vape.Init = finishLoading
    return vape
end