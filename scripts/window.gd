extends Window

@onready var accept_dialog: AcceptDialog = $AcceptDialog

func _ready():
	accept_dialog.dialog_text = "Do you want to proceed?"
	accept_dialog.popup_centered()
