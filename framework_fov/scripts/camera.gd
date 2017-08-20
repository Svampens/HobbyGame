extends Camera2D

export var max_offset = 300.0
export var min_offset = 50.0
export var damp_factor = 0.5

var map_has_loaded = false

onready var map =get_node("../../map")
onready var corners = get_node("../../map")
onready var lines = get_node("../../map")

func _ready():
	set_fixed_process(true)
	
func _draw():
	if map_has_loaded:
		draw_lines_to_corners()
		draw_walls()
	
func _fixed_process(delta):
	var offset = Vector2(get_global_mouse_pos()) - Vector2(get_global_pos())
	if offset.length() < max_offset:
		set_offset(offset*damp_factor)
	else:
		set_offset(offset.normalized()*max_offset*damp_factor)
		
	if !map_has_loaded:
		corners = map.get_inner_corner_pixels()
		lines = map.get_lines()
		map_has_loaded= true
	update()
		
func draw_lines_to_corners():
	for i in range (0,corners.size()):
		draw_line(Vector2(0,0),get_local_cords(corners[i]),"ff0000", 1)

func draw_walls():
	for i in range (0,lines.size()):
		draw_line(get_local_cords(lines[i][0]),get_local_cords(lines[i][1]),"0000ff", 1)

func get_local_cords(global_cords):
	return global_cords-get_global_pos()
	
	