extends Node2D

@onready var line: Line2D = $Line
@onready var human: RigidBody2D = $Human
@onready var rope_marker: Marker2D = $Player/RopeMarker

func _process(delta):
	line.clear_points()
	line.add_point(to_local(rope_marker.global_position)) # This will usually be Vector2.ZERO
	line.add_point(to_local(human.global_position))   
