repeat task.wait() until game:IsLoaded()
if shared.vape then shared.vape:Uninject() end
print("Injecting Katware | BIG THANKS TO 7GrandDadPGN! Check out his work vapeV4!")
print("https://github.com/7GrandDadPGN/VapeV4ForRoblox")

local baseurl = "https://raw.githubusercontent.com/XxlyitemXx/katware/main/" -- Base URL for the repository

local function download_files(dir)
    local path = dir:gsub("/", "/").."/"
    local full_url = baseurl .. path

    local success, result = pcall(function()
        return game:HttpGet(full_url)
    end)
    if not success then
        print("Failed to request file list at " .. full_url)
        return
    end

    for _, v in pairs(game:GetService('HttpService'):JSONDecode(result)) do
        local file_type = v.type
        local file_path = path .. v.name
        local file_url = baseurl .. file_path

        if file_type == "file" then
            local file_success, file_result = pcall(function()
                return game:HttpGet(file_url)
            end)
            if file_success then
                local local_path = "katware/" .. file_path
                local folder = string.match(local_path, "(.+)/.+")
                if folder then
                    if not isfolder(folder) then
                        makefolder(folder)
                    end
                end
                if not isfile(local_path) then
                    writefile(local_path, file_result)
                    print("Downloaded: " .. file_path)
                else
                     print("File already exists: " .. file_path)
                end
            else
                print("Failed to download: " .. file_path)
            end
        elseif file_type == "dir" then
            download_files(file_path:gsub("katware/", ""))
        end
    end
end

if not isfolder("katware") then
    makefolder("katware")
end

download_files("games")
download_files("assets")
download_files("libraries")
download_files("guis")
print("Finished downloading necessary files.")