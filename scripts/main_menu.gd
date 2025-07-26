extends Control

@onready var input_settings: Control = $InputSettings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	var new_scene = load("res://scenes/spiel.tscn") as PackedScene
	get_tree().change_scene_to_packed(new_scene)
	pass # Replace with function body.


func _on_options_pressed() -> void:
	input_settings.visible = true
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_credits_pressed() -> void:
	print("credits pressed")
	pass # Replace with function body.
