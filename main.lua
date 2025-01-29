repeat task.wait() until game:IsLoaded()
if shared.katware then shared.katware:Uninject() end

if identifyexecutor then
	if table.find({'Argon', 'Wave'}, ({identifyexecutor()})[1]) then
		getgenv().setthreadidentity = nil
	end
end

local katware
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and katware then
		katware:CreateNotification('Katware', 'Failed to load : '..err, 30, 'alert')
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

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/katware/'..readfile('katware/profiles/commit.txt')..'/'..select(1, path:gsub('katware/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after katware updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function finishLoading()
	katware.Init = nil
	katware:Load()
	task.spawn(function()
		repeat
			katware:Save()
			task.wait(10)
		until not katware.Loaded
	end)

	local teleportedServers
	katware:Clean(playersService.LocalPlayer.OnTeleport:Connect(function()
		if (not teleportedServers) and (not shared.KatwareIndependent) then
			teleportedServers = true
			local teleportScript = [[
				shared.katwarereload = true
				if shared.KatwareDeveloper then
					loadstring(readfile('katware/loader.lua'), 'loader')()
				else
					loadstring(game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/katware/'..readfile('katware/profiles/commit.txt')..'/loader.lua', true), 'loader')()
				end
			]]
			if shared.KatwareDeveloper then
				teleportScript = 'shared.KatwareDeveloper = true\n'..teleportScript
			end
			if shared.KatwareCustomProfile then
				teleportScript = 'shared.KatwareCustomProfile = "'..shared.KatwareCustomProfile..'"\n'..teleportScript
			end
			katware:Save()
			queue_on_teleport(teleportScript)
		end
	end))

	if not shared.katwarereload then
		if not katware.Categories then return end
		if katware.Categories.Main.Options['GUI bind indicator'].Enabled then
			katware:CreateNotification('Finished Loading', katware.KatwareButton and 'Press the button in the top right to open GUI' or 'Press '..table.concat(katware.Keybind, ' + '):upper()..' to open GUI', 5)
		end
	end
end

if not isfile('katware/profiles/gui.txt') then
	writefile('katware/profiles/gui.txt', 'new')
end
local gui = readfile('katware/profiles/gui.txt')

if not isfolder('katware/assets/'..gui) then
	makefolder('katware/assets/'..gui)
end
katware = loadstring(downloadFile('katware/guis/'..gui..'.lua'), 'gui')()
shared.katware = katware

if not shared.KatwareIndependent then
	loadstring(downloadFile('katware/games/universal.lua'), 'universal')()
	if isfile('katware/games/'..game.PlaceId..'.lua') then
		loadstring(readfile('katware/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
	else
		if not shared.KatwareDeveloper then
			local suc, res = pcall(function()
				return game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/katware/'..readfile('katware/profiles/commit.txt')..'/games/'..game.PlaceId..'.lua', true)
			end)
			if suc and res ~= '404: Not Found' then
				loadstring(downloadFile('katware/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
			end
		end
	end
	finishLoading()
else
	katware.Init = finishLoading
	return katware
end