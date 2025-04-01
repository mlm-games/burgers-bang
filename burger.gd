class_name Burger extends RigidBody3D

const BurgerScene = preload("uid://cns07x2ciq2dr")

var burger_points: int = 3

static func new_burger_at_position(pos: Vector3) -> Burger:
	var burger_instance := BurgerScene.instantiate()
	#burger_instance.global_position = pos
	#burger_instance.gravity_scale = 0.6
	burger_instance.scale = Vector3.ZERO
	return burger_instance
	

#TODO: Add particles on scoring

func _on_score_reduce_after_timer_timeout() -> void:
	burger_points = 2
