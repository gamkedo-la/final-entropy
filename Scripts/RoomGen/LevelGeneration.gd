extends Node

export (Resource) var room_container

var level_length = 0
var main_path = []

func _ready():
	level_length = (randi() % (room_container.max_rooms - room_container.min_rooms)) + room_container.min_rooms
	
	# Generate main path
	for i in level_length:
		var new_room = room_container.common_rooms[randi() % room_container.common_rooms.size()].instance()
		add_child(new_room)
		main_path.push_back((new_room))
		new_room.room_name = "M" + str(i)
		new_room.translation = Vector3(0, 0, room_container.vertical_seperation * 1)
		
		# Set Return rooms
		if i != 0:
			new_room.return_room = "M" + str(i-1)
			
		for j in new_room.room_portals:
			new_room.connected_rooms.push_back("")
		
		# Link to next room
		if i+1 != level_length:
			var portal_index = randi() % new_room.room_portals.size()
			new_room.connected_rooms[portal_index] = "M" + str((i+1))
		
	# Add Boss
			
	# Add special branches
