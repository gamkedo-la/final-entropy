extends CanvasLayer

onready var Menu = $GUIOverlayMenu
onready var Muted = $GUIOverlayIndicators/Muted


func _ready():
	toggle_muted()


func toggle_menu(is_visible = true):
	Menu.toggle(is_visible)


func toggle_muted(is_muted = false):
	Muted.visible = is_muted


func _on_GUIOverlayMenu_menu_toggled(is_visible):
	Menu.visible = is_visible
