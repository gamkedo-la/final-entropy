extends CanvasLayer

onready var Muted = $Indicators/Muted

func _ready():
	toggle_muted()


func toggle_muted(is_muted = false):
	Muted.visible = is_muted
