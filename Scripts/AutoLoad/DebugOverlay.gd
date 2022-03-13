extends CanvasLayer
# Adapting from https://kidscancode.org/godot_recipes/3d/debug_overlay/

var is_debug = false

onready var draw = $DebugDraw3D

func _ready():
	if not InputMap.has_action("toggle_debug"):
		InputMap.add_action("toggle_debug")
		var ev = InputEventKey.new()
		ev.scancode = KEY_BACKSLASH
		InputMap.action_add_event("toggle_debug", ev)
	for n in get_children():
		n.visible = false

func _input(event):
	if event.is_action_pressed("toggle_debug"):
		for n in get_children():
			n.visible = not n.visible
			is_debug = n.visible
		
		print("Debug Mode: " + str(is_debug))
		
		
