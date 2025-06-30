extends Sprite2D

@onready var sprite_2d: Sprite2D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite_2d.material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
