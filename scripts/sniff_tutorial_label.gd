extends Label

var current_sniff_key = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var events = InputMap.action_get_events("sniff")
	if events.size() > 0:
		_change_label(events)

func _process(delta) -> void:
	var events = InputMap.action_get_events("sniff")
	if events.size() > 0 && current_sniff_key !=  events[0].as_text():
		_change_label(events)

func _change_label(events):
	var key = events[0].as_text().trim_suffix(" (Physical)")
	text = "Drück " + key + ", um deine Spürnase einzusetzen\nund das nächste Leckerchen zu erschnüffeln"
	current_sniff_key =  events[0].as_text()
