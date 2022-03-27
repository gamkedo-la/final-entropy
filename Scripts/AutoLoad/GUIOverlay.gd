extends CanvasLayer

onready var Menu = $GUIOverlayMenu
onready var Muted = $GUIOverlayIndicators/Muted


func _ready():
	Menu.hide()
	toggle_muted()


func toggle_menu(is_visible = true):
	Menu.visible = is_visible


func toggle_muted(is_muted = false):
	Muted.visible = is_muted
