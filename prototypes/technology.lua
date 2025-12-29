
data:extend({
	-- --------------------

	{
		type = "technology",
		name = "technology-quality-for-biters-clear",
		icon_size = 256,
		icon = "__BiterShield2__/graphics/technology/technology-quality-for-biters-clear.png",
		prerequisites = {"space-science-pack"},	-- Previous research as a prerequisite
		unit = {
			count_formula = "1000000*(L^1.5)",	-- Formula for increasing cost per level
			ingredients = {
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"military-science-pack", 1},
			{"chemical-science-pack", 1},
			{"production-science-pack", 1},
			{"utility-science-pack", 1},
			{"space-science-pack", 1},
			},
			time = 60
		},
		max_level = "infinite",	-- Infinite research
		effects = {
			{
			type = "nothing",
			effect_description = {"technology-effect-quality.nothing"}
			}
		},
		order = "z-a"
	}
})
