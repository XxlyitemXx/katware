repeat task.wait() until game:IsLoaded()

shared.oldgetcustomasset = shared.oldgetcustomasset or getcustomasset
task.spawn(function()
    repeat task.wait() until shared.VapeFullyLoaded
    getgenv().getcustomasset = shared.oldgetcustomasset
end)

local baseDirectory = shared.RiseMode and "rise/" or "vape/"
if (not isfolder('vape')) then makefolder('vape') end
if (not isfolder('rise')) then makefolder('rise') end

local setidentity = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function() end
local getidentity = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity or function() return 8 end
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local delfile = delfile or function(file) writefile(file, "") end
if not isfolder(baseDirectory) then makefolder(baseDirectory) end

local url = shared.RiseMode and "https://github.com/XxlyitemXx/katware/" or "https://github.com/XxlyitemXx/katware"
if not shared.VapeDeveloper then 
	local commit = "main"
	if commit then
		if isfolder(baseDirectory) then 
		    writefile(baseDirectory.."commithash2.txt", commit)
			if ((not isfile(baseDirectory.."commithash.txt")) or (readfile(baseDirectory.."commithash.txt") ~= commit or commit == "main")) then
				writefile(baseDirectory.."commithash2.txt", commit)
			end
		else
			makefolder("vape")
			writefile(baseDirectory.."commithash2.txt", commit)
		end
	end
end

local function vapeGithubRequest(scripturl, isImportant)
    if isfile(baseDirectory..scripturl) then
        if not shared.VoidDev then
            pcall(function() delfile(baseDirectory..scripturl) end)
        else
            return readfile(baseDirectory..scripturl) 
        end
    end
    local suc, res
    local url = (scripturl == "MainScript.lua" or scripturl == "GuiLibrary.lua") and shared.RiseMode and "https://raw.githubusercontent.com/XxlyitemXx/katware/" or "https://raw.githubusercontent.com/XxlyitemXx/katware/"
    suc, res = pcall(function() return game:HttpGet(url..readfile(baseDirectory.."commithash2.txt").."/"..scripturl, true) end)
    if not suc or res == "404: Not Found" then
        if isImportant then
            game:GetService("Players").LocalPlayer:Kick("Failed to connect to github : "..baseDirectory..scripturl.." : "..res)
        end
        warn(baseDirectory..scripturl, res)
    end
    if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
    return res
end

local function pload(fileName, isImportant, required)
    fileName = tostring(fileName)
    if string.find(fileName, "CustomModules") and string.find(fileName, "Voidware") then
        fileName = string.gsub(fileName, "Voidware", "VW")
    end        
    if shared.VoidDev and shared.DebugMode then warn(fileName, isImportant, required, debug.traceback(fileName)) end
    local res = vapeGithubRequest(fileName, isImportant)
    local a = loadstring(res)
    local suc, err = true, ""
    if type(a) ~= "function" then suc = false; err = tostring(a) else if required then return a() else a() end end
    if (not suc) then 
        if isImportant then
            if (not string.find(string.lower(err), "vape already injected")) and (not string.find(string.lower(err), "rise already injected")) then
                task.spawn(function()
                    repeat task.wait() until errorNotification
                    errorNotification("Failure loading critical file! : "..baseDirectory..tostring(fileName), " : "..tostring(debug.traceback(err)), 10) 
                end)
            end
        else
            task.spawn(function()
                repeat task.wait() until errorNotification
                if not string.find(res, "404: Not Found") then 
                    errorNotification('Failure loading: '..baseDirectory..tostring(fileName), tostring(debug.traceback(err)), 7)
                end
            end)
        end
    end
end

shared.pload = pload
getgenv().pload = pload
return pload("MainScript.lua", true)