extends Control

@onready var _music_slider: HSlider = %MusicSlider
@onready var _sfx_slider: HSlider = %SfxSlider
@onready var _ui_menu: Panel = %UIMenu


func _ready() -> void:
	_ui_menu.hide()


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(1, _music_slider.value)


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(2, _sfx_slider.value)


func _on_menu_button_pressed() -> void:
	_ui_menu.visible = not _ui_menu.visible


func _on_close_button_pressed() -> void:
	_ui_menu.hide()
