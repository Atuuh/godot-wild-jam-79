class_name Gauge

extends Node2D

signal completed

enum State {
    NOT_STARTED,
    STARTING,
    IN_PROGRESS,
    COMPLETED,
}

@export var action_increment_amount: float
@export var decrement_speed: float
@export var target_time: float

@export_group("Needle Rotation")
@export var min_rotation: float
@export var max_rotation: float
@export var target_rotation: float
@export var rotation_threshold: float

var _time_in_target: float
var _state: State

func _init() -> void:
    _state = State.IN_PROGRESS
    completed.connect(_debug_completed)

func _debug_completed() -> void:
    print("game completed")

func _process(delta: float) -> void:
    match _state:
        State.IN_PROGRESS:
            var new_rotation: float = $Needle.rotation_degrees - decrement_speed * delta
            if Input.is_action_just_pressed("move_right"):
                new_rotation += action_increment_amount
            $Needle.rotation_degrees = clampf(new_rotation, min_rotation, max_rotation)

            if _is_in_target():
                _time_in_target += delta
            else:
                _time_in_target = 0

            if _time_in_target >= target_time:
                _state = State.COMPLETED
                completed.emit()
    
func _is_in_target() -> bool:
    return $Needle.rotation_degrees >= target_rotation - rotation_threshold && $Needle.rotation_degrees <= target_rotation + rotation_threshold