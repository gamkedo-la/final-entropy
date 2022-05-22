extends Node


onready var menu_bgm: AudioStreamPlayer = $MenuBGM
onready var ambient_bgm: AudioStreamPlayer = $AmbientBGM
onready var action01_bgm: AudioStreamPlayer = $ActionBGM1

export (Array, AudioStream) var ambient_tracks

var fade_speed := 20.0

var ambient_target = -80
var menu_target = -80
var combat_target = -80
var boss_target = -80

var easein_time = 4.0
var boss_inrange: bool = false
var total_engaged: int = 0

onready var fade_tween = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
#	action01_bgm.volume_db = -80	
#	call_deferred("add_child", fade_tween)
#	fade_tween.interpolate_property(
#		ambient_bgm,
#		"volume_db",
#		action01_bgm.volume_db, 0, easein_time, Tween.TRANS_QUART, Tween.EASE_IN_OUT
#	)
#	fade_tween.call_deferred("start")
	pass # Replace with function body.

func _process(delta) -> void:
	_set_targets()
	_set_levels(delta)

func register_enemy(newEnemy: AIController) -> void:
	if not newEnemy.is_connected("state_changed", self, "_enemy_state_changed"):
		var con_res = newEnemy.connect("state_changed", self, "_enemy_state_changed")
		assert(con_res == OK)

func _enemy_state_changed(state: int) -> void:
	if state == AIController.State.DEAD && total_engaged > 0:
		total_engaged -= 1
	elif state == AIController.State.ENGAGE:
		total_engaged += 1
		
func _set_targets() -> void:
	boss_target = -80
	ambient_target = -80
	combat_target = -80
	menu_target = -80
	if Global.main_menu:
		menu_target = 0
	elif total_engaged > 0:		
		combat_target = 0
	elif boss_inrange:
		boss_target = 0
	else:
		ambient_target = 0


func _set_levels(delta: float) -> void:
	var fade_this_frame = fade_speed * delta
	
	if menu_bgm.volume_db < menu_target - fade_this_frame:
		menu_bgm.volume_db += fade_this_frame
	if menu_bgm.volume_db > menu_target + fade_this_frame:
		menu_bgm.volume_db -= fade_this_frame
		
	if ambient_bgm.volume_db < ambient_target - fade_this_frame:
		ambient_bgm.volume_db += fade_this_frame
	if ambient_bgm.volume_db > ambient_target + fade_this_frame:
		ambient_bgm.volume_db -= fade_this_frame
	
#	if impending_threat.volume_db < impending_target - fade_this_frame:
#		impending_threat.volume_db += fade_this_frame
#	if impending_threat.volume_db > impending_target + fade_this_frame:
#		impending_threat.volume_db -= fade_this_frame
	
	if action01_bgm.volume_db < combat_target - fade_this_frame:
		action01_bgm.volume_db += fade_this_frame
	if action01_bgm.volume_db > combat_target + fade_this_frame:
		action01_bgm.volume_db -= fade_this_frame
	
#	if boss_music.volume_db < boss_target - fade_this_frame:
#		boss_music.volume_db += fade_this_frame
#	if boss_music.volume_db > boss_target + fade_this_frame:
#		boss_music.volume_db -= fade_this_frame
	pass


func _on_AmbientBGM_finished():
	ambient_bgm.stream = ambient_tracks[randi() % ambient_tracks.size()]
	ambient_bgm.play()
