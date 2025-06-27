--[[
*****************************************************************************************
* Script Name: fbw_bite
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for pfc self tests
*****************************************************************************************
--]]

fbw_self_test = globalPropertyi("Strato/777/fctl/pfc/selftest")
tmpdref = createGlobalPropertyf("Strato/777/goku_area/pfc_selftest", 0)
--Hydraulics
hyd_pressure = globalProperty("Strato/777/hydraulics/press")

--Global variables
sys_avail_last = {0, 0, 0}
self_test_time = 0
self_test_init = false
self_test_done = false
sec_tested = false
sec_init = false
sec_time = 0
dir_init = false
dir_time = 0

function UpdateSelfTest()
	local l_avail = bool2num(get(hyd_pressure, 1) >= 400)
	local c_avail = bool2num(get(hyd_pressure, 2) >= 400)
	local r_avail = bool2num(get(hyd_pressure, 3) >= 400)
	past_avail = bool2num(sys_avail_last[1] +sys_avail_last[2] + sys_avail_last[3] > 0)
	curr_avail = bool2num(l_avail+c_avail+r_avail > 0)
	--print(past_avail, curr_avail)
	if past_avail == 1 and curr_avail == 0 then
		self_test_time = get(c_time)
		self_test_done = false
		set(tmpdref, self_test_time)
		print(self_test_time)
	end
	if get(c_time) > self_test_time + PFC_BITE_DELAY_SEC and self_test_done == false and curr_avail == 0 then
		self_test_init = true
	elseif self_test_done == true then
		self_test_init = false
	end
	sys_avail_last[1] = l_avail
	sys_avail_last[2] = c_avail
	sys_avail_last[3] = r_avail
end

function DoSelfTest()
	if self_test_init == true and self_test_done == false then
		set(fbw_self_test, 1)
		--print(sec_tested, sec_init, sec_time, dir_time)
		if sec_tested == false and sec_init == false then
			set(fbw_mode, 2)
			sec_time = get(c_time)
			sec_init = true
		elseif sec_tested == false and sec_init == true then
			if get(c_time) >= sec_time + 5 then
				sec_tested = true
				sec_init = false
				set(fbw_mode, 3)
				dir_time = get(c_time)
				dir_init = true
			end
		end
		if dir_init == true then
			if get(c_time) >= dir_time + 5 then
				self_test_done = true
				sec_tested = false
				dir_init = false
				set(fbw_mode, 1)
			end
		end
	else
		set(fbw_self_test, 0)
	end
end

function ResetSelfTest()
	sys_avail_last = {0, 0, 0}
	self_test_time = 0
	self_test_init = false
	self_test_done = false
	sec_tested = false
	sec_init = false
	sec_time = 0
	dir_init = false
	dir_time = 0
end
