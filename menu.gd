extends Control

func _ready() -> void:
	%PlayButton.grab_focus()
	
	%PlayButton.pressed.connect(_on_play_button_pressed)
	%SettingsButton.pressed.connect(_on_settings_button_pressed)
	%ExitButton.pressed.connect(_on_exit_button_pressed)

func _on_play_button_pressed() -> void:
	LoadingScreen.load_scene("uid://dabcmqvvcej4o")
	self.hide()


func _on_exit_button_pressed() -> void:
	# gently shutdown the game
	Transitions.transition()
	await Transitions.transition_player.animation_finished
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	Transitions.change_scene_with_transition("uid://dp42fom7cc3n0")
