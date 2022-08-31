# EpikAPI, EOS#0791 (ID: 992607884703711283)

If you have **questions/bug reports/suggestions** please contact me on Discord.

**How to Use:**
```lua
local EpikAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/HunterAPI/EpikAPI/main/EpikAPI.lua"), "EpikAPI.lua")() -- loads it up

EpikAPI.Prefix = ";" -- prefix

-- EpikAPI.Commands contains all commands and their aliases as commands in a table
for CommandName in next, EpikAPI.Commands do
	print(CommandName)
end

-- EpikAPI.GS table that gets any Roblox 'Service' indexed, and caches it
print(EpikAPI.GS.Players:GetPlayers())
EpikAPI.GS.RunService:Set3DRenderingEnabled(false)
for _, v in next, EpikAPI.GS.ReplicatedStorage:GetChildren() do
	print(v.Name, v.ClassName)
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
-- To execute multiple commands you can seperate them with "\", example: ";fly\to johndoe"
EpikAPI.ExecuteCommand("fly")

EpikAPI.GetPlayerFromInstance(ins) -- This basically checks if ins is a descendant of a player or the player's character

EpikAPI.LoadAssetWithScripts(id, optional_parent) -- this loads an asset fromt he roblox library with all the scripts inside it executed (default parent is set to CoreGui)
-- You can use this function to make a dex command like this
local Dex = false
EpikAPI.RegisterCommand("dex", {"explorer"}, function()
	Dex = (Dex and Dex:Destroy() and nil or nil) or EpikAPI.LoadAssetWithScripts(3567096419)
	return Dex
end)

-- EpikAPI.Notify it's just like StarterGui:SetCore("SendNotification", {Title = "Hello", Text = "Hi"})
-- It can also just except a string argument (text field), 2 sring arguments (title field and then text field), and also a 2nd/3rd number argument for duration
EpikAPI.Notify("text")
EpikAPI.Notify("text", 10)
EpikAPI.Notify("title", "text")
EpikAPI.Notify("title", "text", 3)
EpikAPI.Notify({
	Title = "Test",
	Text = "Test",
	Button1 = "Test"
})
```

**Basic Example:**
```lua
local EpikAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/HunterAPI/EpikAPI/main/EpikAPI.lua"), "EpikAPI.lua")()
local ME = EpikAPI.GS.Players.LocalPlayer

EpikAPI.Prefix = ";"

local function RemoveVelocity()
	if not ME.Character then
		return
	end
	for _, v in next, ME.Character:GetDescendants() do
		if v:IsA("BasePart") then
			v.Velocity, v.RotVelocity = Vector3.zero, Vector3.zero
		end
	end
end

EpikAPI.RegisterCommand("to", {"goto"}, function(plr)
	local Char = ME.Character
	if not Char then
		return EpikAPI.Notify("Missing LocalPlayer's Character")
	end
	for _, v in next, EpikAPI.FindPlayer(plr) do
		if v.Character then
			return Char:PivotTo(v.Character:GetPivot()), RemoveVelocity()
		end
	end
	EpikAPI.Notify("Teleport", "No player found called \"" .. plr .. "\"!")
end)
EpikAPI.RegisterCommand("rendering", function(set)
	if set == "on" or set == "true" then
		set = true
	elseif set == "off" or set == "false" then
		set = false
	end
	EpikAPI.GS.RunService:Set3dRenderingEnabled(set)
	EpikAPI.Notify("3D Rendering", (set and "Enabled" or "Disabled") .. " 3D Rendering!")
end)

EpikAPI.RegisterCommand("cmds", {"printcmds"}, function()
	for _, v in next, EpikAPI.CommandsList do
		print(v)
	end
	EpikAPI.Notify("Commands", "Press F9 to open the console to see the commands")
end)

ME.Chatted:Connect(function(msg)
	for _, v in next, {"/w ", "/t ", "/e ", "/whisper ", "/team ", "/emote "} do
		if msg:sub(1, #v) == v then
			msg = msg:sub(#v + 1)
		end
	end
	if msg:sub(1, #EpikAPI.Prefix) == EpikAPI.Prefix then
		EpikAPI.ExecuteCommand(msg)
	end
end)
```
