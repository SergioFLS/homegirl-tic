
--Starts Nalquas' TIC-80 compatibility layer and attempts to launch the given file.
--Will currently only work if no TIC functions are executed before TIC()

function _init(args)
	if #args==1 then
		require("sys:libs/tic_compatibility")
		require(args[1])
		startCompatibility()
	else
		print("Invalid usage. Correct usage: tic [filename]")
		sys.exit(0)
	end
end