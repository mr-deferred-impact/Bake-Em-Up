class_name Player extends CharacterBody3D

const _RETICLE_NORMAL: Texture2D = preload("res://assets/ui/kenney_cursors/tile_0200.png")
const _RETICLE_INTERACTABLE: Texture2D = preload("res://assets/ui/kenney_cursors/tile_0154.png")

@export var _speed := 5.5
@export var _acceleration := 15.0
@export var _deceleration := 13.75
@export var _mouse_sensitivity := 0.2

var _interactable: Interactable

@onready var _camera: Camera3D = %Camera3D
@onready var _interaction_ray: RayCast3D = %InteractionRay
@onready var _interactable_name: Label = %InteractableName
@onready var _reticle: TextureRect = %Reticle
@onready var _hand: Marker3D = %Hand


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	var mouse_capture: bool = (
		event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed() and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE
	)

	var mouse_release: bool = event.is_action_pressed("ui_cancel") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED

	var mouse_move: bool = event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED

	if mouse_capture:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif mouse_release:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif mouse_move:
		_camera.rotation_degrees.x -= _mouse_sensitivity * event.screen_relative.y
		_camera.rotation_degrees.y -= _mouse_sensitivity * event.screen_relative.x

	_camera.rotation_degrees.x = clampf(_camera.rotation_degrees.x, -60.0, 65.0)


func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down").rotated(-_camera.rotation.y)
	var direction := Vector3(input_vector.x, 0.0, input_vector.y)

	if direction.length() > 0.0:
		var desired_velocity := direction * _speed

		velocity = velocity.move_toward(desired_velocity, _acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, _deceleration * delta)

	move_and_slide()

	if _interaction_ray.is_colliding() and _interaction_ray.get_collider() is Interactable:
		_interactable = _interaction_ray.get_collider()
		_reticle.texture = _RETICLE_INTERACTABLE
		_interactable_name.text = "[E - %s]" % _interactable.interactable_name

	elif _interactable:
		_interactable = null
		_reticle.texture = _RETICLE_NORMAL
		_interactable_name.text = "[E - ]"

	if _interactable != null and Input.is_action_just_pressed("interact"):
		_interactable.interact()


func get_item() -> Pickable:
	if _hand.get_child_count(0) > 0:
		return _hand.get_child(0)

	return null


func take_item(item: Pickable) -> void:
	item.reparent(_hand)
	item.position = Vector3.ZERO
	item.rotation = Vector3.ZERO
	item.scale = Vector3(item.pickable_size, item.pickable_size, item.pickable_size)


func give_item(target: Marker3D) -> void:
	get_item().reparent(target)
