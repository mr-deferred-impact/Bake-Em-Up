@icon("res://addons/at-icons/node3d/person_body.svg")
class_name Customer
extends Interactable

signal arrived
signal item_received

#const _AVAILABLE_FOOD_ITEMS: Array[String] = ["birthday cake", "chocolate cake", "big load of bread", "small piece of bread", "croissant", "carton of milk", "bag of flour"]
const _AVAILABLE_FOOD_ITEMS: Array[String] = ["birthday cake", "chocolate cake", "croissant", "carton of milk", "bag of flour"]
const _LOOPING_ANIMATIONS: Array[StringName] = ["idle", "walk", "sprint"]

var animation_player: AnimationPlayer
var _item := _AVAILABLE_FOOD_ITEMS.pick_random() as String

@onready var _dialogue_box: RichTextLabel = %DialogueBox
@onready var _hud: Control = %HUD
@onready var _text_sound: AudioStreamPlayer3D = %TextSound


func _ready() -> void:
	interactable_type = InteractableType.CUSTOMER

	for anim: StringName in _LOOPING_ANIMATIONS:
		animation_player.get_animation(anim).loop_mode = Animation.LOOP_LINEAR

	_hud.hide()

	arrived.connect(
		func() -> void:
			animation_player.play("idle")
	)


func interact() -> void:
	if not Global.player.get_item():
		write_dialogue("%s I have a [b]%s[/b] please?" % ["May", _item])

	elif not Global.player.get_item().pickable_name == _item:
		write_dialogue("This is not the item I asked for. Please get me a [b]%s[/b]" % _item)

	else:
		item_received.emit()


func write_dialogue(text: String) -> void:
	_hud.show()
	_text_sound.play()

	_dialogue_box.visible_ratio = 0.0
	_dialogue_box.text = text

	var tween := create_tween()
	var duration: float = _dialogue_box.get_parsed_text().length() / 30.0

	tween.tween_property(_dialogue_box, "visible_ratio", 1.0, duration)

	tween.finished.connect(
		func() -> void:
			_text_sound.stop()
			get_tree().create_timer(2.5).timeout.connect(_hud.hide)
	)
