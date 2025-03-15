class_name Asteroid

extends Node2D

signal exited_screen()

var _speed: int

func _ready() -> void:
    $VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func _physics_process(delta: float) -> void:
    position.y += _speed * delta

func init(speed: int) -> void:
    _speed = speed

func _on_screen_exited() -> void:
    exited_screen.emit()
    queue_free()
