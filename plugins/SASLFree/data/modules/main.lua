-- main.lua
size = {4096, 4096}
panel2d = false
panelWidth3d = 4096
panelHeight3d = 4096
sasl.options.set3DRendering(true)
sasl.options.setAircraftPanelRendering(true)
sasl.options.setInteractivity(true)
addSearchPath(moduleDirectory.."/Custom Module/Eicas/Engine")
addSearchPath(moduleDirectory.."/Custom Module/Eicas/fcs")



components = {

	EFB {
		position = {2130 ,30, 4096, 4096},
		visible = true,
	},
	Cursor {
		position = {2130 ,30, 4096, 4096},
		visible = true,
	}
	
	

	

	
}

