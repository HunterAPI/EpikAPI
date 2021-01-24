# EpikAPI || 534144#0001 720793503428509758
How to use:
```lua
local EpikAPI = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/HunterAPI/EpikAPI/main/EpikAPI.lua"), "EpikAPI")()

EpikAPI.Prefix = ";" -- prefix

table.foreach(EpikAPI.Commands, print) -- EpikAPI.Commands contains all commands and their aliases as commands in a table

EpikAPI.Instance("Part", workspace, {
    Anchored = true,
    Massless = true
})

EpikAPI.GetRoot(character) -- get's the root part or torso or head or basepart of 'character' if u don't put any arugments in, it'll default to LocalPlayer's character

EpikAPI.FindPlayer("me,friends") -- keys words: me, all, others, friends, nonfriends, team, nonteam, random, furthest, closest
-- You can also do "keyword,name,friends" to get them all

EpikAPI.RegisterCommand("print", {"prnt"}, function(...) -- ... is the arguments
    -- here you use the arguments
    print(...)
end)

EpikAPI.ExecuteCommand(";fly") -- You feed a string in for it to parse
-- You can also do ";fly\another_command\another_command"
-- When calling EpikAPI.ExecuteCommand, you don't need to pass the prefix, if you do it'll ignore it
```

Basic example:
```lua
local EpikAPI = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/HunterAPI/EpikAPI/main/EpikAPI.lua"), "EpikAPI")()
local ME = game:GetService("Players").LocalPlayer

EpikAPI.Prefix = ";"

EpikAPI.RegisterCommand("to", {"goto"}, function(plr)
    local Char = ME.Character
    if not Char then
        return warn("Missing LocalPlayer's Character")
    end
    for _, v in ipairs(EpikAPI.FindPlayer(plr)) do
        v = v.Character and EpikAPI.GetRoot(v.Character)
        if v then
            Char.MoveTo(Char, v.Position)
        end
    end
end)

ME.Chatted:Connect(function(msg)
    if string.sub(msg, 1, #EpikAPI.Prefix) == EpikAPI.Prefix then
        EpikAPI.ExecuteCommand(msg)
    end
end)
```
