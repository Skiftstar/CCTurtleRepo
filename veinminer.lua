-- mapped 1 - 6 (ARRAYS START AT 1 !)
-- entries are either
-- false -> no ore
-- or another {} map entry with same mapping
-- realistically the index 3 should always be false, but
-- having it makes scanning less complex
-- { forward, left, behind, right, up, down }
local veinMap = {}
local directionHistory = ""
local nextOreDirection = nil
local currLevel = veinMap

local BLACKLISTED_TAGS = { 	"minecraft:base_stone_overworld",
	"minecraft:base_stone_nether",
	"minecraft:dirt",
	"minecraft:sand",
	"minecraft:terracotta",
	"minecraft:ice",
	"minecraft:snow",
	"forge:sandstone",
	"forge:gravel",
	"forge:end_stones",
	"forge:cobblestone",
	"minecraft:calcite",
	"minecraft:water",
	"minecraft:lava" }

function start()
    scanAround()
    nextOreDirection = findNextOreDirection()
    run()
end

function run()
    while nextOreDirection ~= -1 do
        mine(nextOreDirection)
        move(nextOreDirection)
        directionHistory = directionHistory .. tostring(nextOreDirection) .. " "
        currLevel = currLevel[nextOreDirection]
        scanAround()
        nextOreDirection = findNextOreDirection()
    end

    print(directionHistory)

    while nextOreDirection == -1 and string.len(directionHistory) > 0 do
        local lastDirection = tonumber(string.sub(directionHistory, -2))
        backtrack(lastDirection)
        directionHistory = string.sub(directionHistory, 1, -3)
        traverseMapToCurrLevel()
        currLevel[lastDirection] = false
        nextOreDirection = findNextOreDirection()
    end

    if nextOreDirection ~= -1 then
        run()
    else
        print("Done :D")
    end
end

function traverseMapToCurrLevel()
    currLevel = veinMap
    for _, value in ipairs(split(directionHistory, " ")) do
        currLevel = currLevel[tonumber(value)]
    end
end

function backtrack(lastDirection)
    if lastDirection == 5 then
        turtle.down()
    elseif lastDirection == 6 then
        turtle.up()
    else
        turtle.back()
    end

    inverseRotate(lastDirection)
end

function inverseRotate(direction)
    if direction == 2 then
        turtle.turnRight()
    elseif direction == 3 then
        turtle.turnRight()
        turtle.turnRight()
    elseif direction == 4 then
        turtle.turnLeft()
    end
end

function rotate(direction)
    if direction == 2 then
        turtle.turnLeft()
    elseif direction == 3 then
        turtle.turnLeft()
        turtle.turnLeft()
    elseif direction == 4 then
        turtle.turnRight()
    end
end

function move(direction)
    if direction == 5 then
        turtle.up()
    elseif direction == 6 then
        turtle.down()
    else
        turtle.forward()
    end
end

function mine(direction)
    rotate(direction)

    if direction == 5 then
        turtle.digUp()
    elseif direction == 6 then
        turtle.digDown()
    else
        turtle.dig()
    end
end

function updateCurrentMapLevel()
    if directionHistory == nil then
        return veinMap
    end

    for _, value in ipairs(split(directionHistory, " ")) do
        currLevel = currLevel[value]
    end
    return currLevel
end

function scanAround()
    for i = 1, 6, 1 do
        veinScanInDirection(i)
    end
end

function findNextOreDirection()
    for index, value in ipairs(currLevel) do
        if type(value) == "table" then
            return index
        end
    end
    return -1
end

function veinScanInDirection(dir)
    local hasBlock, data = nil, nil
    if dir == 5 then
        hasBlock, data = turtle.inspectUp()
    elseif dir == 6 then
        hasBlock, data = turtle.inspectDown()
    else
        hasBlock, data = turtle.inspect()
        turtle.turnLeft()
    end

    if hasBlock and not isBlockBlacklisted(data) then
        currLevel[dir] = {}
    else
        currLevel[dir] = false
    end
end

function isBlockBlacklisted(data)
    for _, tag in ipairs(BLACKLISTED_TAGS) do
        if data.tags[tag] then
            return true
        end
    end
    return false
end

function split(inputstr, sep)
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

start()