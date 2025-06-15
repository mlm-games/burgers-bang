class_name GameOverStatsScreen extends Control

func _ready() -> void:
	%CurrentScoreLabel.text = tr("Current score: ") + str(GS.burger_score)
	%BurgersThrownCountLabel.text = tr("Burgers Thrown Count: ") + str(GS.burgers_thrown_count)
	%BurgersLandedCount.text = tr("Burgers Landed: ") + str(GS.burgers_landed)
	%HighscoreLabel.text = tr("Highscore: ") + str(GS.highscore)
	GS.burger_score = 0
	GS.burgers_thrown_count = 0
	GS.burgers_landed = 0

func _on_button_pressed() -> void:
	Transitions.change_scene_with_transition("uid://dabcmqvvcej4o")


func _on_menu_button_pressed() -> void:
	Transitions.change_scene_with_transition("uid://r10he81gcxd1")
