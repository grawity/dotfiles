local micro = import("micro")

local function setFileType(buf, ft)
	if ft == "sh" then
		buf:SetOption("filetype", "shell")
	else
		micro.Log("Unsupported Vim filetype '"..ft.."'")
	end
end

local function handleModeline(buf, line)
	micro.Log("Found Vim modeline <"..line..">")
	for t in line:gmatch("[^:]+") do
		k, v = t:match("([^=]+)=(.+)")
		if k and v then
			micro.Log("Modeline option <"..k.."> value <"..v..">")
			if k == "ft" then
				setFileType(buf, v)
			elseif k == "ts" then
				buf:SetOption("tabsize", v)
			elseif k == "sw" then
				-- ignore
			else
				micro.Log("Unknown Vim modeline option '"..k.."'")
			end
		else
			micro.Log("Modeline option <"..t.."> bool")
			if t == "et" then
				buf:SetOption("tabstospaces", "on")
			elseif t == "noet" then
				buf:SetOption("tabstospaces", "off")
			elseif t == "wrap" then
				buf:SetOption("softwrap", "on")
			elseif t == "nowrap" then
				buf:SetOption("softwrap", "off")
			else
				micro.Log("Unknown Vim modeline option '"..t.."'")
			end
		end
	end
	micro.Log("Finished modeline processing")
end

function onBufferOpen(buf)
	if (buf.Type.Scratch) or (buf.Path == "") then
		return
	end

	local ft = buf:FileType()
	if (ft ~= nil) and (ft ~= "unknown") then
		micro.Log("Not looking for modeline (already have filetype '"..ft.."')")
		return
	end

	local i
	for i = 0, 3 do
		local line = buf:Line(i)
		local match = line:match(" vim?: ([^ ]+)")
		if match then
			return handleModeline(buf, match)
		end
	end
end
