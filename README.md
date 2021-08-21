# EpikAPI, 534144#9996 (820077059095003147)

If you have **questions/bug reports/suggestions** please contact me on Discord.

**How to Use:**
```lua
local EpikAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/HunterAPI/EpikAPI/main/EpikAPI.lua"), "EpikAPI.lua")() -- loads it up

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

-- Returns the character's RootPart or Torso or Head or a BasePart Instance. If no arguments are passed, it'll defaul to the LocalPlayer's Character
EpikAPI.GetRoot(character)

-- Returns a table of all the found players
-- Key words: me, all, others, friends, nonfriends, team, nonteam, random, furthest, closest
-- You can combine keywords like this "me,friends,johndoe,janedoe"
EpikAPI.FindPlayer("me,friends")

EpikAPI.RegisterCommand("print", {"prnt"}, function(args, ...) -- [args, ...] are the arguments
    -- Inside of the function (callback) you put what you want the command to do
    print(args, ...)
end)

-- You don't need to pass the prefix; if you do put it, it'll ignore it (the first one only)
-- To execute multiple commands you can seperate them with "\", example: ";fly\to johndoe\"
EpikAPI.ExecuteCommand("fly")
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
    if msg:sub(1, #EpikAPI.Prefix) == EpikAPI.Prefix then
        EpikAPI.ExecuteCommand(msg)
    end
end)
```
