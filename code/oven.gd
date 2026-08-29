extends Interactable

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _rack: Marker3D = %Rack
@onready var _bake_progress: TextureProgressBar = %BakeProgress
@onready var _bake_timer: Timer = %BakeTimer
@onready var _clock_ticking_sound: AudioStreamPlayer = %ClockTickingSound
@onready var _clock_ding: AudioStreamPlayer = %ClockDing

var _item: Cookable


func _ready() -> void:
	_bake_progress.hide()

	_bake_progress.max_value = _bake_timer.wait_time

	_bake_timer.timeout.connect(
		func() -> void:
			_item.cook()

			get_tree().create_timer(0.5).timeout.connect(
				func() -> void:
					_bake_progress.value = 0.0
					_bake_progress.hide()
					_clock_ticking_sound.stop()
					_clock_ding.play()
			)
	)


func interact() -> void:
	if not _item and Global.player.get_item() and Global.player.get_item() is Cookable:
		_animation_player.play("open")

		_item = Global.player.get_item()

		Global.player.give_item(_rack)
		_item.scale = Vector3(_item.cook_size, _item.cook_size, _item.cook_size)
		_item.position = Vector3.ZERO
		_item.rotation = Vector3.ZERO
		_item.set_no_material()
		_item.food_mesh.set_surface_override_material(0, null)

		get_tree().create_timer(0.65).timeout.connect(
			func() -> void:
				_animation_player.play_backwards("open")
				_bake_timer.start()
				_bake_progress.show()
				_clock_ticking_sound.play()
		)

	elif _item and _item.is_cooked and not Global.player.get_item():
		_animation_player.play("open")

		Global.player.take_item(_item)
		_item.set_cooked_material()

		_item.cook()

		_item = null

		get_tree().create_timer(0.35).timeout.connect(_animation_player.play_backwards.bind("open"))


func _process(_delta: float) -> void:
	_bake_progress.value = _bake_timer.wait_time - _bake_timer.time_left
