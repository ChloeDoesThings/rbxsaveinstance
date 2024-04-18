-- Decompilation stuff (thanks lonegladiator for making this lmao)

local httpService = cloneref(game:GetService('HttpService'))

local function decompile(scr)
    local s, bytecode = pcall(getscriptbytecode, scr)
    if not s then
        return `failed to get bytecode { bytecode }`
    end

    local response = request({
        Url = 'https://unluau.lonegladiator.dev/unluau/decompile',
        Method = 'POST',
        Headers = {
            ['Content-Type'] = 'application/json',
        },
        Body = httpService:JSONEncode({
            version = 5,
            bytecode = crypt.base64.encode(bytecode)
        })
    })

    local decoded = httpService:JSONDecode(response.Body)
    if decoded.status ~= 'ok' then
        return `decompilation failed: { decoded.status }`
    end

    return decoded.output
end

-- actually decompiles scripts and saves the game
for i, v in pairs(game:GetDescendants()) do
if v and (v:IsA("LocalScript") or v:IsA("ModuleScript") or (v:IsA("Script") and v.RunContext == Enum.RunContext.Client)) do
    v.Source = decompile(v) -- lets hope this doesn't overload the api or anything
    end
end
  
-- feel free to change the saveinstance options :D
-- https://docs.krampus.gg/api-reference/instance-saving-functions/saveinstance
saveinstance(game, {FileName = "saved-" .. tostring(game.PlaceId)})
