extends Node


onready var menu_bgm: AudioStreamPlayer = $MenuBGM
onready var ambient_bgm: AudioStreamPlayer = $AmbientBGM
onready var action01_bgm: AudioStreamPlayer = $ActionBGM1

onready var fade_tween = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	action01_bgm.volume_db = -80	
	call_deferred("add_child", fade_tween)
	fade_tween.interpolate_property(
		action01_bgm,
		"volume_db",
		action01_bgm.volume_db, 0, 4.0, Tween.TRANS_QUART, Tween.EASE_IN_OUT
	)
	fade_tween.call_deferred("start")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
