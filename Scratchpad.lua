-- Source - https://stackoverflow.com/a/7615129
-- Posted by user973713, modified by community. See post 'Timeline' for change history
-- Retrieved 2026-04-27, License - CC BY-SA 4.0

function mysplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end


local map = { 00, { 10, 11, { 20, 21, 22}, 12 }, 01, 02 }
local dirString = "2 3"

local split = mysplit(dirString, " ")

local currLevel = map
for index, value in ipairs(split) do
    -- print(value)
    -- print(currLevel)
    currLevel = currLevel[tonumber(value)]
end

-- print(currLevel)
for index, value in ipairs(currLevel) do
    -- print(value)
end

for i = 1, 5, 1 do
    -- print(i)
end

function arrayModulo(val, maxVal)
    local modVal = val % maxVal
    if (modVal == 0) then
        return maxVal
    end
    return modVal
end

-- print(arrayModulo(25, 5))

if true or false then
    -- print("true")
end

local original = {"d"}
local test = original
table.insert(test, "abc")

for index, value in ipairs(original) do
    -- print(value)
end

-- 1,  2,  3,  4,  5
-- 6,  7,  8,  9,  10
-- 11, 12, 13, 14, 15
-- 16, 17, 18, 19, 20
-- 21, 22, 23, 24, 25


local map2 = { 00, { 10, 11, { 20, 21, 22}, 12 }, 01, 02 }

-- [{}, false, false, false, {}, false], {}, false, false, false, false], false, false, false, false, {}], {}, false, {}, false, {}], {}, false, false, {}, {}], {}, false, false, {} {}]

local s = "1 "
print(string.len(string.sub(s, 1, -3)))
print(string.sub(s, 1, string.len(s) - 2))