extends Button

var room_loader


func _on_DebugLevelSelectButton_mouse_exited():
	release_focus()


func _on_DebugLevelSelectButton_pressed():	
	if room_loader:		
		room_loader.call_deferred("call_func", text)
