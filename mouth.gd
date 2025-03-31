class_name BurgerFillers extends Area3D

static var move_distance : float = 0.1

static var later_move_speed: float = 0.25
@export var move_max_distance: float

static var rand_mov_dir : Vector3:
	get: return Vector3(randf_range(-1, 1), randf_range(-1, 1), 0)

@onready var init_pos := global_position

func on_burger_hit() -> void:
	World.burgers_landed += 1
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	if World.burgers_landed > 3:
		tween.tween_property(self, "global_position", init_pos + rand_mov_dir * move_distance, 0.5)
		#print(global_position)
	if World.burgers_landed > 6:
		move_distance = minf(move_distance+0.1, 1.4)
	if World.burgers_landed > 10:
		var tween2 = get_tree().create_tween().set_loops(10)
		if global_position.y == get_viewport().size.y - 20:
			tween2.tween_property(self, "global_position", global_position + Vector3.LEFT/10, 0.05)
		else:
			tween2.tween_property(self, "global_position", global_position + Vector3.RIGHT/10, 0.05)
