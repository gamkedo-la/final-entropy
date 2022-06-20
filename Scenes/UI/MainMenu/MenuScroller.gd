extends Control


onready var scroller: MarginContainer = $Scroller

var paused: bool = false
var speed: int = 25

func _ready() -> void:
	scroller.rect_position.y = 1000
	pass

func _process(delta: float) -> void:
	if !paused:
		scroller.rect_position.y -= delta * speed







func _on_Slower_pressed():
	if speed - 10 >= 0:
		speed -= 10
	

func _on_Faster_pressed():
	speed += 10

