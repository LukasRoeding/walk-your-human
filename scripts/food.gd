extends Area2D

@onready var score: Label = $"../../CanvasLayer/Score"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

func _on_body_entered(body: Node2D) -> void:
	score.add_score() 
	audio_stream_player_2d.play()
	queue_free()
