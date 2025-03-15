class_name AsteroidDodge

extends Node2D

const AsteroidScene = preload("res://asteroid-dodge/asteroid/asteroid.tscn")

enum State {
    IN_PROGRESS,
    COMPLETE
}

@export var track_count: int
@export var track_spacing: int
@export var asteroid_count: int
@export var asteroid_speed: int
@export var asteroid_spawn_rate: float
@export var asteroid_root: Node2D

signal completed()

var _state: State
var _asteroids_spawned: int
var _asteroids_remaining: int
var _rng: RandomNumberGenerator

func _ready() -> void:
    completed.connect(_test)
    _state = State.IN_PROGRESS
    _asteroids_remaining = asteroid_count
    _rng = RandomNumberGenerator.new()
    while _state != State.COMPLETE and _asteroids_spawned < asteroid_count:
        _spawn_asteroid()
        await get_tree().create_timer(asteroid_spawn_rate).timeout

func _process(_delta: float) -> void:
    if not _state == State.COMPLETE and _asteroids_remaining == 0:
        _state = State.COMPLETE
        completed.emit()

func _draw() -> void:
    if not OS.is_debug_build():
        pass
    for track in range(track_count):
        var track_position: float = _get_track_position(track)
        draw_line(Vector2(track_position, 0), Vector2(track_position, 1000), Color.GREEN)

func _test() -> void:
    print("Asteroids completed")

func _spawn_asteroid() -> void:
    var asteroid: Asteroid = AsteroidScene.instantiate();
    asteroid.exited_screen.connect(_on_asteroid_despawned)
    asteroid.init(asteroid_speed)
    _asteroids_spawned += 1
    asteroid.position.x = _get_random_track_position()
    asteroid.position.y = -100
    asteroid_root.add_child(asteroid)

func _on_asteroid_despawned() -> void:
    _asteroids_remaining -= 1

func _get_track_position(track_number: int) -> float:
    var offset: float = track_count / 2.0
    return track_number * track_spacing - offset

func _get_random_track_position() -> float:
    var track: int = _rng.randi_range(0, track_count - 1)
    return _get_track_position(track)
