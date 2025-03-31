##Spring3D provides a physics-based way to animate properties with natural-looking motion. Here's how to use it:

#Basic Usage
#Simple Animation
#
## Animate a cube's position
#var spring = Spring3D.new({
	#"initial_value": $Cube.position,
	#"target_value": Vector3(0, 5, 0),
	#"bound_node": $Cube,
	#"bound_property": "position",
	#"parent_node": self
#})
#Using Utility Methods
#
## Fade out a 3D object
#var spring = Spring3D.fade_out_3d($Sphere, {
	#"spring_stiffness": 120.0,  # More responsive spring
	#"destroy_on_complete": true  # Auto-cleanup when done
#})
#
## Move an object
#var spring = Spring3D.animate_position($Player, Vector3(10, 0, 5), {
	#"start_delay": 1.0  # Start after 1 second
#})
#Responding to Completion
#
#var spring = Spring3D.new({
	#"initial_value": Vector3.ZERO,
	#"target_value": Vector3(0, 10, 0),
	#"bound_node": $Character,
	#"bound_property": "position",
	#"parent_node": self
#})
#
#spring.animation_completed.connect(func(): print("Animation finished!"))
#Advanced Features
#Changing Target Mid-Animation
#
## Create spring
#var position_spring = Spring3D.new({
	#"initial_value": $Enemy.position,
	#"target_value": Vector3(5, 0, 5),
	#"bound_node": $Enemy,
	#"bound_property": "position",
	#"parent_node": self
#})
#
## Later, change direction
#position_spring.set_target_value(Vector3(-10, 0, 2))
#Adding Impulses
#
## Apply a sudden force to the spring
#position_spring.apply_impulse(Vector3(0, 5, 0))
#Skip Animation
#
## Immediately jump to the final value
#rotation_spring.jump_to_value(Vector3(0, PI, 0))
#Another example
#
#var shared_spring = Spring3D.new({
	#"initial_value": $SharedObject.scale,
	#"target_value": Vector3(2, 2, 2),
	#"bound_node": $SharedObject,
	#"bound_property": "scale",
	#"parent_node": self
#})

#TODO: Add the above stuff as documentation

class_name Spring3D extends Node

const SIMULATION_RATE: int = 60
const REST_TOLERANCE: float = 0.01

##initial_value: Starting value (Vector3, Vector2, float)
var initial_value: Variant = Vector3.ZERO

var current_value: Variant = Vector3.ZERO

##target_value: Target value to animate toward
var target_value: Variant = Vector3.ONE

## spring_stiffness: Higher values create tighter springs (default: 170)
var spring_stiffness: float = 170.0

##spring_damping: Higher values reduce oscillation (default: 25)
var spring_damping: float = 25.0

##bound_node: Node to animate
var bound_node: Node = null

##bound_property: Property path to animate
var bound_property: NodePath

##destroy_on_complete: Whether to free the spring after completion
var destroy_on_complete: bool = false

var current_velocity: Variant = Vector3.ZERO
var time_elapsed: float = 0.0
var simulation_frame: int = 0
var animation_completed: bool = false

signal spring_animation_completed

func _init(config: Dictionary = {}):
	initial_value = config.get("initial_value", initial_value)
	target_value = config.get("target_value", target_value)
	spring_stiffness = config.get("spring_stiffness", spring_stiffness)
	spring_damping = config.get("spring_damping", spring_damping)
	time_elapsed = -config.get("start_delay", 0.0)

	bound_node = config.get("bound_node", bound_node)
	bound_property = NodePath(config.get("bound_property", bound_property))

	destroy_on_complete = config.get("destroy_on_complete", destroy_on_complete)
	
	#start_delay: Seconds to wait before starting (negative value)
	#initial_velocity: Starting velocity (scaled by SIMULATION_RATE)
	var initial_velocity = config.get("initial_velocity", get_zero_value(initial_value))
	current_velocity = initial_velocity * SIMULATION_RATE
	
	update_value(initial_value)
	
	if config.has("parent_node"):
		config["parent_node"].add_child(self, true)

func _process(delta: float):
	time_elapsed += delta

	if time_elapsed > 0.0:
		var previous_frame = simulation_frame
		simulation_frame = int(floor(time_elapsed * SIMULATION_RATE))
		
		if not animation_completed:
			for _i in range(simulation_frame - previous_frame):
				simulate_step()

func simulate_step():
	var displacement = target_value - current_value
	
	if is_at_rest(displacement) and is_at_rest(current_velocity):
		jump_to_value(target_value)
	else:
		var acceleration = spring_stiffness * displacement - current_velocity * spring_damping
		current_velocity += acceleration / SIMULATION_RATE
		update_value(current_value + current_velocity / SIMULATION_RATE)

func set_target_value(new_target: Variant):
	
	target_value = new_target
	set_completion_state(false)

func apply_impulse(impulse: Variant):
	
	current_velocity += impulse * SIMULATION_RATE
	set_completion_state(false)

func jump_to_value(new_value: Variant):
	
	update_value(new_value)
	target_value = new_value
	current_velocity = get_zero_value(current_velocity)
	
	if not animation_completed:
		set_completion_state(true)

func get_current_value() -> Variant:
	return current_value

func update_value(new_value: Variant):
	current_value = new_value
	update_bound_node()

func set_completion_state(completed: bool):
	animation_completed = completed
	
	if animation_completed:
		spring_animation_completed.emit()
		if destroy_on_complete:
			queue_free()

func update_bound_node():
	if not (is_instance_valid(bound_node) and bound_property):
		return

	bound_node.set_indexed(bound_property, current_value)

func is_at_rest(value: Variant) -> bool:
	if value is Vector3:
		return abs(value.x) < REST_TOLERANCE and abs(value.y) < REST_TOLERANCE and abs(value.z) < REST_TOLERANCE
	elif value is Vector2:
		return abs(value.x) < REST_TOLERANCE and abs(value.y) < REST_TOLERANCE
	
	return abs(value) < REST_TOLERANCE

func get_zero_value(value_type: Variant) -> Variant:
	if value_type is Vector3:
		return Vector3.ZERO
	elif value_type is Vector2:
		return Vector2.ZERO
	
	return 0.0

# Utility functions for common animations
static func fade_out_3d(node: Node3D, override_props: Dictionary = {}):
	var config = {
		"initial_value": 1.0,
		"target_value": 0.0,
		"bound_property": "transparency",
		"bound_node": node,
		"spring_stiffness": 100.0,
		"spring_damping": 10.0
	}

	config.merge(override_props, true)
	
	var spring = Spring3D.new(config)
	
	if not config.has("parent_node"):
		node.get_parent().add_child(spring, true)
	
	return spring

static func animate_position(node: Node3D, target_pos: Vector3, override_props: Dictionary = {}):
	var config = {
		"initial_value": node.position,
		"target_value": target_pos,
		"bound_property": "position",
		"bound_node": node,
		"spring_stiffness": 80.0,
		"spring_damping": 10.0
	}
	
	config.merge(override_props, true)
	
	var spring = Spring3D.new(config)
	
	if not config.has("parent_node"):
		node.get_parent().add_child(spring, true)
	
	return spring
