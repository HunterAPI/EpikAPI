# EpikAPI, 485856#1337 (810658528212549702)

If you have **questions/bug reports/suggestions** please contact me on Discord.

**How to Use:**
```lua
local EpikAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/HunterAPI/EpikAPI/main/EpikAPI.lua"), "EpikAPI.lua")() -- load it up

EpikAPI.Prefix = ";" -- prefix

 -- EpikAPI.Commands contains all commands and their aliases as commands in a table
for CommandName in pairs(EpikAPI.Commands) do
	print(CommandName)
end

-- Creating an Instance, for GUIs you're allowed to add 'Center = true' inside the table, it'll position the GUI in the very center, it'll set it at the very end so it'll account for the size
local Part = EpikAPI.Instance("Part", workspace, {
    Anchored = true,
    Massless = true
})

table.foreach(getproperties(Part), print) -- example to show it returns the part (getproperties might not be supported for your exploit)

EpikAPI.GetRoot(character) -- get's the root part or torso or head or basepart of 'character' if u don't put any arugments in, it'll default to LocalPlayer's character

EpikAPI.FindPlayer("me,friends") -- keys words: me, all, others, friends, nonfriends, team, nonteam, random, furthest, closest
-- You can also do "keyword,name,friends" to get them all

EpikAPI.RegisterCommand("print", {"prnt"}, function(args, ...) -- [args, ...] are the arguments
    -- Inside of the function (callback) you put what you want the command to do
    print(args, ...)
end)

EpikAPI.ExecuteCommand(";fly") -- You feed a string in for it to parse
-- You can also do ";fly\another_command\another_command"
-- When calling EpikAPI.ExecuteCommand, you don't need to pass the prefix, if you do it'll ignore it
```


**Basic Example:**
```lua
local EpikAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/HunterAPI/EpikAPI/main/EpikAPI.lua"), "EpikAPI.lua")()
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
            Char:MoveTo(v.Position)
        end
    end
end)

ME.Chatted:Connect(function(msg)
    if string.sub(msg, 1, #EpikAPI.Prefix) == EpikAPI.Prefix then
        EpikAPI.ExecuteCommand(msg)
    end
end)
```
