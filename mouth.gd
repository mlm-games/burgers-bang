class_name Mouth extends Area3D

const MOVE_DIR = [Vector3.DOWN, Vector3.LEFT, Vector3.UP, Vector3.RIGHT]

@export var occasional_move_speed: float
@export var move_max_distance: float

@onready var mov_dir : Vector3 = MOVE_DIR.pick_random()

@onready var init_pos := global_position

func _process(delta: float) -> void:
	mov_dir = lerp(mov_dir, MOVE_DIR.pick_random(), delta)
	
	#var offset = move_direction * sin(Time.get_ticks_msec() / 1000.0 * move_speed) * move_distance
	#global_position = initial_position + offset
