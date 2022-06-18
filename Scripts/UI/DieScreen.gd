extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Retry_pressed():
	Global.main_menu = false	
	Global.goto_scene(Global.level_one)
	pass # Replace with function body.


func _on_Main_Menu_pressed():
	Global.main_menu = true
	Global.goto_scene(Global.main_menu_scn)
	pass # Replace with function body.


func _on_Quit_pressed():
	Global.emit_signal("exit_game")
	pass # Replace with function body.
