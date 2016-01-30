--[[
Stop LUAJIT Out-Of-Memory (OOM) crashes [stop_lj_oom]

by: blert2112
license: WTFPL

What it does:
		Runs the LUA Garbage Collector if the garbage memory count exceeds the
	specified limit.
		LUAJIT is restricted to the lower 1GB/2GB/4GB (depending on OS and
	bitness), regardless of the fact that you may have 128GBs installed in your
	rig, but much of that is being taken up by persistent things that don't get
	garbage collected. When something happens that makes LUAJIT exceed it's
	memory limit it crashes.
		From what I can discern, when you see a LUA_OOM crash the value that is
	reported to you is not the amount of memory LUAJIT is using, it is the
	amount of memory that can potentially be freed with a garbage collection
	AT THE TIME THE SAMPLE WAS TAKEN. What this mean is: The engine got a sample
	value of LUAJIT's garbage memory count, let's say it was 70MB. Then,
	something happened to cause LUAJIT to exceed it's memory limit and... BOOM!
	Since it crashed before it could get another usage value it reports that it
	crashed with a 70MB usage. So, between then and now, there could very well
	have been a huge amount of garbage that needed collecting.
	
How to use:
	Just enable the mod as you would any other.

Configuration:
		See that number down there on line 45?... When LUAJIT's garbage memory
	count exceeds that number the Garbage Collector will be run. Change the
	number to fit your needs. It is in KB, the default of 307200 is 300MB
	(300x1024). The smaller the number the more the	Garbage Collector will be
	run, resulting in slower performance and possibly unfinished collections or
	even causing the collector to never complete, so be careful not to set it
	too low. If, for example, your game has crashed with memory usage of 70MB
	do not set this number to 71680, that reported number is inaccurate! That
	value was sampled before even more memory was used which caused the crash.
	Start high and slowly decrease the value if you need to.
		Uncomment the "print" line (44) if you want to see the memory usage
	numbers in the console as they are counted and collected.
]]

minetest.register_globalstep(function(dtime)
	--print(collectgarbage("count"))
	if collectgarbage("count") > 307200 then
		core.log("action", "[MOD] [stop_lj_oom]: Collecting Garbage")
		collectgarbage()
	end
end)
