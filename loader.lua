repeat task.wait() until game:IsLoaded()   
if shared.vape then shared.vape:Uninject() end
print("Injecting Katware | BIG THANKS TO 7GrandDadPGN! Check out his work vapeV4!")
print("https://github.com/7GrandDadPGN/VapeV4ForRoblox")



for _, folder in {"katware", "katware/profile", "katware/assets", "katware/games", 'katware/guis', 'katware/libraries'} do
    if not isfolder(folder) then
        makefolder(folder)
    end
end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end

local function downloadFile(file, path)
	print("Downloading", file)
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

downloadFile("main.lua", "katware/main.lua")
loadfile("katware/main.lua")()
