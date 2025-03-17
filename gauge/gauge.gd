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
@onready var _needle: Sprite2D = $Needle

func _init() -> void:
    _state = State.NOT_STARTED
    completed.connect(_debug_completed)

func _debug_completed() -> void:
    print("game completed")

func _process(delta: float) -> void:
    match _state:
        State.IN_PROGRESS:
            var new_rotation: float = _needle.rotation_degrees - decrement_speed * delta
            if Input.is_action_just_pressed("move_right"):
                new_rotation += action_increment_amount
            _needle.rotation_degrees = clampf(new_rotation, min_rotation, max_rotation)

            if _is_in_target():
                _time_in_target += delta
            else:
                _time_in_target = 0

            if _time_in_target >= target_time:
                _state = State.COMPLETED
                completed.emit()
    
func start() -> void:
    _state = State.STARTING
    var tween := create_tween()
    tween.tween_property(_needle, "rotation_degrees", min_rotation, 2.0)
    await tween.finished
    _state = State.IN_PROGRESS

func _is_in_target() -> bool:
    return _needle.rotation_degrees >= target_rotation - rotation_threshold && _needle.rotation_degrees <= target_rotation + rotation_threshold