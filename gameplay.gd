extends Node3D


var charging_throw: bool = false
var throw_power : float = 1
var burgers_thrown_count : int = 0

@onready var viewport := get_viewport()
@onready var mouse_position : Vector3
@onready var camera := viewport.get_camera_3d()

@onready var current_burger: Burger = $InitialBurger
@onready var burger_spawn_point : Vector3 = current_burger.global_transform.origin


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
			if %BurgerRespawnTimer.is_stopped(): %BurgerRespawnTimer.start()
		
			
			#
	if event is InputEventMouseMotion and charging_throw:
		var dir_ray : Dictionary = get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(camera.project_ray_origin(event.position),\
			 camera.project_ray_origin(event.position) + (camera.project_ray_normal(event.position) * camera.far)))
		if !dir_ray: 
			mouse_position = camera.project_ray_origin(event.position) + (camera.project_ray_normal(event.position) * camera.far)
		else:
			mouse_position = dir_ray["position"]
		print(mouse_position)
			#current_burger.look_at((dir_ray.position - current_burger.global_transform.origin).normalized(), Vector3.UP)
		
func throw_burger() -> void:
	current_burger.gravity_scale = 1
	current_burger.apply_central_impulse(current_burger.global_transform.basis.z * throw_power)
	current_burger.apply_central_impulse(current_burger.global_transform.basis.y * throw_power * 2)
	#TODO: set burger collision layer.
	burgers_thrown_count += 1
	%BurgersThrownCountLabel.text = tr("Burgers thrown count: ") + str(burgers_thrown_count)
	
	#%BurgerRespawnTimer.start(); await %BurgerRespawnTimer.timeout
	

func _process(delta: float) -> void:
	if charging_throw:
		#throw_power = throw_power * ((delta + 100)/2)
		current_burger.gravity_scale = -0.1
	#else:
		#throw_power = 1 #TODO: add it on new burger spawn
		#current_burger.gravity_scale = 0.6
		#current_burger.global_transform.origin = get_viewport().get_mouse_position()


func _on_burger_respawn_timer_timeout() -> void:
	current_burger = Burger.new_burger_at_position(burger_spawn_point)
	add_child(current_burger)
	
	
