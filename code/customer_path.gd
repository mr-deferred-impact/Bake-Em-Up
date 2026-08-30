extends Path3D

const _CUSTOMER_SCENES: Array[PackedScene] = [
	preload("res://assets/models/3d_characters/character-female-a.glb"),
	preload("res://assets/models/3d_characters/character-female-b.glb"),
	preload("res://assets/models/3d_characters/character-female-c.glb"),
	preload("res://assets/models/3d_characters/character-female-d.glb"),
	preload("res://assets/models/3d_characters/character-female-e.glb"),
	preload("res://assets/models/3d_characters/character-female-f.glb"),
	preload("res://assets/models/3d_characters/character-male-a.glb"),
	preload("res://assets/models/3d_characters/character-male-b.glb"),
	preload("res://assets/models/3d_characters/character-male-c.glb"),
	preload("res://assets/models/3d_characters/character-male-d.glb"),
	preload("res://assets/models/3d_characters/character-male-e.glb"),
	preload("res://assets/models/3d_characters/character-male-f.glb"),
]

var path_follow := PathFollow3D.new()
var customer: Customer = preload("res://scenes/customer.tscn").instantiate() as Customer


func _ready() -> void:
	_spawn_customer()
	path_follow.rotation_mode = PathFollow3D.ROTATION_NONE

	customer.item_received.connect(
		func() -> void:
			Global.player.get_item().queue_free()

			var tween := create_tween()
			var duration := 4.0

			customer.animation_player.play("walk")

			tween.tween_property(customer, "rotation_degrees:y", 180.0, 0.5)
			tween.tween_property(path_follow, "progress_ratio", 0.0, duration)

			tween.finished.connect(
				func() -> void:
					customer.animation_player.play("idle")
			)
	)


func _spawn_customer() -> void:
	var character: Node3D = (_CUSTOMER_SCENES.pick_random() as PackedScene).instantiate()

	customer.animation_player = character.get_child(1)

	add_child(path_follow)

	path_follow.add_child(customer)
	customer.add_child(character)
	customer.animation_player.play("walk")

	character.scale = Vector3.ONE * 3.0
	path_follow.rotation = Vector3.ZERO
	character.rotation_degrees.y = -90.06

	var tween := create_tween()
	var duration := 3.5

	tween.tween_property(path_follow, "progress_ratio", 1.0, duration)

	tween.finished.connect(customer.arrived.emit)


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.
