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

trs_pid = PID:new{kp = -0.19, ki = -0.023, kd = 0, errtotal = 0, errlast = 0, lim_out = 25,  lim_et = 1000}
p_delta_pid = PID:new{kp = 4.1, ki = 0, kd = 0.01, errtotal = 0, errlast = 0, lim_out = 33,  lim_et = 100}
gust_supr_pid = PID:new{kp = 0.02, ki = 0.01, kd = 0, errtotal = 0, errlast = 0, lim_out = 5,  lim_et = 10}
