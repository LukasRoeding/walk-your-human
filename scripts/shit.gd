extends RigidBody2D

# Optional: add some spin or behavior when it spawns
func _ready():
	# This sets a small initial rotation, so it starts rolling
	angular_velocity = 3.0  # tweak this to spin faster/slower

func _integrate_forces(state):
	# Check for collisions this physics frame
	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)
		if collider and collider is RigidBody2D and collider.scene_file_path == "res://scenes/shit.tscn":
			# Get collision normal and apply small force pushing away both bodies
			var collision_normal = state.get_contact_local_normal(i)
			
			# Apply force to self away from collider
			apply_force(collision_normal * 70, Vector2.ZERO)
			
			# Apply opposite force to the other body (if safe to do so)
			# To avoid recursion or strange physics, you might skip or do it carefully
			# collider.apply_force(-collision_normal * 50, Vector2.ZERO)
