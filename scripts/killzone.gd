extends Area2D

@onready var timer: Timer = $Timer
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var pin_joint_2d: PinJoint2D = $PinJoint2D

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body.is_in_group("dog") or body.is_in_group("human"):
		if body.has_node("CollisionShape2D"):
			body.get_node("CollisionShape2D").queue_free()
			
		free_joint_group()
		
		Engine.time_scale = 0.25
		death_sound.play()
		timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func free_joint_group():
	var joint_group = get_tree().get_nodes_in_group("joint")
	for node in joint_group:
		node.queue_free()
