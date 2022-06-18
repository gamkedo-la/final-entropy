extends Control

onready var win_msg: RichTextLabel = $Scroller/Content/ThankYou/WinMsg
onready var scroller: MarginContainer = $Scroller

var paused: bool = false
var speed: int = 25

func _ready() -> void:
	if Global.game_over:
		scroller.rect_position.y = 1100
		Global.pause_game(true)
		Global.main_menu = true
	else:
		win_msg.visible = false
		scroller.rect_position.y = 900

func _process(delta: float) -> void:
	if !paused:
		scroller.rect_position.y -= delta * speed




func _on_Pause_pressed():
	paused = !paused

func _on_End_pressed():
	Global.pause_game(false)
	call_deferred("queue_free")


func _on_Slower_pressed():
	if speed - 10 >= 0:
		speed -= 10
	

func _on_Faster_pressed():
	speed += 10

