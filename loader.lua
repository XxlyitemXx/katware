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
  
  -- Function to get a list of files from a GitHub repository recursively
  local function getRepoFiles(repoUrl)
	local files = {}
  
	local function traverse(url)
	  -- Get the contents of the current URL
	  local success, response = pcall(game.HttpGet, game, url)
  
	  if success then
		local decodedResponse = game:GetService("HttpService"):JSONDecode(response)
  
		-- Check if the response is a table and iterate accordingly
		if type(decodedResponse) == "table" then
		  for _, item in ipairs(decodedResponse) do
			if item.type == "file" then
			  -- Add the file path to the list
			  table.insert(files, item.path)
			elseif item.type == "dir" then
			  -- Recursively traverse subdirectories
			  traverse(item.url)
			end
		  end
		else
		  -- Handle the case where the response is not a table (e.g., an error message)
		  print("Unexpected response format:", decodedResponse)
		end
	  else
		print("Failed to get repository files: " .. url)
	  end
	end
  
	traverse(repoUrl)
	return files
  end
  
  -- URL of the repository
  local repoUrl = "https://api.github.com/repos/XxlyitemXx/katware/contents"
  
  -- Get the list of files in the repository recursively
  local files = getRepoFiles(repoUrl)
  
  -- Download each file
  for _, file in ipairs(files) do
	local url = "https://raw.githubusercontent.com/XxlyitemXx/katware/main/" .. file
	local path = "katware/" .. file
	downloadFile(url, path)
  end
  
  -- Load each downloaded file
  for _, file in ipairs(files) do
	local path = "katware/" .. file
	if isfile(path) then
	  loadstring(readfile(path), file)()
	end
  end
  
  print("Finished downloading and loading all files.")