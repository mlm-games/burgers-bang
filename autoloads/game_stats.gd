extends Node

static var tree

static var burgers_landed: int = 0

static var burger_score : int = 0

static var burgers_thrown_count : int = 0

static var highscore: int = 0:
	set(val): highscore = maxi(highscore, val)


func _ready() -> void:
	tree = get_tree()
