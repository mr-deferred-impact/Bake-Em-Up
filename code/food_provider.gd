extends Interactable

@export var _food_scene: PackedScene


func _ready() -> void:
	interactable_type = InteractableType.FOOD_PROVIDER


func interact() -> void:
	if not Global.player.get_item():
		var item := _food_scene.instantiate()

		add_child(item)

		Global.player.take_item(item)
