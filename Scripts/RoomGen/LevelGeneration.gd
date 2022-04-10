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
		new_room.room_name = "M" + str(i)
		new_room.name = new_room.room_name
		new_room.translation = Vector3(0, 0, room_container.vertical_seperation * i)
		
		# Set Return room
		if i != 0:
			new_room.return_room = "M" + str(i-1)
			
		# Prep room links
		for j in new_room.room_portals:
			new_room.connected_rooms.push_back("")
		
		# Link to next room
		if i+1 != level_length:
			var portal_index = randi() % new_room.room_portals.size()
			new_room.connected_rooms[portal_index] = "M" + str((i+1))
		
		main_path.push_back((new_room))
		
	# Add Boss
	var boss_room = room_container.boss_rooms[randi() % room_container.boss_rooms.size()].instance()
	add_child(boss_room)
	boss_room.room_name = "B0"
	boss_room.name = boss_room.room_name
	boss_room.translation = Vector3(0, 0, room_container.vertical_seperation * main_path.size())
	
	# Set Return room
	boss_room.return_room = "M" + str(main_path.size()-1)
	
	# Connect last room
	var last_room = main_path[main_path.size()-1]
	var portal_index = randi() % last_room.room_portals.size()
	last_room.connected_rooms[portal_index] = "B0"
	
	main_path.push_back((boss_room))
	
	
	
			
	# Add special branches
