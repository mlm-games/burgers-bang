extends Node3D


var charging_throw: bool = false
var throw_power : float = 1
var burgers_thrown_count : int = 0

@onready var current_burger: Burger = $InitialBurger

func _input(event: InputEvent) -> void:
	if current_burger == null:
		return
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("Recognised")
			charging_throw = true
		else:
			charging_throw = false
			throw_burger()
		
			##global_position =  
			#
	#if event is InputEventMouseMotion and charging_throw:
		#var camera = get_viewport().get_camera_3d()
		#var dir_ray = get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(camera.project_ray_origin(event.position),\
			 #camera.project_ray_origin(event.position) + camera.project_ray_normal(event.position), 1))
		#if dir_ray:
			#current_burger.look_at((dir_ray.position - current_burger.global_transform.origin).normalized(), Vector3.UP)
		
func throw_burger() -> void:
	current_burger.apply_central_impulse(current_burger.global_transform.basis.z * throw_power)
	#TODO: set burger collision layer.
	burgers_thrown_count += 1
	%BurgersThrownCountLabel.text = tr("Burgers thrown count: ") + str(burgers_thrown_count)
	
	#%BurgerRespawnTimer.start(); await %BurgerRespawnTimer.timeout
	
