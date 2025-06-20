extends Control

func _enter_tree() -> void:
	if (OS.get_name() == "Android"):
		get_tree().root.set_content_scale_factor(2)

func _ready() -> void:
	%PlayButton.grab_focus()
	
	%PlayButton.pressed.connect(_on_play_button_pressed)
	%SettingsButton.pressed.connect(Transitions.change_scene_with_transition.bind("uid://dp42fom7cc3n0"))
	%ExitButton.pressed.connect(_on_exit_button_pressed)
	%CreditsButton.pressed.connect(Transitions.change_scene_with_transition.bind("uid://bq0gelfcjnqvg"))

func _on_play_button_pressed() -> void:
	Transitions.change_scene_with_transition_packed(preload("uid://dabcmqvvcej4o"))
	self.hide()


func _on_exit_button_pressed() -> void:
	# gently shutdown the game
	Transitions.transition()
	await Transitions.transition_player.animation_finished
	get_tree().quit()
