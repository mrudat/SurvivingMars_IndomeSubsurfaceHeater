return PlaceObj('ModDef', {
	'title', "Indome Subsurface Heater",
	'description', "Allows the subsurface heater to be built inside a dome.\n\nThe subsurface heater's range is centered on the dome.\n\nThe subsurface heater's minimum range heats every hex the dome occupies, and the maximum range heats the area that colonists will work in.\n\nA known issue is that the radius preview is centered on the subsurface heater, and not the dome.\n\nPermission is granted to update this mod to support the latest version of the game if I'm not around to do it myself.",
	'last_changes', "Don't break regular Subsurface Heaters.",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "mrudat_AllowBuildingInDome",
			'title', "Allow Building In Dome",
		}),
	},
	'id', "mrudat_IndomeSubsurfaceHeater",
	'steam_id', "1830442112",
	'pops_desktop_uuid', "97b9b91b-e43c-4756-bf6d-276a3f8fdac3",
	'pops_any_uuid', "39bd7206-1dd0-47be-9768-55ad4b54d23e",
	'author', "mrudat",
	'version', 9,
	'lua_revision', 233360,
	'saved_with_revision', 245618,
	'code', {
		"Code/IndomeSubsurfaceHeater.lua",
	},
	'saved', 1565608703,
})