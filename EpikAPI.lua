local Players = game:GetService("Players")
local ME = Players.LocalPlayer
local EpikAPI = {
	Commands = {},
	Prefix = "'"
}
function EpikAPI.RegisterCommand(name, alias, callback)
	if type(alias) == "function" then
		alias, callback = callback, alias
	end
	assert(type(name) == "string", "bad argument #1 to 'EpikAPI.RegisterCommand' (string expected got " .. tostring((type(name) == "nil" and "no value") or typeof(name)) .. ") [Cmd:" .. name .. "]")
	assert(type(alias) == "table" or type(alias) == "nil", "bad argument #2 to 'EpikAPI.RegisterCommand' (table expected got " .. typeof(args) .. ") [Cmd:" .. name .. "]")
	assert(type(callback) == "function", "bad argument #3 to 'EpikAPI.RegisterCommand' (function expected got " .. tostring((type(callback) == "nil" and "no value") or typeof(callback)) .. ") [Cmd:" .. name .. "]")
	if type(alias) ~= "table" then
		alias = {alias}
	end
	for _, v in ipairs({name, unpack(alias or {})}) do
		EpikAPI.Commands[v] = callback
	end
end
local function RunCMDI(str)
	str = tostring(str)
	local args = {}
	if string.lower(string.sub(str, 1, #EpikAPI.Prefix)) == EpikAPI.Prefix then
		str = string.sub(str, #EpikAPI.Prefix + 1)
	end
	for _, v in ipairs({"/w ", "/t ", "/e ", "/whisper ", "/team ", "/emote "}) do
		if string.sub(str, 1, #v) == v then
			str = string.sub(str, #v + 1)
		end
	end
	str = string.match(str, "^%s*(.-)%s*$") .. " "
	local t = time()
	local escape = false
	while #str > 0 and time() - t < 3 do
		local s, e = string.find(str, " ", nil, true)
		local d, r = string.find(str, "\91\91", nil, true)
		if s and d and s > d then
			s, e = r + 1, (string.find(str, "\93\93"))
			if e then
				e = e - 1
				escape = string.sub(str, s, e)
				if string.sub(escape, 1, 2) == "\91\91" then
					escape = string.sub(escape, 3)
				end
				if string.sub(escape, -2) == "\93\93" then
					escape = string.sub(escape, 1, -3)
				end
			end
		end
		if s and e then
			local cstr = escape or string.sub(str, 1, s - 1)
			if cstr ~= "\93\93" and " " ~= cstr and cstr ~= "" then
				table.insert(args, cstr)
			end
			str = string.sub(str, e + 1)
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
	local Command = EpikAPI.Commands[string.lower(cmd)]
	if type(Command) ~= "function" then
		return warn("Invalid Command:", cmd)
	end
	for i, v in ipairs(args) do
		local n = tonumber(v)
		if n then
			v = n
		elseif v == "nil" then
			v = nil
		elseif v == "false" then
			v = false
		elseif v == "true" then
			v = true
		end
		args[i] = v
	end
	return coroutine.wrap(function()
		return xpcall(Command, function(msg)
			return warn((string.gsub(debug.traceback(msg), "[\n\r]+", "\n    ")))
		end, unpack(args))
	end)()
end
function EpikAPI.ExecuteCommand(msg)
	for v in string.gmatch(msg, "[^\\]+") do
		RunCMDI(v)
	end
end
local setprop = sethiddenproperty or sethiddenprop or sethidden or set_hidden_prop or set_hidden_property or function(x, i, v)
	x[i] = v
end
function EpikAPI.Instance(a1, a2, a3)
	assert(type(a1) == "string" and (type(a2) == "nil" or type(a2) == "table" or typeof(a2) == "Instance" or (typeof(a2) == "Instance" and type(a3) == "table")), "Invalid arguments to 'EpikAPI.Instance' (expected (string, Instance, table) or (string, table) or (string, Instance) got (" .. typeof(a1) .. ", " .. typeof(a2) .. ", " .. typeof(a3) .. "))")
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
				return warn((string.gsub(debug.traceback(msg, 4), "[\n\r]+", "\n    ")))
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
	local z = x and x.FindFirstChildWhichIsA(x, "Humanoid", true)
	return (z and (z.RootPart or z.Torso)) or x.PrimaryPart or x.FindFirstChild(x, "HumanoidRootPart") or x.FindFirstChild(x, "Torso") or x.FindFirstChild(x, "UpperTorso") or x.FindFirstChild(x, "LowerTorso") or x.FindFirstChild(x, "Head") or x.FindFirstChildWhichIsA(x, "BasePart", true)
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
		if v ~= ME and ME.IsFriendsWith(ME, v.UserId) then
			z[#z + 1] = v
		end
	end
	return z
end
FindFunctions.nonfriends = function(x)
	local z = {}
	for _, v in ipairs(x) do
		if v ~= ME and not ME.IsFriendsWith(ME, v.UserId) then
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
			local e = ME.DistanceFromCharacter(ME, x.Position)
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
			local e = ME.DistanceFromCharacter(ME, x.Position)
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
		if string.lower(string.sub(v.Name, 1, #e)) == e then
			z[#z + 1] = v
		end
	end
	return z
end
function EpikAPI.FindPlayer(plr)
	local z, x = {}, Players.GetPlayers(Players)
	for e in string.gmatch(plr and string.lower(plr) or "me", "[^,]+") do
		for _, v in ipairs((FindFunctions[e] or FindFunctions.FromName)(x, e)) do
			if not table.find(z, v) then
				z[#z + 1] = v
			end
		end
	end
	return z
end
print("Hunter was here ;)\nDiscord: 485856#1337 (810658528212549702)")
return EpikAPI
