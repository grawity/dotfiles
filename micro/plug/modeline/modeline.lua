local micro = import("micro")

local function setFileType(buf, ft)
	if ft == "sh" then
		buf:SetOption("filetype", "shell")
	end
end

local function handleModeline(buf, line)
	micro.Log("it's a modeline: <" .. line .. ">")
	for t in line:gmatch("[^:]+") do
		micro.Log("token <" .. t .. ">")
		k, v = t:match("([^=]+)=(.+)")
		if k and v then
			micro.Log("  token is kvpair <" .. k .. "> = <" .. v .. ">")
			if k == "ft" then
				setFileType(buf, v)
			elseif k == "ts" then
				buf:SetOption("tabsize", v)
			end
		else
			micro.Log("  token is bool <" .. t .. ">")
			if k == "et" then
				buf:SetOption("tabstospaces", true)
			elseif k == "noet" then
				buf:SetOption("tabstospaces", false)
			end
		end
	end
end

function onBufferOpen(buf)
	if (buf.Type.Scratch) or (buf.Path == "") then
		return
	end

	local ft = buf:FileType()
	if (ft ~= nil) and (ft ~= "unknown") then
		micro.Log("filetype not nil: " .. ft)
		return
	end

	local i
	for i = 0, 3 do
		local line = buf:Line(i)
		micro.Log("line " .. i .. " is <" .. line .. ">")
		local match = line:match(" vim?: ([^ ]+)")
		if match then
			return handleModeline(buf, match)
		end
	end
end
