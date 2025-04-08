class_name GameOverStatsScreen extends Control

static var highscore: int = 0:
	set(val): highscore = max(highscore, val)


func _ready() -> void:
	%CurrentScoreLabel.text = tr("Current score: ") + str(World.burger_score)
	%BurgersThrownCountLabel.text = tr("Burgers Thrown Count: ") + str(World.burgers_thrown_count)
	%BurgersLandedCount.text = tr("Burgers Landed: ") + str(World.burgers_landed)
	%HighscoreLabel.text = tr("Highscore: ") + str(highscore)
	World.burger_score = 0
	World.burgers_thrown_count = 0
	World.burgers_landed = 0

func _on_button_pressed() -> void:
	Transitions.change_scene_with_transition("uid://dabcmqvvcej4o")


func _on_menu_button_pressed() -> void:
	Transitions.change_scene_with_transition("uid://r10he81gcxd1")
