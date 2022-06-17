extends Spatial
class_name RoomPortal

signal traverse

enum PortalType {
	FORWARD,
	RETURN,
	LATERAL
}

export (PackedScene) var uparrow = null
export (PackedScene) var downarrow = null
onready var arrow_pos = $ArrowPos

var initialized: bool = false
var current_room: String = ""
var connected_room: String = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func initialize(arrowtype: int) -> void:
	if arrowtype == PortalType.FORWARD:
		var newarrow = uparrow.instance()
		arrow_pos.add_child(newarrow)
	elif arrowtype == PortalType.RETURN:
		var newarrow = downarrow.instance()
		arrow_pos.add_child(newarrow)
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#
#	pass


func _on_Area_body_entered(body):
	if body is Player:
		print_debug("Player in portal")
		emit_signal("traverse", connected_room, current_room)

