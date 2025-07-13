extends Control

const OPTIONS_BUTTON = preload("res://scenes/options_button.tscn")
@onready var action_list: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

const input_actions = {
	"move_left": "Links",
	"move_right": "Rechts",
	"down": "Down",
	"jump": "Springen",
	"bark": "Bellen",
	"shit": "Kacki",
	"sleep": "Schlafen",
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_action_list()
	pass # Replace with function body.

func _create_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = OPTIONS_BUTTON.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_options_button_pressed.bind(button, action))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_options_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Drücke Taste zum wechseln ..."
		
func _input(event):
	if is_remapping:
		if (
			event is InputEventKey ||
			(event is InputEventMouseButton && event.is_pressed())
		):
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
				
			InputMap.action_erase_event(action_to_remap, event)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()
			
func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")


func _on_close_button_pressed() -> void:
	visible = false
