extends Label

@onready var player: CharacterBody2D = $"../../player"
@onready var background_music: AudioStreamPlayer2D = $"../../AudioStreamPlayer2D"

const MAX_SCORE = 5

var score = 0
var shit = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var fps = Engine.get_frames_per_second()   
	text = '      x ' + str(shit) + '\n      x ' + str(score)
	pass

func add_score():
	score = score + 1
	add_shit(1)
	if(score == MAX_SCORE):
		player.level_finished()
		background_music.stop()
	
func add_shit(amount):
	shit = shit + amount
	
func remove_shit(amount):
	shit = shit - amount
