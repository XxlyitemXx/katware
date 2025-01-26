-- Function to download a file from a URL
local function downloadFile(url, path)
	-- Attempt to download the file
	local success, response = pcall(game.HttpGet, game, url)
  
	-- Check if the download was successful and the response is not a 404 error
	if success and response ~= '404: Not Found' then
	  -- Write the downloaded content to the specified path
	  writefile(path, response)
	else
	  -- Print an error message if the download failed
	  print("Failed to download file: " .. url)
	end
  end
  
  -- Function to get a list of files from a GitHub repository
  local function getRepoFiles(repoUrl)
	-- Get the repository's contents using GitHub's API
	local success, response = pcall(game.HttpGet, game, repoUrl .. "?ref=main")
  
	if success then
	  -- Parse the JSON response
	  local files = {}
	  for _, fileData in ipairs(game:GetService("HttpService"):JSONDecode(response)) do
		if fileData.type == "file" then
		  table.insert(files, fileData.name)
		end
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
	local url = "https://raw.githubusercontent.com/XxlyitemXx/katware/main/" .. file
	local path = "katware/" .. file
	downloadFile(url, path)
end

print("Finished downloading all files.")
loadfile('katware/main.lua')()