class_name Burger extends RigidBody3D

const BurgerScene = preload("uid://cns07x2ciq2dr")
@onready var burger: Node3D = $burger

var burger_points: int = 4

@onready var animation_player: AnimationPlayer = %AnimationPlayer

static func new_burger_at_position(_pos: Vector3) -> Burger:
	var burger_instance := BurgerScene.instantiate()
	#burger_instance.global_position = pos
	#burger_instance.gravity_scale = 0.6
	burger_instance.scale = Vector3.ZERO
	return burger_instance
	

#TODO: Add particles on scoring

func _on_score_reduce_after_timer_timeout() -> void:
	burger_points -= 1


func minimize_and_queue_free() -> void:
	$CollisionShape3D.set_deferred_thread_group("disabled", true)
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	Spring3D.animate_position(self, World.mouth.global_position)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.25)
	#Spring3D.fade_out_3d(self)
	await tween.finished
	queue_free()

func _process(delta: float) -> void:
	if World.charging_throw:
		animation_player.speed_scale = lerp(animation_player.speed_scale, 0.0, delta)
		burger.scale.y = lerpf(burger.scale.y, burger.scale.y*0.85, delta)
