class_name AsteroidDodge

extends Node

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

var _state: State
var _asteroids_spawned: int
var _rng: RandomNumberGenerator

func _ready() -> void:
    _state = State.IN_PROGRESS
    _rng = RandomNumberGenerator.new()
    while _state != State.COMPLETE and _asteroids_spawned < asteroid_count:
        _spawn_asteroid()
        await get_tree().create_timer(asteroid_spawn_rate).timeout
        
func _draw() -> void:
    pass

func _spawn_asteroid() -> void:
    var asteroid: Asteroid = AsteroidScene.instantiate();
    asteroid.exited_screen.connect(_on_asteroid_despawned)
    asteroid.init(asteroid_speed)
    _asteroids_spawned += 1
    asteroid.position.x = _get_random_track_position()
    asteroid.position.y = -100
    asteroid_root.add_child(asteroid)

func _on_asteroid_despawned() -> void:
    print("asteroid despawned")

func _get_random_track_position() -> float:
    var track: int = _rng.randi_range(0, track_count - 1)
    var offset: float = track_count / 2.0
    return track * track_spacing - offset
