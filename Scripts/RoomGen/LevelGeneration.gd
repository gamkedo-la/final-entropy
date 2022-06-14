extends Node

export (Resource) var room_container

var level_length = 0
var main_path = []

func _ready():
	level_length = (randi() % (room_container.max_rooms - room_container.min_rooms)) + room_container.min_rooms
	
	# Generate main path
	var step = 0
	for i in level_length:
		# Create new room
		var new_room = room_container.common_rooms[randi() % room_container.common_rooms.size()].instance()
		add_child(new_room)
		new_room.room_name = "M" + str(i)
		new_room.name = new_room.room_name
		new_room.translation = Vector3(0, 0, 50 * i)
			
		# Prep room links
		for j in new_room.room_portals:
			new_room.connected_rooms.push_back("")
		
		# If not the first room
		if i != 0:
			# Link last room to this room
			var room_found = false
			while !room_found:
				# No rooms lower than 0, cycle to the top
				if step <= 0:
					step = main_path.size()-1
				
				# Check for open portal nodes
				var open_nodes = []
				for j in main_path[step-1].connected_rooms.size():
					if main_path[step-1].connected_rooms[j] == "":
						open_nodes.push_back(j)
				# Assign new room to last rooms portal
				if open_nodes.size() != 0:
					room_found = true
					var portal_index = open_nodes[randi() % open_nodes.size()]
					main_path[step-1].connected_rooms[portal_index] = "M" + str(i)
				# If no open portals, step back a room
				else:
					step -= 1
				
			# Set Return room
			new_room.return_room = main_path[step-1].room_name
		
		main_path.push_back(new_room)
		
		step += 1
		# Branch back
		if randf() < room_container.odds_of_branching:
			step -= 1
		
		
	# Add Boss
	var boss_room = room_container.boss_rooms[randi() % room_container.boss_rooms.size()].instance()
	add_child(boss_room)
	boss_room.room_name = "B0"
	boss_room.name = boss_room.room_name
	boss_room.translation = Vector3(0, 0, 50)
	
	# Set Boss Return room
	boss_room.return_room = "M" + str(main_path.size()-1)
	
	# Connect last room to boss room
	var last_room = main_path[main_path.size()-1]
	var portal_index = randi() % last_room.room_portals.size()
	last_room.connected_rooms[portal_index] = "B0"
	
	main_path.push_back((boss_room))
	
