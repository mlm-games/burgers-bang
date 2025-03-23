class_name Mouth extends Area3D

const MOVE_DIR = [Vector3.DOWN, Vector3.LEFT, Vector3.UP, Vector3.RIGHT]

var move_speed = 5

var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

@export var occasional_move_speed: float
@export var move_max_distance: float

@onready var mov_dir : Vector3:
	get: return MOVE_DIR.pick_random()

@onready var init_pos := global_position

func on_burger_hit(delta: float) -> void:
	tween.tween_property(self, "global_position", global_position + MOVE_DIR.pick_random() * move_speed, 0.25)
	
	#var offset = move_direction * sin(Time.get_ticks_msec() / 1000.0 * move_speed) * move_distance
	#global_position = initial_position + offset
