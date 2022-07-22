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
addSearchPath(moduleDirectory.."/Custom Module/EICAS")

components = {

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
	hydraulics {
		position = {2730 , 0, 1365, 1365},
		visible = true,
		fpsLimit = 50
	},
	eicas {
		position = {2730 , 1400, 1365, 1365},
		visible = true,
		fpsLimit = 50
	},
	fctl {}
}
