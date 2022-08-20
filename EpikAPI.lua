local Players = game:GetService("Players")
local ME = Players.LocalPlayer
local EpikAPI = {
	Commands = {},
	CommandsList = {},
	Prefix = "'"
}
local _ENV = _ENV or getfenv()
function EpikAPI.RegisterCommand(name, alias, callback)
	if type(alias) == "function" then
		alias, callback = callback, alias
	end
	assert(type(name) == "string", "bad argument #1 to 'RegisterCommand' (string expected got " .. typeof(name) .. ")")
	assert(type(alias) == "table" or type(alias) == "nil", "bad argument #2 to 'RegisterCommand' (table expected got " .. typeof(args) .. ")")
	assert(type(callback) == "function", "bad argument #3 to 'RegisterCommand' (function expected got " .. typeof(callback) .. ")")
	name = {name, unpack(type(alias) ~= "table" and {alias} or alias or {})}
	for _, v in next, name do
		EpikAPI.Commands[v] = callback
	end
	return table.insert(EpikAPI.CommandsList, table.concat(name, " / "))
end
local function RunCMDI(a)
	a = tostring(a):match("^%s*(.-)%s*$")
	local d = {}
	if a:sub(1, #EpikAPI.Prefix):lower() == EpikAPI.Prefix then
		a = a:sub(#EpikAPI.Prefix + 1)
	end
	a = a:match("^%s*(.-)%s*$") .. " "
	local c, b = os.clock(), false
	while #a > 0 and (os.clock() - c) < 3 do
		local g, h = a:find(" ", 1, true)
		local i, j = a:find("[[", 1, true)
		if g and i and g > i then
			g, h = j + 1, (a:find("]]"))
			if h then
				h = h - 1
				b = a:sub(g, h)
				if b:sub(1, 2) == "[[" then
					b = b:sub(3)
				end
				if b:sub(-2) == "]]" then
					b = b:sub(1, -3)
				end
			end
		end
		if g and h then
			local k = b or a:sub(1, g - 1)
			if k ~= "]]" and " " ~= k and k ~= "" then
				d[#d + 1] = k
			end
			a = a:sub(h + 1)
			b = false
		elseif a ~= "]]" and a ~= " " and "" ~= a then
			d[#d + 1] = a
			a = ""
			break
		else
			a = ""
			break
		end
	end
	local e = table.remove(d, 1)
	local f = e and EpikAPI.Commands[e and e:lower()]
	if not f or type(f) ~= "function" then
		return warn("Hunter's Admin; Invalid command:", e)
	end
	return task.spawn(xpcall, f, function(l)
		warn((debug.traceback(l):gsub("[\n\r]+", "\n    ")))
	end, unpack(d))
end
function EpikAPI.ExecuteCommand(msg)
	for v in msg:match("^%s*(.-)%s*$"):gsub("\\+", "\\"):match("^\\*(.-)\\*$"):gmatch("[^\\]+") do
		RunCMDI(v)
	end
end
local setprop = sethiddenproperty or sethiddenprop or sethidden or set_hidden_prop or set_hidden_property or function(x, i, v)
	x[i] = v
end
function EpikAPI.Instance(a1, a2, a3)
	assert(type(a1) == "string" and (type(a2) == "nil" or type(a2) == "table" or typeof(a2) == "Instance" or (typeof(a2) == "Instance" and type(a3) == "table")), "Invalid arguments to 'EpikAPI.Instance' (expected (string, Instance, table) or (string, table) or (string, Instance) got (" .. typeof(a1) .. ", " .. typeof(a2) .. ", " .. typeof(a3) .. "))")
	if type(a2) == "table" then
		a3 = a2
		a2 = nil
	end
	local s, x = pcall(Instance.new, a1)
	if not s or not x or typeof(x) ~= "Instance" then
		return warn(debug.traceback("Failed to create \"" .. a1 .. "\"", 2))
	end
	local IsGui, Center = x:IsA("GuiBase"), nil
	if IsGui then
		pcall(syn.protect_gui, x)
	end
	if a3 and type(a3) == "table" then
		Center, a2 = IsGui and a3.Center, a3.Parent or a2
		a3.Parent, a3.Center = nil, nil
		for i, v in next, a3 do
			xpcall(setprop, function(msg)
				return warn((debug.traceback(msg, 4):gsub("[\n\r]+", "\n    ")))
			end, x, i, v)
		end
	end
	if Center and IsGui then
		x.Position = UDim2.new(.5, -(x.AbsoluteSize.X / 2), .5, -(x.AbsoluteSize.Y / 2))
	end
	x.Parent = a2
	return x
end
function EpikAPI.GetRoot(x)
	x = x or ME.Character
	local z = x and x:FindFirstChildWhichIsA("Humanoid", true)
	return (z and (z.RootPart or z.Torso)) or x.PrimaryPart or x:FindFirstChild("HumanoidRootPart") or x:FindFirstChild("Torso") or x:FindFirstChild("UpperTorso") or x:FindFirstChild("LowerTorso") or x:FindFirstChild("Head") or x:FindFirstChildWhichIsA("BasePart", true)
end
local FindFunctions = {}
FindFunctions.me = function()
	return {ME}
end
FindFunctions.all = function(x)
	return x
end
FindFunctions.others = function(x)
	return {unpack(x, 2)}
end
FindFunctions.friends = function(x)
	local z = {}
	for _, v in next, x do
		if v ~= ME and ME:IsFriendsWith(v.UserId) then
			z[#z + 1] = v
		end
	end
	return z
end
FindFunctions.nonfriends = function(x)
	local z = {}
	for _, v in next, x do
		if v ~= ME and not ME:IsFriendsWith(v.UserId) then
			z[#z + 1] = v
		end
	end
	return z
end
FindFunctions.team = function(x)
	local z = {}
	for _, v in next, x do
		if v ~= ME and v.Team == ME.Team then
			z[#z + 1] = v
		end
	end
	return z
end
FindFunctions.nonteam = function(x)
	local z = {}
	for _, v in next, x do
		if v ~= ME and v.Team ~= ME.Team then
			z[#z + 1] = v
		end
	end
	return z
end
FindFunctions.random = function(x)
	return {x[math.random(1, #x)]}
end
FindFunctions.furthest = function(x)
	local dist, z = 0, false
	for _, v in next, x do
		local x = v ~= ME and v.Character and EpikAPI.GetRoot(v.Character)
		if x then
			local e = ME:DistanceFromCharacter(x.Position)
			if e and e > dist then
				dist, z = e, v
			end
		end
	end
	return {z}
end
FindFunctions.closest = function(x)
	local dist, z = math.huge, false
	for _, v in next, x do
		local x = v ~= ME and v.Character and EpikAPI.GetRoot(v.Character)
		if x then
			local e = ME:DistanceFromCharacter(x.Position)
			if e and e < dist then
				dist, z = e, v
			end
		end
	end
	return {z}
end
FindFunctions.FromName = function(x, e)
	local z = {}
	for _, v in next, x do
		if v.Name:sub(1, #e):lower() == e or v.DisplayName:sub(1, #e):lower() == e and not table.find(z, v) then
			z[#z + 1] = v
		end
	end
	return z
end
function EpikAPI.FindPlayer(plr)
	local z, x = {}, Players:GetPlayers()
	for e in (plr and plr:lower() or "me"):match("^%s*(.-)%s*$"):gsub(",+", ","):match("^,*(.-),*$"):gmatch("[^,]+") do
		e = e:lower():match("^%s*(.-)%s*$")
		local r = e:match("^regex%((.-)%)$")
		local frm1, frm2 = e:match("from(%d+)%-?(%d*)")
		frm1, frm2 = tonumber(frm1), tonumber(frm2)
		if r then
			for _, v in next, x do
				if v.Name:find(r) and not table.find(z, v) then
					z[#z + 1] = v
				end
			end
		elseif frm1 then
			frm2 = frm2 or #x
			for _, v in next, {unpack(x, math.min(frm1, frm2), math.max(frm1, frm2))} do
				if not table.find(z, v) then
					z[#z + 1] = v
				end
			end
		else
			for _, v in next, (FindFunctions[e] or FindFunctions.FromName)(x, e) do
				if not table.find(z, v) then
					z[#z + 1] = v
				end
			end
		end
	end
	return z
end
function EpikAPI.GetPlayerFromInstance(obj)
	assert(obj and typeof(obj) == "Instance", "Invalid argument to 'GetPlayerFromInstance' (expected Instance got " .. typeof(obj) .. ")")
	for _, v in next, Players:GetPlayers() do
		if v.Character and obj:IsDescendantOf(v.Character) then
			return v
		end
	end
	return nil
end
function EpikAPI.LoadAssetWithScripts(Id, Parent)
	Id, Parent = tonumber(Id), typeof(Parent) == "Instance" and Parent or false
	assert(Id, "Invalid argument to 'LoadAssetWithScripts' (expected number)")
	local Loaded, Asset = pcall(game.GetObjects, game, "rbxassetid://" .. Id)
	if not Loaded or (Loaded and (not Asset[1] or typeof(Asset[1]) ~= "Instance")) then
		return warn(not Loaded and Asset or "Failed to load '" .. Id .. "'")
	end
	Asset = Asset[1]
	if Asset:IsA("GuiBase") and syn and type(syn) == "table" and syn.protect_gui and type(syn.protect_gui) == "function" then
		pcall(syn.protect_gui, Asset)
	end
	local Name = ""
	for _ = 1, math.random(24, 33) do
		Name = Name .. string.char(math.random(33, 126))
	end
	Asset.Name = Name
	Asset.Parent = Parent or (get_hidden_ui and get_hidden_ui()) or (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or game:GetService("CoreGui")
	local function sandbox(v)
		task.spawn(setfenv(loadstring(v.Source, "=" .. v:GetFullName()), setmetatable({
			script = v
		}, {
			__index = _ENV
		})))
	end
	if Asset:IsA("LuaSourceContainer") then
		sandbox(v)
	end
	for _, v in next, Asset:GetDescendants() do
		if v:IsA("LuaSourceContainer") then
			sandbox(v)
		end
	end
	return Asset
end
local StarterGui = game:GetService("StarterGui")
function EpikAPI.Notify(title, text, dur)
	local t = (type(title) == "table" and title) or {}
	if type(title) == "string" then
		local a = (not text or type(text) == "number")
		t = {
			Title = a and "Epik API" or title,
			Text = a and title or text,
			Duration = a and tonumber(text or dur) or 5
		}
	end
	StarterGui:SetCore("SendNotification", t)
end
return EpikAPI, print("Hunter was here ;) Discord: EOS#0791 (ID: 992607884703711283)")