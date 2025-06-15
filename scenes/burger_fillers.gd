class_name BurgerFiller extends Area3D

signal collected(points_value)

@export var speed: float = 3.0
@export var points_value: int = 2

@onready var init_pos := global_position

func _ready() -> void:
	%VisibleOnScreenNotifier3D.screen_exited.connect(queue_free)
	body_entered.connect(func(body:Node3D): if body.is_in_group("Burgers"): collect())

func  _process(delta: float) -> void:
	global_position.x += speed * delta

func collect():
	collected.emit(points_value)
	
	$CollisionShape3D.set_deferred("disabled", true)
	
	# "poof" animation
	var tween := create_tween().set_parallel()
	tween.tween_property(self, "scale", Vector3.ZERO, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	# TODO: could also play a sound here
	
	await tween.finished
	queue_free()

const BurgerFillerScene = preload("uid://b7dv6l03f70pc")

static func spawn_filler_at_pos(global_pos: Vector3, root_node: Node3D):
	var filler = BurgerFillerScene.instantiate()
	root_node.add_child(filler)
	filler.global_position = global_pos
	filler.collected.connect(func(points): 
		GS.burger_score += points
		#TODO: play collectionsound from soundmanager
		)
	
	#TODO: Make the movement similar to a sine wave
