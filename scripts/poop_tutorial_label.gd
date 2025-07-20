extends Label

var current_poop_key = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var events = InputMap.action_get_events("shit")
	if events.size() > 0:
		_change_label(events)

func _process(delta) -> void:
	var events = InputMap.action_get_events("shit")
	if events.size() > 0 && current_poop_key !=  events[0].as_text():
		_change_label(events)

func _change_label(events):
	var key = events[0].as_text().trim_suffix(" (Physical)")
	text = "Drück " + key + " zum kacki machen\nund bau dir eine Brücke über die Lava"
	current_poop_key =  events[0].as_text()
