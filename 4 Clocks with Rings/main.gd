extends Node2D


## Clock to be spawned.
@export var clock_scene: PackedScene
## Radius of the clock, in pixels.
@export var clock_radius := 128.0

@export_group("Clock Instances")
@export_range(0.1, 1.0) var scale_min := 0.25
@export_range(0.1, 1.0) var scale_max := 1.0
@export var time_scale_min := -10.0
@export var time_scale_max := 10.0

@export_group("Nodes")
@export var bottom: Node2D
@export var ground: Node2D

var _window_width: float


func _ready() -> void:
	get_window().size_changed.connect(_on_size_changed)
	_on_size_changed()


func _on_size_changed() -> void:
	var window_size := get_window().size
	_window_width = window_size.x
	bottom.position.y = window_size.y + 2.0 * clock_radius
	ground.position = Vector2(
			0.5 * window_size.x,
			window_size.y + 0.5 * clock_radius
	)
	ground.scale = Vector2(window_size.x, clock_radius)


func _on_spawn_timer_timeout() -> void:
	var clock := clock_scene.instantiate() as Clock
	clock.start_time = Clock.StartTimeMode.RANDOM_TIME
	clock.time_scale = randf_range(time_scale_min, time_scale_max)
	clock.set_uniform_scale(randf_range(scale_min, scale_max))
	clock.position = Vector2(
			randf_range(clock_radius, _window_width - clock_radius),
			-3.0 * clock_radius
	)
	add_child(clock)


func _on_bottom_body_entered(body: Node2D) -> void:
	body.queue_free()
