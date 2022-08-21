time_elapsed = createGlobalPropertyf("Strato/777/time/current", 0)

timer = sasl.createTimer()
sasl.startTimer(timer)

function update()
	set(time_elapsed, sasl.getElapsedSeconds(timer))
end

function onModuleDone()
	sasl.stopTimer(timer)
end