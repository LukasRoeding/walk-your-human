extends Node2D

@onready var input_settings: Control = $CanvasLayer/InputSettings

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("options"):
		input_settings.visible = not input_settings.visible
