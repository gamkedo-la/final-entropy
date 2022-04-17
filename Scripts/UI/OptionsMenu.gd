extends CanvasLayer

var settings_file = "user://settings.save"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var main_slider = $MC/CenVB/TabCon/Audio/AudVBox/MainHB/MainSlider
onready var music_slider = $MC/CenVB/TabCon/Audio/AudVBox/MusicHB/MusSlider
onready var sfx_slider = $MC/CenVB/TabCon/Audio/AudVBox/SFXHB/SFXSlider
onready var amb_slider = $MC/CenVB/TabCon/Audio/AudVBox/AmbHB/AmbSlider

onready var main_cb = $MC/CenVB/TabCon/Audio/AudVBox/MainHB/MainCB
onready var music_cb = $MC/CenVB/TabCon/Audio/AudVBox/MusicHB/MusCB
onready var sfx_cb = $MC/CenVB/TabCon/Audio/AudVBox/SFXHB/SFXCB
onready var amb_cb = $MC/CenVB/TabCon/Audio/AudVBox/AmbHB/AmbCB
onready var menu = $MC

var main_vol: float = 1.0
var music_vol: float = 1.0
var sfx_vol: float = 1.0
var amb_vol: float = 1.0

var main_disabled: bool = false
var music_disabled: bool = false
var sfx_disabled: bool = false
var amb_disabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()
	set_sliders()
	enabled(false)

func enabled(enable: bool) -> void:
	menu.visible = enable
	if !menu.visible:
		save_settings()

func save_settings() -> void:
	var f = File.new()
	f.open(settings_file, File.WRITE)
	f.store_var(main_vol)
	f.store_var(music_vol)
	f.store_var(sfx_vol)
	f.store_var(amb_vol)
	f.store_var(main_disabled)
	f.store_var(music_disabled)
	f.store_var(sfx_disabled)
	f.store_var(amb_disabled)
	f.close()

func load_settings() -> void:
	var f = File.new()
	if f.file_exists(settings_file):
		f.open(settings_file, File.READ)
		main_vol = f.get_var()
		music_vol = f.get_var()
		sfx_vol = f.get_var()
		amb_vol = f.get_var()
		main_disabled = f.get_var()
		music_disabled = f.get_var()
		sfx_disabled = f.get_var()
		amb_disabled = f.get_var()
		f.close()

func set_sliders() -> void:
	main_slider.value = main_vol
	music_slider.value = music_vol
	sfx_slider.value = sfx_vol
	amb_slider.value = amb_vol
	main_cb.pressed = main_disabled
	music_cb.pressed = music_disabled
	sfx_cb.pressed = sfx_disabled
	amb_cb.pressed = amb_disabled
	set_volume()

func set_volume() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(main_vol))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(music_vol))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sfx_vol))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambience"), linear2db(amb_vol))
	
func _on_MainSlider_value_changed(value):
	main_vol = value
	set_volume()

func _on_MusSlider_value_changed(value):
	music_vol = value
	set_volume()

func _on_SFXSlider_value_changed(value):
	sfx_vol = value
	set_volume()

func _on_AmbSlider_value_changed(value):
	amb_vol = value
	set_volume()

func _on_MainCB_toggled(button_pressed):
	main_disabled = button_pressed
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), button_pressed)

func _on_MusCB_toggled(button_pressed):
	music_disabled = button_pressed
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), button_pressed)

func _on_SFXCB_toggled(button_pressed):
	sfx_disabled = button_pressed
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), button_pressed)

func _on_AmbCB_toggled(button_pressed):
	amb_disabled = button_pressed
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Ambience"), button_pressed)
