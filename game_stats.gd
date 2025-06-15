extends Node

static var tree

static var burgers_landed: int = 0

static var burger_score : int = 0

static var burgers_thrown_count : int = 0

static var highscore: int = 0:
	set(val): highscore = maxi(highscore, val)


func _ready() -> void:
	tree = get_tree()

func reset_for_new_round():
	GS.burger_score = 0
	GS.burgers_thrown_count = 0
	GS.burgers_landed = 0
