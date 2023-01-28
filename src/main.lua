local totalSize
local isInstalling
local hasFinished
local copiedSize = 0
local currentDir = ""

local function determineDirSize(dir)
    local size = 0
    for _, item in ipairs(love.filesystem.getDirectoryItems(dir)) do
        local info = love.filesystem.getInfo(dir .. "/" .. item)
        if info.type == "directory" then
            size = size + determineDirSize(dir .. "/" .. item)
        else
            size = size + (info.size or 0)
        end
    end
    return size
end

local function copyDir(src, dest)
    if src == "src/.git" then
        return
    end
    
    currentDir = dest
    coroutine.yield()
    
    if dest ~= "" then
        assert(love.filesystem.createDirectory(dest))
    end
    
    for _, item in ipairs(love.filesystem.getDirectoryItems(src)) do
        local info = love.filesystem.getInfo(src .. "/" .. item)
        if info.type == "directory" then
            copyDir(src .. "/" .. item, dest .. "/" .. item)
        else
            local data, size = love.filesystem.read(src .. "/" .. item)
            love.filesystem.write(dest .. "/" .. item, data)
            copiedSize = copiedSize + size
        end
    end
end
local copyDirCo = coroutine.create(copyDir)

local function beginInstall()
    isInstalling = true
    totalSize = determineDirSize("src")
    coroutine.resume(copyDirCo, "src", "")
end

local function finishInstall()
    isInstalling = false
    hasFinished = true
	love.event.quit("restart")
end

function love.load()
    love.window.setTitle("Installer")
    
    isInstalling = true
    hasFinished = false
    love.graphics.setBackgroundColor(0.95, 0.95, 0.95)
    love.graphics.setNewFont(16)
	
	beginInstall()
end

function love.update()
    if isInstalling then
        if coroutine.status(copyDirCo) == "dead" then
            finishInstall()
        else
            coroutine.resume(copyDirCo)
        end
    end
end

function love.draw()
    love.graphics.setColor(0.1, 0.1, 0.1)
	
	love.graphics.printf("Installing...", 10, 10, love.graphics.getWidth()-20)
	
	love.graphics.print(string.format("Copying folder: %s", currentDir), 10, 30)
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('fill', 10, 60, 500, 50)
	
	love.graphics.setColor(0, 0.5, 0)
	love.graphics.rectangle('fill', 10, 60, (copiedSize / totalSize)*500, 50)
	
	love.graphics.setColor(0.1, 0.1, 0.1)
end

--[[
function love.keypressed()
    if not isInstalling and not hasFinished then
        beginInstall()
    elseif hasFinished then
        love.event.quit("restart")
    end
end
]]