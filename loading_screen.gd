extends Control

signal loading_complete(res) #For future use cases in other stuff

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var loading_label: RichTextLabel = %LoadingLabel

var loaded_resources = {}
var is_loading = false

func load_scene(scene_path: String, transition_anim: String = "fadeToBlack"):
	if is_loading:
		return
		
	is_loading = true
	
	Transitions.transition(transition_anim)
	await Transitions.screen_covered

	visible = true
	
	var scene_resource = load(scene_path)
	
	# Fake progress (since it looks blank)
	for i in range(5):
		progress_bar.value = i * 20
		loading_label.text = "Loading... " + str(i * 20) + "%"
		await get_tree().process_frame
		await get_tree().create_timer(0.05).timeout
	
	get_tree().change_scene_to_packed(scene_resource)
	visible = false
	is_loading = false
	emit_signal("loading_complete", {"scene": scene_resource})

#For just-keep-chasing
func load_resources(resource_dict: Dictionary, transition_anim: String = "fadeToBlack", next_scene: String = ""):
	if is_loading:
		return
		
	is_loading = true
	loaded_resources.clear()
	
	Transitions.transition(transition_anim)
	await Transitions.screen_covered
	
	visible = true
	progress_bar.value = 0
	progress_bar.max_value = resource_dict.size()
	var count = 0
	for key in resource_dict:
		count += 1
		loading_label.text = "Loading " + key.replace("_", " ").capitalize()
		
		var resource = load(resource_dict[key])
		loaded_resources[key] = resource
		
		progress_bar.value = count
		await get_tree().process_frame
		await get_tree().create_timer(0.1).timeout  
	
	visible = false
	if next_scene != "":
		if loaded_resources.has(next_scene):
			get_tree().change_scene_to_packed(loaded_resources[next_scene])
		else:
			get_tree().change_scene_to_file(next_scene)
	
	is_loading = false
	emit_signal("loading_complete", loaded_resources)
