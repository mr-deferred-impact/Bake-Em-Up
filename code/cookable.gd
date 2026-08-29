class_name Cookable
extends Pickable

const _FOOD_COOKED_MATERIAL: StandardMaterial3D = preload("res://resources/food_cooked_material.tres")
const _FOOD_NORMAL_MATERIAL: StandardMaterial3D = preload("res://resources/food_material.tres")

@export var food_mesh: MeshInstance3D
@export var cook_size := 1.0

var is_cooked := false


func _ready() -> void:
	food_mesh.material_override = _FOOD_NORMAL_MATERIAL


func cook() -> void:
	is_cooked = true


func set_cooked_material() -> void:
	food_mesh.material_override = _FOOD_COOKED_MATERIAL


func set_no_material() -> void:
	food_mesh.material_override = null
