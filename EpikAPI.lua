local Players = game:GetService("Players")
local ME = Players.LocalPlayer
local EpikAPI = {
	Commands = {},
	CommandsList = {},
	Prefix = "'"
}
function EpikAPI.RegisterCommand(name, alias, callback)
	if type(alias) == "function" then
		alias, callback = callback, alias
	end
	assert(type(name) == "string", "bad argument #1 to 'EpikAPI.RegisterCommand' (string expected got " .. typeof(name) .. ") [Cmd:" .. name .. "]")
	assert(type(alias) == "table" or type(alias) == "nil", "bad argument #2 to 'EpikAPI.RegisterCommand' (table expected got " .. typeof(args) .. ") [Cmd:" .. name .. "]")
	assert(type(callback) == "function", "bad argument #3 to 'EpikAPI.RegisterCommand' (function expected got " .. typeof(callback) .. ") [Cmd:" .. name .. "]")
	name = {name, unpack(type(alias) ~= "table" and {alias} or alias or {})}
	for _, v in ipairs(name) do
		EpikAPI.Commands[v] = callback
	end
	return table.insert(EpikAPI.CommandsList, table.concat(name, " / "))
end
local function RunCMDI(str)
	str = tostring(str)
	local args = {}
	if str:sub(1, #EpikAPI.Prefix):lower() == EpikAPI.Prefix then
		str = str:sub(#EpikAPI.Prefix + 1)
	end
	for _, v in ipairs({"/w ", "/t ", "/e ", "/whisper ", "/team ", "/emote "}) do
		if str:sub(1, #v) == v then
			str = str:sub(#v + 1)
		end
	end
	str = str:match("^%s*(.-)%s*$") .. " "
	local escape, t = false, time()
	while #str > 0 and time() - t < 3 do
		local s, e = str:find(" ", nil, true)
		local d, r = str:find("\91\91", nil, true)
		if s and d and s > d then
			s, e = r + 1, (str:find("\93\93"))
			if e then
				e = e - 1
				escape = str:sub(s, e)
				if escape:sub(1, 2) == "\91\91" then
					escape = escape:sub(3)
				end
				if escape:sub(-2) == "\93\93" then
					escape = escape:sub(1, -3)
				end
			end
		end
		if s and e then
			local cstr = escape or str:sub(1, s - 1)
			if cstr ~= "\93\93" and " " ~= cstr and cstr ~= "" then
				table.insert(args, cstr)
			end
			str = str:sub(e + 1)
			escape = false
		elseif str ~= "\93\93" and str ~= " " and "" ~= str then
			table.insert(args, str)
			str = ""
			break
		else
			str = ""
			break
		end
	end
	local cmd = table.remove(args, 1)
	if not cmd then
		return 
	end
	local Command = EpikAPI.Commands[cmd:lower()]
	if type(Command) ~= "function" then
		return warn("Invalid Command:", cmd)
	end
	return coroutine.wrap(xpcall)(Command, function(msg)
		warn((debug.traceback(msg):gsub("[\n\r]+", "\n    ")))
	end, unpack(args))
end
function EpikAPI.ExecuteCommand(msg)
	for v in msg:gsub("\\+", "\\"):match("^\\*(.-)\\*$"):gmatch("[^\\]+") do
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
		for i, v in pairs(a3) do
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
	return {select(2, unpack(x))}
end
FindFunctions.friends = function(x)
	local z = {}
	for _, v in ipairs(x) do
		if v ~= ME and ME:IsFriendsWith(v.UserId) then
			z[#z + 1] = v
		end
	end
	return z
end
FindFunctions.nonfriends = function(x)
	local z = {}
	for _, v in ipairs(x) do
		if v ~= ME and not ME:IsFriendsWith(v.UserId) then
			z[#z + 1] = v
		end
	end
	return z
end
FindFunctions.team = function(x)
	local z = {}
	for _, v in ipairs(x) do
		if v ~= ME and v.Team == ME.Team then
			z[#z + 1] = v
		end
	end
	return z
end
FindFunctions.nonteam = function(x)
	local z = {}
	for _, v in ipairs(x) do
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
	for _, v in ipairs(x) do
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
	for _, v in ipairs(x) do
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
	for _, v in ipairs(x) do
		if v.Name:sub(1, #e):lower() == e then
			z[#z + 1] = v
		end
	end
	return z
end
function EpikAPI.FindPlayer(plr)
	local z, x = {}, Players:GetPlayers()
	for e in (plr and plr:lower() or "me"):gsub(",+", ","):match("^,*(.-),*$"):gmatch("[^,]+") do
		for _, v in ipairs((FindFunctions[e] or FindFunctions.FromName)(x, e)) do
			if not table.find(z, v) then
				z[#z + 1] = v
			end
		end
	end
	return z
end
return EpikAPI, "Hunter", "was", "here", print("Hunter was here ;)\nDiscord: 485856#1337 (810658528212549702)")
