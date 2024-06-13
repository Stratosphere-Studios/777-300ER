--[[
*****************************************************************************************
* Script Name: timers
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Plugin-wide timer implementation
*****************************************************************************************
--]]


time_elapsed = globalPropertyf("Strato/777/time/current")

timer = sasl.createTimer()
sasl.startTimer(timer)

function update()
	set(time_elapsed, sasl.getElapsedSeconds(timer))
end

function onModuleDone()
	sasl.stopTimer(timer)
end