extends Area2D
@onready var score: Label = $"../../CanvasLayer/Score"


func _on_body_entered(body: Node2D) -> void:
	print("+1 coin")
	score.add_score()
	queue_free()
	pass # Replace with function body.
