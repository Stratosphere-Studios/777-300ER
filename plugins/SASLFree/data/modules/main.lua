-- main.lua
size = {4096, 4096}
panel2d = false
panelWidth3d = 4096
panelHeight3d = 4096
sasl.options.set3DRendering(true)
sasl.options.setAircraftPanelRendering(true)
sasl.options.setInteractivity(true)
addSearchPath(moduleDirectory.."/Custom Module/EICASCHECK")
addSearchPath(moduleDirectory.."/Custom Module/CURSOR")
addSearchPath(moduleDirectory.."/Custom Module/HYD")
addSearchPath(moduleDirectory.."/Custom Module/FCTL")
addSearchPath(moduleDirectory.."/Custom Module/EICAS/UPPER")
addSearchPath(moduleDirectory.."/Custom Module/EICAS/LOWER")

altn_gear = createGlobalPropertyi("Strato/777/gear/altn_extnsn", 0)
normal_gear = createGlobalPropertyi("Strato/777/gear/norm_extnsn", 1)
act_press = createGlobalPropertyi("Strato/777/gear/actuator_press", 0)

components = {

	timers {},
	hydraulics {},
	fctl {},
	gear {},
	eicascheck {
		position = {2730 , 0, 1365, 1365},
		visible = true,
		fpsLimit = 50
	},
	Cursor {
		position = {2730 , 0, 1365, 1365},
		visible = true,
		fpsLimit = 50
	},
	eicas_graphics{
		position = {2730 , 0, 1365, 1365},
		visible = true,
		fpsLimit = 50
	},
	eicas {
		position = {2730 , 1400, 1365, 1365},
		visible = true,
		fpsLimit = 50
	}
}
