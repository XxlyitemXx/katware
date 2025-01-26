local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

function downloadFile(url, path)
	local success, response = pcall(game.HttpGet, url)
  
	if success and response ~= '404: Not Found' then
	  writefile(path, response)
	else
	  print("Failed to download file: " .. url)
	end
  end
local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'katware', 'katware/games', 'katware/profiles', 'katware/assets', 'katware/libraries', 'katware/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not shared.VapeDeveloper then
	local _, subbed = pcall(function() 
		return game:HttpGet('https://github.com/XxlyitemXx/katware') 
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('katware/profiles/commit.txt') and readfile('katware/profiles/commit.txt') or '') ~= commit then
		wipeFolder('katware')
		wipeFolder('katware/games')
		wipeFolder('katware/guis')
		wipeFolder('katware/libraries')
	end
	writefile('katware/profiles/commit.txt', commit)
end

return loadstring(downloadFile("https://raw.githubusercontent.com/XxlyitemXx/katware/main/main.lua", "katware/main.lua"), 'main')()