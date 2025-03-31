class_name Mouth extends Area3D

const MOVE_DIR = [Vector3.DOWN, Vector3.LEFT, Vector3.UP, Vector3.RIGHT]

static var move_distance : float = 0.1

var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

@export var occasional_move_speed: float
@export var move_max_distance: float

@onready var mov_dir : Vector3:
	get: return MOVE_DIR.pick_random()

@onready var init_pos := global_position

func on_burger_hit() -> void:
	World.burgers_landed += 1
	#tween.tween_property(self, "global_position", init_pos + MOVE_DIR.pick_random() * move_distance, 0.25)
	
	if World.burgers_landed > 3:
		global_position = init_pos + MOVE_DIR.pick_random() * move_distance
		print(global_position)
	if World.burgers_landed > 6:
		move_distance = minf(move_distance+0.1, 1.5)
