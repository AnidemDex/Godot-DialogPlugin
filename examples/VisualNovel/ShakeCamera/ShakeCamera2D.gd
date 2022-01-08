extends Camera2D
class_name ShakeCamera2D

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 50)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
export (NodePath) var target  # Assign the node this camera will follow.

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
onready var noise = OpenSimplexNoise.new()
var noise_y = 0

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func _process(delta):
	if target:
		global_position = get_node(target).global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
		
func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	# Using noise
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
	# Pure randomness
#	rotation = max_roll * amount * rand_range(-1, 1)
#	offset.x = max_offset.x * amount * rand_range(-1, 1)
#	offset.y = max_offset.y * amount * rand_range(-1, 1)
	
func add_trauma(amount):
	trauma += amount
	
