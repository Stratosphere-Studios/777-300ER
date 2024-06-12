time_elapsed = globalPropertyf("Strato/777/time/current")

timer = sasl.createTimer()
sasl.startTimer(timer)

function update()
	set(time_elapsed, sasl.getElapsedSeconds(timer))
end

function onModuleDone()
	sasl.stopTimer(timer)
end