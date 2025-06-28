extends Area2D

# --- Constants ---
const SPEED := 40

# --- Variables ---
var direction := 1

# --- Node References ---
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right_horizontal: RayCast2D = $RayCastRightHorizontal
@onready var ray_cast_left_horizontal: RayCast2D = $RayCastLeftHorizontal
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $Killzone/CollisionShape2D

func _ready() -> void:
	add_to_group("enemy")
	death_timer.connect("timeout", Callable(self, "_on_DeathTimer_timeout"))
# --- Main Loop ---
func _process(delta: float) -> void:
	# Check if stuck between two opposing obstacles
	if ray_cast_right_horizontal.is_colliding() and ray_cast_left_horizontal.is_colliding():
		#die()
		return

	# Check if falling off an edge while blocked on the opposite side
	var edge_right := not ray_cast_right.is_colliding()
	var edge_left := not ray_cast_left.is_colliding()
	var blocked_right := ray_cast_right_horizontal.is_colliding()
	var blocked_left := ray_cast_left_horizontal.is_colliding()

	if (edge_right and blocked_left) or (edge_left and blocked_right):
		#die()
		return

	# Turn around at edges
	if edge_right and direction == 1:
		turn_left()
	elif edge_left and direction == -1:
		turn_right()

	# Avoid walls or obstacles (but ignore the player)
	if blocked_right:
		var collider := ray_cast_right_horizontal.get_collider()
		if collider.name != "player":
			turn_left()

	elif blocked_left:
		var collider := ray_cast_left_horizontal.get_collider()
		if collider.name != "player":
			turn_right()

	# Move in current direction
	if death_timer.is_stopped():
		position.x += direction * SPEED * delta

# --- Helper Functions ---
func turn_left() -> void:
	direction = -1
	animated_sprite.flip_h = true

func turn_right() -> void:
	direction = 1
	animated_sprite.flip_h = false

func die():
	if death_timer.is_stopped():
		death_timer.start()
		collision_shape_2d.queue_free()
		animated_sprite.play("die")
		death_timer.start()

func _on_DeathTimer_timeout():
	queue_free()
	



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("shit") && body.has_node("CollisionShape2D"):
		body.get_node("CollisionShape2D").queue_free()
		die()
