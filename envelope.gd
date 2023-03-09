extends RigidBody3D

@export var sat = 23  	# Static air temperature
var eat = sat			# Envelope air temperature
var power_in = 0		# Input power

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_temperature() -> float:
	return eat


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Heating
	# Q = m * C * delta_temp
	# delta_temp = Q / (m * C)
	# Grossly simplified
	eat += power_in * delta
	
	# Conductive heat loss
	# q = U A dT
	eat -= 0.2 * (eat - sat) * delta
	eat = clamp(eat, sat, 1000)
	
	# Lift
	# This should be bouyancy based on SAT, EAT, mass, and volume
	var volume = 4 / 3 * PI * ($Sphere.radius ** 2)
	var envelope_mass = volume * air_density(eat)
	var displaced_mass = volume * air_density(sat)
	var lift = displaced_mass - envelope_mass
	
	# Transform gravity direction to local space
	var global_to_local: Transform3D = global_transform.affine_inverse()
	global_to_local.origin = Vector3.ZERO
	var lift_dir = global_to_local * Vector3.UP

	apply_force(lift_dir * lift)


func air_density(temperature):
	# https://en.wikipedia.org/wiki/Density_of_air#cite_note-SInote01-13
	const R = 8.314 	# J/K-mol, gas constant
	const M = 0.0290 	# kg/mol, molar mass of dry air
	var p = 101325		# Pa, absolute pressure (1 atm)
	var R_specific = R / M
	return p / (R_specific * temperature)
	
