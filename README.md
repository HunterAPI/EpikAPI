# EpikAPI
Idk, RIP King Von

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
