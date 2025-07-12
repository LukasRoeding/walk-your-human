extends AcceptDialog

func _ready():
	await get_tree().process_frame
	popup_centered()
