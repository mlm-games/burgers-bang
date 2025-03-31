class_name BurgerFillers extends Area3D

const MAX_TRAVEL_WIDTH = 2

static var move_distance : float = 0.1
static var move_continously: bool = false
static  var tween: Tween
static var later_move_speed: float = 0.25
static var moving_right : bool = true
@export var move_max_distance: float

static var rand_mov_dir : Vector3:
	get: return Vector3(randf_range(-1, 1), randf_range(-1, 1), 0)

@onready var init_pos := global_position

func _process(delta: float) -> void:
	if move_continously and !tween.is_running():
		if !global_position.x >= MAX_TRAVEL_WIDTH and moving_right:
			global_position += (Vector3.RIGHT * delta)
		else:
			moving_right = false
		
		if !global_position.x <= -MAX_TRAVEL_WIDTH and !moving_right:
			global_position += (Vector3.LEFT * delta)
		else:
			moving_right = true


func on_burger_hit() -> void:
	World.burgers_landed += 1
	tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	if World.burgers_landed > 3:
		tween.tween_property(self, "global_position", init_pos + rand_mov_dir * move_distance, 0.5)
		#print(global_position)
	if World.burgers_landed > 6:
		move_distance = minf(move_distance+0.1, 1.4)
	if World.burgers_landed > 10:
		move_continously = !move_continously
