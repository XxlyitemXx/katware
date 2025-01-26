local HttpService = game:GetService("HttpService")

-- Function to create a directory if it doesn't exist
local function createDirectory(path)
  if not isfile(path) and not isfolder(path) then
    makefolder(path)
  end
end

-- Function to download a file from a URL
local function downloadFile(url, path)
  local success, response, headers = pcall(game.HttpGet, game, url)

  if success then
    local statusCode = headers["StatusCode"] or 200

    if statusCode >= 200 and statusCode < 300 then
      createDirectory(path:match("^(.-)[^/]+$")) -- Create directory for the file
      writefile(path, response)
      print("Downloaded: " .. path)
    else
      print("Failed to download file: " .. url .. " (Status Code: " .. statusCode .. ")")
    end
  else
    print("Failed to download file: " .. url .. " (Error: " .. response .. ")")
  end
end

-- Function to recursively get a list of files from a GitHub repository
local function getRepoFiles(repoUrl, path)
  path = path or ""
  local success, response = pcall(game.HttpGet, game, repoUrl .. "/" .. path .. "?ref=main")

  if success then
    local files = {}
    local decodedResponse = HttpService:JSONDecode(response)

    if type(decodedResponse) == "table" then
      for _, fileData in ipairs(decodedResponse) do
        if fileData.type == "file" then
          table.insert(files, { path = path, name = fileData.name })
        elseif fileData.type == "dir" then
          local subfolderFiles = getRepoFiles(repoUrl, path .. "/" .. fileData.name)
          for _, subFile in ipairs(subfolderFiles) do
            table.insert(files, subFile)
          end
        end
      end
    else
      print("Unexpected response format:", decodedResponse)
    end

    return files
  else
    print("Failed to get repository files: " .. repoUrl)
    return {}
  end
end

-- URL of the repository
local repoUrl = "https://api.github.com/repos/XxlyitemXx/katware/contents"

-- Get the list of files in the repository
local files = getRepoFiles(repoUrl)

-- Download each file
for _, file in ipairs(files) do
  local url = "https://raw.githubusercontent.com/XxlyitemXx/katware/main/" .. file.path .. "/" .. file.name
  local path = "katware/" .. file.path .. "/" .. file.name
  downloadFile(url, path)
  wait(0.5) -- Add a small delay to avoid rate limiting
end

print("Finished downloading all files.")

-- Load and execute main.lua (using require if possible)
local mainModulePath = "katware/main.lua" -- Adjust if necessary

if isfile(mainModulePath) then
    local mainModule = require(game.Workspace.katware.main) -- Assuming you have set up the module correctly, adjust accordingly
    -- you may also need to change game.Workspace to where ever the file is located.
    -- Example: local mainModule = require(game.ServerScriptService.katware.main)

    if mainModule then
      -- if your module returns a function you can call it here
      if type(mainModule) == "function" then
        mainModule()
      elseif mainModule.start then -- or some other way your module starts
        mainModule.start()
      end
    else
      print("Failed to load main module.")
    end
else
    print("main.lua not found.")
end