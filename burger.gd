class_name Burger extends RigidBody3D

const BurgerScene = preload("uid://cns07x2ciq2dr")

static func new_burger_at_position(pos: Vector3) -> Burger:
	var burger_instance := BurgerScene.instantiate()
	#burger_instance.global_position = pos
	#burger_instance.gravity_scale = 0.6
	return burger_instance
	
