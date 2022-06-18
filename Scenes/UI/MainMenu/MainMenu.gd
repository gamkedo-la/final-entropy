extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var credit_scroller = preload("res://Scenes/UI/EndScroller.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.main_menu = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGame_pressed():
	Global.main_menu = false	
	Global.goto_scene(Global.level_one)



func _on_Credits_pressed():
	Global.scroll_credits()
	pass # Replace with function body.
