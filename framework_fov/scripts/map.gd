extends TileMap

export var pixels_per_tile = 32


#	Functions:
#	find_corners() - Finner alla hörn på kartan
#	create_lines() - Skapar linjer (Array) uttryckta i två vektorer
#	get_inner_corner_pixels() - Returnerar hörnpunkter i globala kordinater
#	get_lines() - Returnerar lines (Array)


var inner_corner_pixels = Array() #lista med hörnens pixlar i globala kordinater
var corner_types = Array() #lista med hörntyper
var corners = Array() #lista med hörn utryckta i TileMap koordinater
var lines = Array() # lista med linjer (två vektorer) mellan hörn


var wall = 8
var ground = 9

var connects_to = Array()

func _ready():
	find_corners()
	create_lines()



func find_corners(): # ------------------------------ Finner alla hörn på karten
	for i in range (0,get_used_cells().size()):
		var current_cell = get_used_cells()[i]
		if get_cellv(current_cell) == wall: # Om current cell är en väggu
			if get_cell(current_cell.x+1,current_cell.y) == wall && get_cell(current_cell.x,current_cell.y+1) == wall && get_cell(current_cell.x+1,current_cell.y+1) == ground :
				corners.append(current_cell)
				corner_types.append("outer_lower_right")
			if get_cell(current_cell.x-1,current_cell.y) == wall && get_cell(current_cell.x,current_cell.y+1) == wall && get_cell(current_cell.x-1,current_cell.y+1) == ground :
				corners.append(current_cell)
				corner_types.append("outer_lower_left")
			if get_cell(current_cell.x+1,current_cell.y) == wall && get_cell(current_cell.x,current_cell.y-1) == wall && get_cell(current_cell.x+1,current_cell.y-1) == ground :
				corners.append(current_cell)
				corner_types.append("outer_upper_right")
			if get_cell(current_cell.x-1,current_cell.y) == wall && get_cell(current_cell.x,current_cell.y-1) == wall && get_cell(current_cell.x-1,current_cell.y-1) == ground:
				corners.append(current_cell)
				corner_types.append("outer_upper_left")
			if get_cell(current_cell.x-1,current_cell.y) == wall && get_cell(current_cell.x,current_cell.y-1) == wall && get_cell(current_cell.x+1,current_cell.y+1) == ground :
				corners.append(current_cell)
				corner_types.append("inner_lower_right")
			if get_cell(current_cell.x+1,current_cell.y) == wall && get_cell(current_cell.x,current_cell.y-1) == wall && get_cell(current_cell.x-1,current_cell.y+1) == ground :
				corners.append(current_cell)
				corner_types.append("inner_lower_left")
			if get_cell(current_cell.x-1,current_cell.y) == wall && get_cell(current_cell.x,current_cell.y+1) == wall && get_cell(current_cell.x+1,current_cell.y-1) == ground :
				corners.append(current_cell)
				corner_types.append("inner_upper_right")
			if get_cell(current_cell.x,current_cell.y+1) == wall && get_cell(current_cell.x+1,current_cell.y) == wall && get_cell(current_cell.x-1,current_cell.y-1) == ground :
				corners.append(current_cell)
				corner_types.append("inner_upper_left")
				
	for i in range (0,corners.size()):
		var mapped_to_world = map_to_world(corners[i])
		if ("lower_right").is_subsequence_of(corner_types[i]):
			mapped_to_world.x += pixels_per_tile
			mapped_to_world.y += pixels_per_tile
		if ("lower_left").is_subsequence_of(corner_types[i]):
			mapped_to_world.y += pixels_per_tile
		if ("upper_right").is_subsequence_of(corner_types[i]):
			mapped_to_world.x += pixels_per_tile
		inner_corner_pixels.append(mapped_to_world)


