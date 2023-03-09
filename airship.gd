extends Node3D

var throttle = 0
var power = 0
@export var MAX_POWER = 1000
@export var THROTTLE_CHANGE_RATE = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_altitude() -> float:
	return $Deck/CSGBox3D.global_position.y


func set_throttle(fraction):
	throttle = fraction
	power = MAX_POWER * clamp(fraction, 0, 1)
	$Envelope.power_in = power


func change_throttle(fraction):
	set_throttle(throttle + fraction)


func get_input(delta):
	if Input.is_action_pressed("increase_power"):
		change_throttle(THROTTLE_CHANGE_RATE * delta)
	elif Input.is_action_pressed("decrease_power"):
		change_throttle(-THROTTLE_CHANGE_RATE * delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	get_input(delta)

	
	
