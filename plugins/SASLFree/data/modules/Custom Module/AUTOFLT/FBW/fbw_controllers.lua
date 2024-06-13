--[[
*****************************************************************************************
* Script Name: fbw_controllers
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: structure for PID controller(used by flight control systems)
*****************************************************************************************
--]]


PID = {kp = 0, ki = 0, kd = 0, errtotal = 0, errlast = 0, lim_out = 0,  lim_et = 0, output = 0}

function PID:new(tmp)
    tmp = tmp or {}
    setmetatable(tmp, self)
    self.__index = self
    return tmp
end

function PID:update(t)
	setmetatable(t,{__index={kp = self.kp, ki = self.ki, kd = self.kd}})
    local tgt, curr, kp, ki, kd =
      t[1] or t.tgt,
      t[2] or t.curr,
      t[3] or t.kp,
	  t[4] or t.ki,
	  t[5] or t.kd
	local tmp = PID_Compute(kp, ki, kd, tgt, curr, self.errtotal, self.errlast, self.lim_et, self.lim_out)
	self.output = tmp[1]
	self.errtotal = tmp[2]
	self.errlast = tmp[3]
end
