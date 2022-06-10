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
	}
	
}

