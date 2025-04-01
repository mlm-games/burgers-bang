class_name GameOverStatsScreen extends Control

static var highscore: int = 0

func _ready() -> void:
	%BurgersThrownCountLabel.text = tr("Burgers Thrown Count: ") + str(World.burgers_thrown_count)
	%BurgersLandedCount.text = tr("Burgers Landed: ") + str(World.burgers_landed)
	%HighscoreLabel.text = tr("Highscore: ") + str(highscore)

func _on_button_pressed() -> void:
	Transitions.change_scene_with_transition("uid://dabcmqvvcej4o")
