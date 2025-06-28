extends Label

var score = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var fps = Engine.get_frames_per_second()   
	text = 'FPS: ' + str(int(fps)) + '\nTreats: ' + str(score)
	pass

func add_score():
	score = score + 1
