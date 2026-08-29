extends Interactable

var _item: Node3D

@onready var _counter_top: Marker3D = %CounterTop


func _ready() -> void:
	interactable_type = InteractableType.CLEAR_COUNTER


func interact() -> void:
	if Global.player.get_item() and not _item:
		_item = Global.player.get_item()

		Global.player.give_item(_counter_top)

		_item.position = Vector3.ZERO
		_item.rotation = Vector3.ZERO
		_item.scale = Vector3.ONE
	elif not Global.player.get_item() and _item:
		Global.player.take_item(_item)

		_item = null


func _process(_delta: float) -> void:
	if Global.player.get_item() and not _item:
		interactable_name = "Place Item"
	elif not Global.player.get_item() and _item:
		interactable_name = "Take Item"
	else:
		interactable_name = "Empty Counter"
