extends Node3D


var prev_error = 0
var error_i = 0
var pid_temperature
var pid_altitude

# Called when the node enters the scene tree for the first time.
func _ready():
	pid_temperature = PIDController.new(0.005, 5.0, 0.0)
	pid_altitude = PIDController.new(0.01, 60., 10.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var balloon = $Airship
	var envelope = balloon.get_node("Envelope")
	var alt = balloon.get_altitude()
	var wow = alt < 0.5
	var throttle = 0
	
	if wow:
		throttle = pid_temperature.step(50.0, envelope.get_temperature(), delta)
	else:
		throttle = pid_altitude.step(10., alt, delta)
	
	throttle = clamp(throttle, 0, 1)	
	balloon.set_throttle(throttle)
	
	print(envelope.get_temperature(), " ", throttle, " ", alt)
	
	$Player.get_node("Pivot/Camera3D").look_at(balloon.global_position)


class PIDController:
	var prev_error: float
	var error_i: float
	var kp: float
	var ti_inv: float
	var td: float

	func _init(kp_, ti, td_):
		prev_error = 0
		error_i = 0
		kp = kp_
		ti_inv = 1.0 / ti
		td = td_
	
	func step(setpoint, process, delta):
		var error = setpoint - process
		var error_d = (error - prev_error) / delta
		error_i += error * delta
		var control = kp * (error + ti_inv * error_i + td * error_d)
		prev_error = error
		return control

