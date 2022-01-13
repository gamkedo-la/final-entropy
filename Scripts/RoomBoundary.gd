extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_area_exited(area):
	if area.is_in_group("bullet"):
		if area.bounces < 1:
			area.hit()
		else:
			area.velocity = area.velocity * -0.5
		area.bounces -= 1
