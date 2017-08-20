extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	init_fov()
	set_fixed_process(true)


func init_fov():
	var ray_phi = 0
	var ray_dir = Vector2(1,0)
	for i in range(0,nr_rays):
		var ray = RayCast2D.new()
		ray.set_type_mask(15)
		ray.set_cast_to(ray_dir.rotated(ray_phi)*1000)
		ray.set_enabled(true)
		add_child(ray)
		rays.append(ray)
		collision_points.append(ray.get_collision_point())
		ray_phi += 2*PI/nr_rays