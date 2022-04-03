extends Node

# TODO: WIP save/load system

var rooms
var room_loader
var current_room

var save_nodes

var save_vars = {
	"current_room": current_room,
	"power_ups": [],
	"player_vars": {}
}


func _ready():
	save_nodes = get_tree().get_nodes_in_group("Save")


func save():
	for node in save_nodes:
		if node is Player:
			save_vars.player_vars.hp = node.hp

	var save_file = File.new()
	save_file.open("user://slot01", File.WRITE)
	save_file.store_line(to_json(save_vars))
	save_file.close()
			

func load():
	pass


func _on_LevelController_level_loaded(all_rooms, _room_loader):
	rooms = all_rooms
	for room in all_rooms:
		if room.is_activated:
			current_room = room
			save_vars.current_room = room
	room_loader = _room_loader


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