func create_lines(): # -------------------------------------------------------- Skapar linjer mellan hörn

	for i in range (0,corners.size()):
		var connections = Array()
		var types = Array()
		
		#Hitta alla hörn med samma y-värde:
			
		for n in range (0,corners.size()):
			if corners[i].y == corners[n].y && corners[i] != corners[n] :
				connections.append(corners[n])
				types.append(corner_types[n])
		
		# Ta bort hörn som inte passar i x-led:
		
		var remove_indexes = Array()
		for n in range (0,connections.size()):
			if  corner_types[i] == "inner_lower_left" or corner_types[i] == "outer_lower_right":
				if types[n] != "inner_lower_right" && types[n] != "outer_lower_left":
					remove_indexes.append(n)
				if types[n] == "inner_lower_right" && connections[n].x < corners[i].x && corner_types[i] == "inner_lower_left":
					remove_indexes.append(n)
				if types[n] == "outer_lower_left" && connections[n].x < corners[i].x && corner_types[i] == "outer_lower_right":
					remove_indexes.append(n)
					
			elif corner_types[i] == "inner_lower_right" or corner_types[i] == "outer_lower_left":
				if types[n] != "inner_lower_left" && types[n] != "outer_lower_right":
					remove_indexes.append(n)
				if types[n] == "inner_lower_left" && connections[n].x > corners[i].x && corner_types[i] == "inner_lower_right":
					remove_indexes.append(n)
				if types[n] == "outer_lower_right" && connections[n].x > corners[i].x && corner_types[i] == "outer_lower_left":
					remove_indexes.append(n)
			
			elif corner_types[i] == "inner_upper_left" or corner_types[i] == "outer_upper_right":
				if types[n] != "inner_upper_right" && types[n] != "outer_upper_left":
					remove_indexes.append(n)
				if types[n] == "inner_upper_right" && connections[n].x < corners[i].x && corner_types[i] == "inner_upper_left":
					remove_indexes.append(n)
				if types[n] == "outer_upper_left" && connections[n].x < corners[i].x && corner_types[i] == "outer_upper_right":
					remove_indexes.append(n)
				
			elif corner_types[i] == "inner_upper_right" or corner_types[i] == "outer_upper_left":
				if types[n] != "inner_upper_left" && types[n] != "outer_upper_right":
					remove_indexes.append(n)
				if types[n] == "inner_upper_left" && connections[n].x > corners[i].x && corner_types[i] == "inner_upper_right":
					remove_indexes.append(n)
				if types[n] == "outer_upper_right" && connections[n].x > corners[i].x && corner_types[i] == "outer_upper_left":
					remove_indexes.append(n)
					
		if remove_indexes.size() > 0:
			for n in range (remove_indexes.size(),0,-1):
				connections.remove(remove_indexes[n-1])
		
		# Om flera hörn kvarstår spara det som är närmast:

		if connections.size() > 1:
			var closest = Vector2(1000,1000)
			for n in range(0,connections.size()):
				var closest_distance = closest - corners[i]
				var distance = connections[n] - corners[i]
				if distance.abs() < closest_distance.abs():
					closest = connections[n]
			connects_to.append(closest)
		else:
			connects_to.append(connections[0])
			
	for i in range (0,corners.size()):
		connects_to[i]=corners.find(connects_to[i])


	## Gör samma sak för y-led:
	var connects_to_x = connects_to
	
	connects_to = Array()

	for i in range (0,corners.size()):
		var connections = Array()
		var types = Array()
			
		#Hitta alla hörn med samma x-värde:				
		for n in range (0,corners.size()):
			if corners[i].x == corners[n].x && corners[i] != corners[n] :
				connections.append(corners[n])
				types.append(corner_types[n])
		
		# Ta bort hörn som inte passar i x-led:
		var remove_indexes = Array()
		for n in range (0,connections.size()):
			if  corner_types[i] == "inner_lower_left" or corner_types[i] == "outer_upper_left":
				if types[n] != "inner_upper_left" && types[n] != "outer_lower_left":
					remove_indexes.append(n)
				if types[n] == "inner_upper_left" && connections[n].y > corners[i].y && corner_types[i] == "inner_lower_left":
					remove_indexes.append(n)
				if types[n] == "outer_lower_left" && connections[n].y > corners[i].y && corner_types[i] == "outer_upper_left":
					remove_indexes.append(n)
				
			elif corner_types[i] == "inner_lower_right" or corner_types[i] == "outer_upper_right":
				if types[n] != "inner_upper_right" && types[n] != "outer_lower_right":
					remove_indexes.append(n)
				if types[n] == "inner_upper_right" && connections[n].y > corners[i].y && corner_types[i] == "inner_lower_right":
					remove_indexes.append(n)
				if types[n] == "outer_lower_right" && connections[n].y > corners[i].y && corner_types[i] == "outer_upper_right":
					remove_indexes.append(n)

			elif corner_types[i] == "inner_upper_left" or corner_types[i] == "outer_lower_left":
				if types[n] != "inner_lower_left" && types[n] != "outer_upper_left":
					remove_indexes.append(n)
				if types[n] == "inner_lower_left" && connections[n].y < corners[i].y && corner_types[i] == "inner_upper_left":
					remove_indexes.append(n)
				if types[n] == "outer_upper_left" && connections[n].y < corners[i].y && corner_types[i] == "outer_lower_left":
					remove_indexes.append(n)
					
			elif corner_types[i] == "inner_upper_right" or corner_types[i] == "outer_lower_right":
				if types[n] != "inner_lower_right" && types[n] != "outer_upper_right":
					remove_indexes.append(n)
				if types[n] == "inner_lower_right" && connections[n].y < corners[i].y && corner_types[i] == "inner_upper_right":
					remove_indexes.append(n)
				if types[n] == "outer_upper_right" && connections[n].y < corners[i].y && corner_types[i] == "outer_lower_right":
					remove_indexes.append(n)
						
		if remove_indexes.size() > 0:
			for n in range (remove_indexes.size(),0,-1):
				connections.remove(remove_indexes[n-1])
			
		# Om flera hörn kvarstår spara det som är närmast:
		if connections.size() > 1:
			var closest = Vector2(1000,1000)
			for n in range(0,connections.size()):
				var closest_distance = closest - corners[i]
				var distance = connections[n] - corners[i]
				if distance.abs() < closest_distance.abs():
					closest = connections[n]
			connects_to.append(closest)
		else:
			connects_to.append(connections[0])
		
	for i in range (0,corners.size()):
		connects_to[i]=corners.find(connects_to[i])

	var connects_to_y = connects_to
	

	# Skapa linjer
	var line = Array()
	
	for i in range (0,corners.size()):
		
		#x-led:
		var line_start = inner_corner_pixels[i]
		var line_end_x = inner_corner_pixels[connects_to_x[i]]
		var line_end_y = inner_corner_pixels[connects_to_y[i]]
		
		var line = Array()
		line.append(line_start)
		line.append(line_end_x)
		lines.append(line)
		var line = Array()
		line.append(line_start)
		line.append(line_end_y)
		lines.append(line)
	
	# Ta bort dubletter
	var copy_of_lines = lines
	
	for i in range (lines.size()-1,0,-1):
		
		var inverted_line = Array()
		var start = lines[i][1]
		var end = lines[i][0]
		inverted_line.append(start)
		inverted_line.append(end)
		if copy_of_lines.has(inverted_line):
			copy_of_lines.remove(i)
	lines = copy_of_lines
	
	
func get_lines():
	return lines
	
func get_inner_corner_pixels():
	return inner_corner_pixels
	

	 	   
