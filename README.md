# serene_fanart_game
 
todo:
	- speed lines when ball torque greater than a value
	- make all the object sizes
	- map the object sizes to models
	- size ui in top left
	- timer ui in top right
	- dancing mario ui in bottom right
	- last picked up ui in bottom left
	- fix rotations on picked up objects
	- outro

credits:
	- booscaster for ripping the 2d mario 64 textures
	- https://www.models-resource.com/nintendo_64/supermario64/ for 3d models
		- alec pike for ripping the mario head model, ripping the peach model
		- name other guys from the readme.txt files
	- SFX: https://themushroomkingdom.net/media/sm64/wav

I rigged the peach model
Imported / rigged / exported / resized 3d models (Used Blender 3.4)
The level itself proved difficult, as Mario 64's collision detection is pretty different from a standard 3d game today.
	long and short, mario 64 calculates the angle of a surface to determine if it is a wall / ceiling / floor, modern games just use collision meshes
		- Had to slice the map up completely and write a custom tool to generate a collision mesh for each polygon, as Godot4 does not do concave collision meshes
Scripted everything from scratch (Used Godot4)
Adjusted some 2d textures (Used Krita)
Altered audio files for consistent mixing (Used Audacity)
