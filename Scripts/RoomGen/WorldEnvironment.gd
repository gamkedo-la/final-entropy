tool
extends WorldEnvironment


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.editor_hint:
		if get_parent() is RoomController:
			call_deferred("queue_free")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
