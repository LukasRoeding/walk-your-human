extends CharacterBody2D

var pos:Vector2
var rota:float
var dir:float
var speed = 50
@onready var death_timer: Timer = $DeathTimer

func _ready():
	add_to_group("enemy_killer")
	add_to_group("projectile")
	global_position=pos
	death_timer.start()

func _physics_process(delta: float) -> void:
	velocity = Vector2(speed * dir * -1, 0)

	move_and_slide()

func _on_death_timer_timeout() -> void:
	queue_free()
