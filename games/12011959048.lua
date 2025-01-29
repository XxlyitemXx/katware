local katware = shared.katware
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and katware then 
		katware:CreateNotification('katware', 'Failed to load : '..err, 30, 'alert') 
	end
	return res
end
local isfile = isfile or function(file)
	local suc, res = pcall(function() 
		return readfile(file) 
	end)
	return suc and res ~= nil and res ~= ''
end
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

katware.Place = 11630038968
if isfile('katware/games/'..katware.Place..'.lua') then
	loadstring(readfile('katware/games/'..katware.Place..'.lua'), 'bedwars')()
else
	if not shared.katwareDeveloper then
		local suc, res = pcall(function() 
			return game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/katware/'..readfile('katware/profiles/commit.txt')..'/games/'..katware.Place..'.lua', true) 
		end)
		if suc and res ~= '404: Not Found' then
			loadstring(downloadFile('katware/games/'..katware.Place..'.lua'), 'bedwars')()
		end
	end
end