extends RigidBody2D

export var speed = 300

func _ready():
	print("player global pos:" + String(get_global_pos()))
	set_fixed_process(true)
	
	
func _fixed_process(delta):
	var mouse_direction = Vector2(get_local_mouse_pos())
	var move_direction = Vector2(0,0)
	
	if Input.is_action_pressed("btn_forward"):
		move_direction += mouse_direction
	if Input.is_action_pressed("btn_backward"):
		move_direction += mouse_direction.rotated(PI)
	if Input.is_action_pressed("btn_strafe_l"):
		move_direction += mouse_direction.rotated(PI/2)
	if Input.is_action_pressed("btn_strafe_r"):
		move_direction += mouse_direction.rotated(-PI/2)
	set_linear_velocity(move_direction.normalized()*speed)
	