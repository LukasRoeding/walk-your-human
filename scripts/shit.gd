extends RigidBody2D

# Optional: add some spin or behavior when it spawns
func _ready():
	add_to_group("shit")
	# This sets a small initial rotation, so it starts rolling
	angular_velocity = 3.0  # tweak this to spin faster/slower
