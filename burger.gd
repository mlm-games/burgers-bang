class_name Burger extends MeshInstance3D

var charging_throw: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
	
			print("Recognised")
			#global_position =  
		
