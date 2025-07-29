extends CharacterBody2D


const SPEED = 160.0
const JUMP_VELOCITY = -320.0
const COYOTE_TIME = 0.12  # in seconds
const SNIFF_PARTICLES_SCENE = preload("res://scenes/sniff_particles.tscn")

var coyote_time_remaining = 0.0

var level_stopped = false

@onready var shit_timer: Timer = $PoopTimer
@onready var sniff_timer: Timer = $SniffTimer
@onready var bark_timer: Timer = $BarkTimer
@onready var walk_timer: Timer = $WalkTimer
@onready var sleep_timer: Timer = $SleepTimer

@onready var bark: AudioStreamPlayer2D = $Bark
@onready var poop: AudioStreamPlayer2D = $Poop
@onready var jump: AudioStreamPlayer2D = $Jump
@onready var sniff: AudioStreamPlayer2D = $Sniff
@onready var walk: AudioStreamPlayer2D = $Walk
@onready var sleep: AudioStreamPlayer2D = $Sleep

@onready var pin_joint_2d: PinJoint2D = $"../PinJoint2D"
@onready var human: RigidBody2D = $"../Human"

@onready var sniff_particles: GPUParticles2D = $SniffParticles

@onready var score: Label = $"../../CanvasLayer/Score"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var shit = preload("res://scenes/shit.tscn")
const BARK_SCENE = preload("res://scenes/bark.tscn")

func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_time_remaining = COYOTE_TIME
	else:
		coyote_time_remaining -= delta
	if(level_stopped):
		if(sleep_timer.is_stopped()):
			sleep_timer.start()
			sleep.play()
		else:
			pass
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and coyote_time_remaining > 0.0 and timers_stopped():
		velocity.y = JUMP_VELOCITY

		jump.play()

	if Input.is_action_just_pressed("bark") and is_on_floor() and timers_stopped():
		bark_timer.start()
		bark.play()
		
		var fired_bark = BARK_SCENE.instantiate()
		var direction = -1
		if animated_sprite_2d.flip_h:
			direction = 1
		fired_bark.dir = direction
		var offset = Vector2(-40 * direction, -10)
		fired_bark.pos = global_position + offset
		fired_bark.global_position = global_position + offset
		get_parent().add_child(fired_bark)

	if Input.is_action_just_pressed("sniff") and is_on_floor() and timers_stopped():
		sniff_timer.start()
		sniff.play()
		var closest_target = get_closest_target()
		if closest_target:
			emit_trail_to(closest_target.global_position)

	if Input.is_action_just_pressed("shit") and timers_stopped():
		shit_timer.start()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0:
		# Facing right
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		# Facing left
		animated_sprite_2d.flip_h = true

	if not shit_timer.is_stopped():
		animated_sprite_2d.play("shit")
	elif is_on_floor():
		if not sleep_timer.is_stopped():
			animated_sprite_2d.play("sleep")
		elif not sniff_timer.is_stopped():
			animated_sprite_2d.play("sniff")
		elif not bark_timer.is_stopped():
			animated_sprite_2d.play("bark")
		elif Input.is_action_pressed("down"):
			animated_sprite_2d.play("down")
		elif direction == 0:
			animated_sprite_2d.play("idle")
		else:
			if(walk_timer.is_stopped()):
				walk_timer.start()
				walk.play()
			animated_sprite_2d.play("run")
	elif bark_timer.is_stopped():
		animated_sprite_2d.play("jump")

	if direction and can_move():
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	push_rigid_bodies()

func _ready():
	add_to_group("dog")
	shit_timer.timeout.connect(_on_shit_timeout)
	
func _on_shit_timeout():
	if(score.shit > 0):
		poop.play()
		var new_node = shit.instantiate()
		var sprite = new_node.get_node("AnimatedSprite2D")
		var frame_texture = sprite.sprite_frames.get_frame_texture(sprite.animation, 0)
		var height = frame_texture.get_height()
		var direction = -1
		if animated_sprite_2d.flip_h:
			direction = 1
		new_node.position = global_position - Vector2(-30 * direction, height * 0.5)
		new_node.z_index = 1
		new_node.name = "shit"
		get_tree().current_scene.add_child(new_node)
		score.remove_shit(1)
	
func push_rigid_bodies():
	# Determine direction based on sprite flip (flip_h = facing left)
	var direction = -1 if animated_sprite_2d.flip_h else 1

	var force = Vector2(direction * 75, 0)  # Push left or right

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		if body and body.scene_file_path == "res://scenes/shit.tscn":
			var normal = collision.get_normal()
			# If normal is mostly upwards, player is on top, so don't push
			if normal.dot(Vector2.UP) > 0.3:
				continue

			body.apply_force(force, Vector2.ZERO)
			
func timers_stopped():
	return shit_timer.is_stopped() and sniff_timer.is_stopped() and bark_timer.is_stopped() and sleep_timer.is_stopped()

func can_move():
	return timers_stopped() and not Input.is_action_pressed("down")
	
func level_finished():
	level_stopped = true

func get_closest_target() -> Node2D:
	var closest_node: Node2D = null
	var closest_dist := INF
	var my_pos = global_position

	for node in get_tree().get_nodes_in_group("target"):
		if node is Node2D:
			var dist = my_pos.distance_to(node.global_position)
			if dist < closest_dist:
				closest_dist = dist
				closest_node = node

	return closest_node


func emit_trail_to(target_pos: Vector2):
	# Instance a new GPUParticles2D node from a separate scene (with your configured particle effect)
	var new_trail = SNIFF_PARTICLES_SCENE.instantiate()
	
	# Start position and add to the scene
	new_trail.global_position = target_pos
	get_tree().current_scene.add_child(new_trail)

	# Start emitting (assuming one_shot = true, it auto emits and stops)
	new_trail.restart()

	# Tween movement towards target
	var duration = 3.0
	var tween := create_tween()
	tween.tween_property(new_trail, "global_position", global_position, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Wait for tween to finish
	await tween.finished

	# Wait 1 second after the tween
	await get_tree().create_timer(1.0).timeout

	# Then free the node
	new_trail.queue_free()
