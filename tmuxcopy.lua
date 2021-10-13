local util = import("micro/util")
local config = import("micro/config")
local shell = import("micro/shell")
local micro = import("micro")

local isTmux = ""

local function tmuxcopy(bp)
	local selection
	if(bp.Cursor:HasSelection() == true) then
		bp:Copy()
		selection = util.String(bp.Cursor:GetSelection())
	else
		bp:CopyLine()
		bp.Cursor:SelectLine()
		selection = util.String(bp.Cursor:GetSelection())
		bp.Cursor:Deselect(true)			
	end
	micro.InfoBar():Message("done")
end

local function onStdout(str, args)
	if(str ~= nil and str ~= "\n") then
		--is tmux
		config.MakeCommand("tmuxcopy", tmuxcopy, config.NoComplete)
		config.TryBindKey("Ctrl-c", "command:tmuxcopy", true)
	end
end

function init()

shell.JobStart("echo $TMUX $TERM_PROGRAM", onStdout, onStdout, onStdout)

end
