class_name Player extends CharacterBody3D

@export var _speed := 5.5
@export var _acceleration := 15.0
@export var _deceleration := 13.75
@export var _mouse_sensitivity := 0.2

@onready var _camera: Camera3D = %Camera3D
@onready var _interaction_ray: RayCast3D = %InteractionRay


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

	_camera.rotation_degrees.x = clampf(_camera.rotation_degrees.x, -35.0, 65.0)


func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down").rotated(-_camera.rotation.y)
	var direction := Vector3(input_vector.x, 0.0, input_vector.y)

	if direction.length() > 0.0:
		var desired_velocity := direction * _speed

		velocity = velocity.move_toward(desired_velocity, _acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, _deceleration * delta)

	move_and_slide()
