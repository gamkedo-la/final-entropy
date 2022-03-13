extends HSlider

const reset_label_text = "Right-Click to Reset"
const slider_label_text = "Game Speed Slider"


func _ready():	
	$ResetLabel.text = slider_label_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DebugSpeedSlider_value_changed(value:float):
	Engine.time_scale = value


func _on_DebugSpeedSlider_mouse_entered():	
	$ResetLabel.text = reset_label_text
	tick_count = 21
	ticks_on_borders = true


func _on_DebugSpeedSlider_mouse_exited():
	release_focus()	
	tick_count = 0
	ticks_on_borders = false
	$ResetLabel.text = slider_label_text


func _on_DebugSpeedSlider_gui_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			Engine.time_scale = 1.0
			value = Engine.time_scale
