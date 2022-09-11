getgenv().Toggle = true
getgenv().ValueCheck = true
local FunctionCount = 0
local ValueCount = 0

local hookrecoil = function(func)
    local hookrecoil; hookrecoil = hookfunction(func, function(...)
        local args = {...}
        if getgenv().Toggle then
            return 0 or nil
        end
        return hookrecoil(unpack(args))
    end)
end

for _, func in next, getgc(true) do
    if typeof(func) == "function" and string.find(string.lower(debug.getinfo(func).name), "recoil") then
        FunctionCount = FunctionCount + 1
        hookrecoil(func)
    elseif typeof(func) == "table" then
        for i, v in next, func do
            if typeof(v) == "function" and string.find(string.lower(debug.getinfo(v).name), "recoil") then
                FunctionCount = FunctionCount + 1
                hookrecoil(v)
            elseif getgenv().ValueCheck and typeof(i) == "string" and string.find(i, "%a+") and rawget(func, i) then
                for char in string.gmatch(i, "%a+") do
                    if string.find(string.lower(char), "recoil") then
                        ValueCount = ValueCount + 1
                        if typeof(v) == "number" then
                            rawset(func, i, 0)
                        elseif typeof(v) == "string" and tonumber(v) then
                            rawset(func, i, "0")
                        elseif typeof(v) == "Vector3" then
                            rawset(func, i, Vector3.new(0,0,0))
                        elseif typeof(v) == "CFrame" then
                            rawset(func, i, CFrame.new(0,0,0))
                        end
                    end
                end
            end
        end
    end
end

print("Fetched: " .. tostring(FunctionCount) .. " Functions")
print("Fetched: " .. tostring(ValueCount) .. " Values")