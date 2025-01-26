-- Function to fetch the content of a URL
local function fetchURL(url)
	local http = require("socket.http")
	local body, code = http.request(url)
  
	if code == 200 then
	  return body
	else
	  print("Error fetching URL: " .. url .. " (Code: " .. code .. ")")
	  return nil
	end
  end
  
  -- Function to parse HTML and extract links (simplified for this specific case)
  local function extractLinks(html)
	local links = {}
	for href in html:gmatch('href="([^"]+)"') do
	  table.insert(links, href)
	end
	return links
  end
  
  -- Function to recursively download files and folders
  local function downloadRepo(baseURL, path)
	local fullURL = baseURL .. path
	local content = fetchURL(fullURL)
  
	if content then
	  -- Check if it's a directory listing (simplified HTML check)
	  if content:match("<title>Index of") then 
		local links = extractLinks(content)
		for _, link in ipairs(links) do
		  if link ~= "../" then -- Ignore parent directory link
			local newPath = path .. link
			if link:sub(-1) == "/" then
			  -- It's a directory
			  print("Creating directory: " .. newPath)
			  os.execute("mkdir -p \"" .. newPath .. "\"") -- Create directory (cross-platform compatible)
			  downloadRepo(baseURL, newPath)
			else
			  -- It's a file
			  print("Downloading file: " .. newPath)
			  local fileContent = fetchURL(baseURL .. newPath)
			  if fileContent then
				local file = io.open(newPath, "w")
				file:write(fileContent)
				file:close()
			  end
			end
		  end
		end
	  else
		print("Error: Unexpected content for URL: " .. fullURL)
	  end
	end
  end
  
  -- Base URL of the repository
  local baseURL = "https://raw.githubusercontent.com/XxlyitemXx/katware/main/"
  
  -- Start downloading from the root of the repository
  downloadRepo(baseURL, "")
  
  print("Repository download completed (hopefully).")