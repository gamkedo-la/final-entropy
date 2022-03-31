tool
extends Resource
class_name RoomContainer

export (int) var min_rooms = 5
export (int) var max_rooms = 8
export (float) var odds_of_special_room
export (int) var vertical_seperation = 50
export (int) var horizontal_seperation = 50
export (Array, PackedScene) var boss_rooms setget set_boss_rooms
export (Array, PackedScene) var special_rooms setget set_special_rooms
export (Array, PackedScene) var common_rooms setget set_common_rooms

func set_boss_rooms(value) -> void:
	boss_rooms.resize(value.size())
	boss_rooms = value

func set_special_rooms(value) -> void:
	special_rooms.resize(value.size())
	special_rooms = value

func set_common_rooms(value) -> void:
	common_rooms.resize(value.size())
	common_rooms = value


