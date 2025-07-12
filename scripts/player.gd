extends CharacterBody2D


const SPEED = 160.0
const JUMP_VELOCITY = -320.0

var level_stopped = false

@onready var shit_timer: Timer = $Timer
@onready var sleep_timer: Timer = $Timer2
@onready var bark_timer: Timer = $Timer3
@onready var walk_timer: Timer = $WalkTimer

@onready var bark: AudioStreamPlayer2D = $bark
@onready var poop: AudioStreamPlayer2D = $poop
@onready var jump: AudioStreamPlayer2D = $jump
@onready var sleep: AudioStreamPlayer2D = $sleep
@onready var walk: AudioStreamPlayer2D = $Walk

@onready var score: Label = $"../CanvasLayer/Score"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var shit = preload("res://scenes/shit.tscn")

func _physics_process(delta: float) -> void:
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
	if Input.is_action_just_pressed("jump") and is_on_floor() and timers_stopped():
		velocity.y = JUMP_VELOCITY
		jump.play()

	if Input.is_action_just_pressed("bark") and is_on_floor() and timers_stopped():
		bark_timer.start()
		bark.play()

	if Input.is_action_just_pressed("sleep") and is_on_floor() and timers_stopped():
		sleep_timer.start()
		sleep.play()

	if Input.is_action_just_pressed("shit") and timers_stopped():
		shit_timer.start()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	if not shit_timer.is_stopped():
		animated_sprite_2d.play("shit")
	elif is_on_floor():
		if not sleep_timer.is_stopped():
			animated_sprite_2d.play("sleep")
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
	return shit_timer.is_stopped() and sleep_timer.is_stopped() and bark_timer.is_stopped()

func can_move():
	return timers_stopped() and not Input.is_action_pressed("down")
	
func level_finished():
	level_stopped = true
