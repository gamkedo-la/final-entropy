tool
extends Resource
class_name RoomContainer

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


