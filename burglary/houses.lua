-- This file contains all houses, doors and spawn locations

houses = {
	{
		ipl = "hei_hw1_blimp_interior_v_studio_lo_milo_",
		-- coords of entry point
		coords = {
			x = 265.53,
			y = -1002.9,
			z = -99.01 - 0.89,
			heading = 13.0
		},
		-- coords of marker/exit point
		door = vec3(265.985, -1007.247, -101.008),
		-- pickups inside house
		pickups = {
			{
				coord = vec3(262.0387, -1000.613, -99.2985), -- location of pickup
				model = "prop_pap_camera_01", -- model https://objects.gt-mp.net/index.php
				rotation = 20.0,
				value = 150.0 -- the money which the item is worth
			},
			{
				coord = vec3(258.414, -996.7075, -99.5623),
				model = "prop_cash_case_02",
				rotation = 200.0,
				value = 250.0
			},
			{
				coord = vec3(259.7399, -1003.679, -100.008),
				model = "prop_amp_01",
				rotation = 150.0,
				value = 100.0
			}
		},
		-- area of the house
		area = {
			vec3(266.961, -1007.903, -102.139),
			vec3(253.130, -993.894, -96.411)
		}
	},
	{
		ipl = "hei_hw1_blimp_interior_v_studio_lo_milo_",
		coords = {
			x = 346.798,
			y =  -1009.72,
			z = -99.2 - 0.89,
			heading = 350.0 
		},
		door = vec3(346.420, -1012.641, -99.196),
		pickups = {
			{
				coord = vec3(338.33, -995.988, -100.1962),
				model = "p_amb_lap_top_02",
				rotation = 45.0,
				value = 100.0
			},
			{
				coord = vec3(344.6826, -995.7067, -100.1962),
				model = "prop_speaker_03",
				rotation = 366.0,
				value = 70.0
			},
			{
				coord = vec3(352.0621, -994.333, -100.1962),
				model = "prop_t_telescope_01b",
				rotation = 210.0,
				value = 95.55
			},
			{
				coord = vec3(341.8545, -1002.137, -99.283),
				model = "prop_toaster_01",
				rotation = 90.0,
				value = 30.0
			}
		},
		area = {
			vec3(352.788, -992.770, -100.424),
			vec3(336.769, -1013.686, -96.824)
		}
	}
}

-- All doors linked to houses above, house = index from above
doors = {
	{
		house = 1,
		coords = {
			x = -46.34,
			y = -1446.24,
			z = 32.43
		}		
	},
	{
		house = 2,
		coords = {
			x = -139.48,
			y = -1588.042,
			z = 34.24,
		}
	},
	{
		house = 2,
		coords = {
			x = 257.11,
			y = -1723.26,
			z = 29.65
		}
	},
	{
		house = 1,
		coords = {
			x = 455.21,
			y = -1579.75,
			z = 32.79
		}
	},
	{
		house = 1,
		coords = {
			x = 256.57,
			y = -2023.59,
			z = 19.27
		}
	}
}

-- residents which spawn inside the houses
residents = {
	{
		house = 2,
		coord = vec3(349.8, -996.141, -98.7399),
		rotation = 90.0,
		animation = { dict = "amb@lo_res_idles@", anim = "lying_face_up_lo_res_base" }, -- sleeping animation
		model = "a_f_y_hipster_01",
		aggressive = false -- if they should attack after waking up
	},
	{
		house = 1,
		coord = vec3(262.34, -1004.14, -99.27),
		rotation = 270.0,
		animation = { dict = "amb@lo_res_idles@", anim = "lying_face_up_lo_res_base" },
		model = "a_m_y_beach_02",
		aggressive = true
	}
}