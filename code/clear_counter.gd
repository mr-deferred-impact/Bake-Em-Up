extends Interactable

var _item: Node3D

@onready var _counter_top: Marker3D = %CounterTop


func _ready() -> void:
	interactable_type = InteractableType.CLEAR_COUNTER


func interact() -> void:
	pass
