---Return the number of items in a table.
---@param tbl table
---@return integer
local function table_length(tbl)
  local count = 0
  for _ in pairs(tbl) do
    count = count + 1
  end

  return count
end

local monWsCount = 100
local maxWsId = table_length(hl.get_monitors()) * monWsCount

return {
  monWsCount = monWsCount,
  maxWsId = maxWsId,
}
