class_name Clock
extends RigidBody2D


enum StartTimeMode {
	SYSTEM_TIME,
	RANDOM_TIME,
	FIXED_TIME,
	OFFSET_TIME,
}

## Time scale of the clock, can be negative.
@export var time_scale := 1.0
## What time to use for the starting time of the clock.
@export var start_time := StartTimeMode.SYSTEM_TIME

@export_group("Fixed or Offset Start Time")
@export_range(-11, 11) var start_hour := 0
@export_range(0, 59) var start_minute := 0
@export_range(0, 59) var start_second := 0

@export_group("Nodes")
@export var collisionShape: CollisionShape2D
@export var visualization: Node2D
@export_subgroup("Arms")
@export var second_arm: Node2D
@export var minute_arm: Node2D
@export var hour_arm: Node2D

var seconds := 0.0


func _ready() -> void:
	if start_time == StartTimeMode.RANDOM_TIME:
		seconds = randf_range(0.0, 43200.0)
	else:
		if start_time != StartTimeMode.FIXED_TIME:
			var current_time := Time.get_time_dict_from_system()
			seconds = float(
					current_time.second +
					current_time.minute * 60 +
					current_time.hour * 3600
			)
		if start_time != StartTimeMode.SYSTEM_TIME:
			seconds += start_second + start_minute * 60 + start_hour * 3600


func _process(delta: float) -> void:
	seconds += delta * time_scale
	second_arm.rotation = fmod(seconds, 60.0) * TAU / 60.0
	minute_arm.rotation = fmod(seconds / 60.0, 60.0) * TAU / 60.0
	hour_arm.rotation = fmod(seconds / 3600.0, 12.0) * TAU / 12.0


func set_uniform_scale(scale_factor: float) -> void:
	var scale_vector = Vector2(scale_factor, scale_factor)
	collisionShape.scale = scale_vector
	visualization.scale = scale_vector
	mass = scale_factor * scale_factor
