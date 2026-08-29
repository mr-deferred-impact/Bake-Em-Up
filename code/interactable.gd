@icon("res://addons/at-icons/node3d/hand.svg")
@abstract class_name Interactable
extends StaticBody3D

enum InteractableType {
	CLEAR_COUNTER,
	CUTTING_COUNTER,
	FOOD_PROVIDER,
	OVEN,
	STOVE,
	TRASH_CAN,
}

@export var interactable_name: String

var interactable_type: InteractableType


@abstract func interact() -> void
