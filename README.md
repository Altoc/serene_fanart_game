# serene_fanart_game
 
todo:
	- Actually write intro dialogue
	- SFX for enemies
	- outro scene

credits:
	- booscaster for ripping the 2d mario 64 textures
	- https://www.models-resource.com/nintendo_64/supermario64/ for 3d models
		- alec pike for ripping the mario head model, ripping the peach model
		- name other guys from the readme.txt files
	- SFX: https://themushroomkingdom.net/media/sm64/wav

I rigged some of the models (peach was the most interesting)
Imported / rigged / exported / resized 3d models (Used Blender 3.4)
The level geometry itself proved difficult, as Mario 64's collision detection is pretty different from a standard 3d game today.
	long and short, mario 64 calculates the angle of a surface to determine if it is a wall / ceiling / floor, modern games just use collision meshes
		- Had to slice the map up completely and write a custom tool to generate a collision mesh for each polygon, as Godot4 does not do concave collision meshes
Scripted everything from scratch (Used Godot4)
Adjusted some 2d textures (Used Krita)
Altered audio files for consistent mixing (Used Audacity)
Programming / implementation took the most time, with placing the enemies in the level coming in second for most time spent
