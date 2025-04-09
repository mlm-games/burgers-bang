class_name World extends Node3D

static var burgers_landed: int = 0

static var burger_score : int = 0

static var charging_throw: bool = false
static var throw_power : float = 1
static var burgers_thrown_count : int = 0

var burger_thrown: bool = false:
	set(val):
		current_burger = null
		burgers_thrown_count += 1

#var power_applied : float = 0  #Power applied in x direction
var reference_ray : Dictionary

@onready var viewport := get_viewport()
@onready var mouse_position : Vector3
@onready var camera := viewport.get_camera_3d()

@onready var current_burger: Burger = $InitialBurger
@onready var burger_spawn_point : Vector3 = current_burger.global_transform.origin

func _ready():
	Mouth.reset_values()

func _input(event: InputEvent) -> void:
	if current_burger == null:
		charging_throw = false
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				reference_ray = shoot_ray(event)
				print("Recognised")
				charging_throw = true
				#initial_swipe_pos = mouse_position
		
			
	if event is InputEventMouseMotion and charging_throw:
		await get_tree().create_timer(0.1).timeout
		if charging_throw and shoot_ray(event).position != reference_ray.position and current_burger != null: 
			throw_burger()

		#current_burger.global_position.x = get_viewport().get_global_mouse_position().x 
		#current_burger.global_position.y = get_viewport().get_mouse_position().y ##These are local coords
		
		#swipe_direction = Vector2.UP.direction_to(Vector2(mouse_position.x, mouse_position.y))
		#print((Vector2.UP.direction_to(Vector2(mouse_position.x, mouse_position.y))))
			#current_burger.look_at((dir_ray.position - current_burger.global_transform.origin).normalized(), Vector3.UP)
		
func throw_burger() -> void:
	current_burger.gravity_scale = 1
	
	var screen_center := Vector2(DisplayServer.screen_get_size().x/2, DisplayServer.screen_get_size().y/2)
	var mouse_pos := DisplayServer.mouse_get_position()
	
	var direction := (mouse_pos - Vector2i(screen_center))
	
	var angle := atan2(direction.x, direction.y)
	
	#if angle > -PI/2 and angle < PI/2: angle += 3*PI/2
	current_burger.rotation.y = angle
	
	current_burger.apply_central_impulse(-current_burger.global_transform.basis.z * throw_power)
	current_burger.apply_central_impulse(current_burger.global_transform.basis.y * throw_power * 2)  #HACK: Add some upward force temporarily. Implement it differently
	
	#TODO: Try to get the ball to apply the x-axis rotation for the force being applied based on the direction of the mouse pointer.
	#TODO: set burger collision layer.
	
	#current_burger.apply_central_impulse(Vector3(current_burger.global_position.angle_to(mouse_position) - PI/2, 0, 0))
	
	burger_thrown = true
	
	if %BurgerRespawnTimer.is_stopped(): %BurgerRespawnTimer.start()

	
	charging_throw = false
	
	#%BurgerRespawnTimer.start(); await %BurgerRespawnTimer.timeout
	
##Extra info: https://stackoverflow.com/questions/76893256/how-to-get-the-3d-mouse-pos-in-godot-4-1 or the yt vid
func shoot_ray(event: InputEvent) -> Dictionary:
	var dir_ray : Dictionary = get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(camera.project_ray_origin(event.position),\
			 camera.project_ray_origin(event.position) + (camera.project_ray_normal(event.position) * camera.far)))
	if !dir_ray: 
		mouse_position = camera.project_ray_origin(event.position) + (camera.project_ray_normal(event.position) * camera.far)
		return {"position": mouse_position}
	else:
		return dir_ray

#func _process(delta: float) -> void:
	#if charging_throw:
		#throw_power = throw_power * ((delta + 100)/2)
		#current_burger.gravity_scale = -0.1
	#else:
		#throw_power = 1 #TODO: add it on new burger spawn
		#current_burger.gravity_scale = 0.6
		#current_burger.global_transform.origin = get_viewport().get_mouse_position()


func _on_burger_respawn_timer_timeout() -> void:
	current_burger = Burger.new_burger_at_position(burger_spawn_point)
	add_child(current_burger)
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(current_burger, "scale", Vector3.ONE, 0.2)


func _on_mouth_body_entered(body: Node3D) -> void:
	if body is Burger or body is RigidBody3D: #Class based identifaction doesnt work (as of 4.4)
		body.minimize_and_queue_free()
		%MouthPortal.on_burger_hit()
		%BurgerLandedSound.play()
		burger_score += body.burger_points
		%Points.text = tr("Burger Score: ") + str(burger_score)


func _on_death_plane_body_entered(body: Node3D) -> void:
	if body is Burger or body is RigidBody3D:
		body.queue_free()
		%DeathSound.play()
		print("Game Over")
		GameOverStatsScreen.highscore = maxi(GameOverStatsScreen.highscore, burger_score)
		Transitions.change_scene_with_transition("uid://dhp6qc7m1lijw")
		#TODO: Play game over sound.
