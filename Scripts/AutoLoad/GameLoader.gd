extends Node

# TODO: WIP save/load system

var rooms
var room_loader

var current_room = ""
var current_connected_rooms = []
var return_room = ""
var current_room_node = null

var old_room_node

var save_nodes

var save_vars = {
	"current_room": current_room,
	"current_connected_rooms": [],
	"return_room": return_room,
	"current_room_scene": "",
	"power_ups": [],
	"player_vars": {}
}


func _ready():
	save_nodes = get_tree().get_nodes_in_group("Save")


func check_if_slot_exists(slot):
	var slot_name = str(slot).pad_zeros(3)
	var save_file = File.new()
	if not save_file.file_exists("user://saves/slot" + slot_name):
		save_file.close()
		return false
	save_file.close()
	return true


func save(slot:int):
	save_nodes = get_tree().get_nodes_in_group("Save")

	for node in save_nodes:
		if node is Player:
			save_vars.player_vars.hp = node.hp

	var slot_name = str(slot).pad_zeros(3)
	var save_file = File.new()

	var directory = Directory.new()
	if not directory.dir_exists("user://saves/"):
		directory.make_dir("user://saves/")

	save_file.open("user://saves/slot" + slot_name, File.WRITE)
	print_debug("Saving in slot " + str(slot))
	print_debug(save_vars)

	save_file.store_var(save_vars, true)
	# save_file.store_line(to_json(save_vars))
	save_file.close()


func load(slot:int):
	save_nodes = get_tree().get_nodes_in_group("Save")

	var slot_name = str(slot).pad_zeros(3)
	var save_file = File.new()
	if not check_if_slot_exists(slot):
		return
	
	print_debug("Loading from slot " + str(slot))
	save_file.open("user://saves/slot" + slot_name, File.READ)
	save_vars = save_file.get_var(true)

	var room_nodes = current_room_node.get_parent()

	var loaded_room = load(save_vars.current_room_scene).instance()

	for room_node in room_nodes.get_children():
		room_node.deactivate()
		if room_node.room_name == save_vars.current_room:
			old_room_node = room_node
			loaded_room.connected_rooms = save_vars.current_connected_rooms
			loaded_room.level_controller = room_nodes.get_parent()
			room_node.replace_by(loaded_room)
			old_room_node.free()

	current_room = save_vars.current_room
	return_room = save_vars.return_room
	current_room_node = loaded_room

	reset_loaded_room()

	print_debug(save_vars)
	
	room_loader.call_deferred("call_func", save_vars.current_room, "", true)
	for node in save_nodes:
		if node is Player:
			node.reset_from_save(save_vars)

	current_room_node.activate()

	save_file.close()


func reset_loaded_room():
	current_room_node.room_name = current_room
	current_room_node.name = current_room
	current_room_node.return_room = return_room

	for child in current_room_node.get_children():
		if child.name.begins_with("@"):
			child.queue_free()


func _on_LevelController_level_loaded(all_rooms, _room_loader, player_node=null):
	rooms = all_rooms
	room_loader = _room_loader

	for room in all_rooms:
		if room.is_activated:
			current_room = room.room_name
			current_connected_rooms = room.connected_rooms
			current_room_node = room
			current_room_node.return_room = save_vars.return_room

			save_vars.current_room = room.room_name
			save_vars.current_connected_rooms = room.connected_rooms
			save_vars.return_room = room.return_room
			save_vars.current_room_scene = room.filename

	print_debug("Current room: " + str(save_vars.current_room))
	print_debug("Return room: " + str(save_vars.return_room))


func _on_TD_Player_powered_up(pickup):
	var picked_up_object = {
		"powerUpName": pickup.powerUpName,
		"indexNum": pickup.indexNum,
		"baseHP": pickup.baseHP,
		"baseShields": pickup.baseShields,

		"rounds_per_minute_bonus": pickup.rounds_per_minute_bonus,
		"shotDmg": pickup.shotDmg,
		"shotDmgMult": pickup.shotDmgMult,
		"shotSpeed": pickup.shotSpeed,
		"bulletCount": pickup.bulletCount
	}
	save_vars["power_ups"].append(picked_up_object)
	print_debug("Serialized picked powerup: " + str(picked_up_object))

