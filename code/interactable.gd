@icon("res://addons/at-icons/node3d/hand.svg")
@abstract class_name Interactable extends StaticBody3D

enum InteractableType {
	CLEAR_COUNTER,
	CUTTING_COUNTER,
	INGREDIENT_PROVIDER,
	OVEN,
	STOVE,
	TRASH_CAN,
}

@export var outline_mesh: MeshInstance3D

var interactable_type: InteractableType


@abstract func interact() -> void
