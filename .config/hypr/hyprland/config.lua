local function table_length(tbl)
  local count = 0
  for _ in pairs(tbl) do
    count = count + 1
  end

  return count
end

local wsCount = 100
local maxWsId = table_length(hl.get_monitors()) * wsCount

return {
  wsCount = wsCount,
  maxWsId = maxWsId,
}
