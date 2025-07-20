extends CanvasLayer

const BARK = preload("res://materials/bark.tres")

var materials = [BARK]

func _ready() -> void:
	for material in materials:
		var particles_instance = GPUParticles2D.new()
		particles_instance.process_material = material
		particles_instance.one_shot = true
		particles_instance.modulate = Color(1,1,1,0)
		particles_instance.emitting = true
		self.add_child(particles_instance)
		
