extends Node

@export var enemy_scene: PackedScene
@export var spawn_interval_range := Vector2(1.0, 3.0)
@export var max_enemies := 10
@export var spawn_radius := 10.0

var _enemies := []
var _spawn_timer := 0.0
var _next_spawn_time := 0.0
var _char: Node3D

func _ready():
	_char = get_parent().get_node_or_null("char")
	_reset_spawn_timer()

func _process(delta):
	if _enemies.size() >= max_enemies:
		return

	_spawn_timer += delta
	if _spawn_timer >= _next_spawn_time:
		_spawn_timer = 0.0
		_reset_spawn_timer()
		_spawn_enemy()

func _reset_spawn_timer():
	_next_spawn_time = randf_range(spawn_interval_range.x, spawn_interval_range.y)

func _spawn_enemy():
	if _char == null:
		return

	var enemy = enemy_scene.instantiate()
	var angle = randf() * TAU
	var distance = randf_range(3.0, spawn_radius)
	var offset = Vector3(cos(angle), 0, sin(angle)) * distance
	var spawn_pos = _char.global_position + offset
	spawn_pos.y = 1.0  # ou ajuste isso para alinhar com o seu chão

	enemy.global_position = spawn_pos

	get_parent().add_child(enemy)
	_enemies.append(enemy)

	enemy.connect("tree_exited", Callable(self, "_on_enemy_exited").bind(enemy))

func _on_enemy_exited(enemy):
	_enemies.erase(enemy)
