extends CanvasLayer
# Adapting from https://kidscancode.org/godot_recipes/3d/debug_overlay/

const LevelSelectButtonScn = preload("res://Scenes/Overlay/DebugLevelSelectButton.tscn")

var is_debug = false

onready var draw = $DebugDraw3D
onready var LevelSelecttorGrid = $LevelSelector/Grid
onready var PowerupSelectorGrid = $PowerupSelector/Grid

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
		
		
func _on_LevelController_level_loaded(rooms, room_loader, player_node):
	for button in LevelSelecttorGrid.get_children():
		button.queue_free()
		
	for button in PowerupSelectorGrid.get_children():
		button.player = player_node
	
	for room in rooms:
		var level_select_button = LevelSelectButtonScn.instance()		
		level_select_button.room_loader = room_loader
		level_select_button.text = room.room_name
		LevelSelecttorGrid.add_child(level_select_button)
