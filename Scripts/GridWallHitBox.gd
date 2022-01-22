extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_HitBox_area_entered(area):
#	print_debug("Hitting GridMap Wall!")
	if area.is_in_group("bullet"):
		if area.bounces < 1:
			area.hit()
		else:
			area.velocity = area.velocity * -0.5
		area.bounces -= 1


func _on_WallHitBoxes_area_entered(area):
#	print_debug("Hitting GridMap Wall!")
	if area.is_in_group("bullet"):
		if area.bounces < 1:
			area.hit()
		else:
			area.velocity = area.velocity * -0.5
		area.bounces -= 1
