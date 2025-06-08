extends Node3D

@export var block_scene: PackedScene
@export var block_size: float = 0.2
@export var update_interval := 0.05


var time_accumulator := 0.0
var generated_blocks := {}

func _ready():
	update_ground()

func _process(delta):
	time_accumulator += delta
	if time_accumulator >= update_interval:
		time_accumulator = 0.0
		update_ground()

func update_ground():
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return

	var viewport := get_viewport()
	var size = viewport.get_visible_rect().size

	var corners = [
		Vector2(0, 0),
		Vector2(size.x, 0),
		Vector2(size.x, size.y),
		Vector2(0, size.y)
	]

	var min_x = INF
	var max_x = -INF
	var min_z = INF
	var max_z = -INF

	for corner in corners:
		var from = camera.project_ray_origin(corner)
		var to = from + camera.project_ray_normal(corner) * 1000.0

		var plane = Plane(Vector3.UP, 0.0)
		var hit = plane.intersects_ray(from, to - from)
		if hit != null:
			var pos = hit
			min_x = min(min_x, pos.x)
			max_x = max(max_x, pos.x)
			min_z = min(min_z, pos.z)
			max_z = max(max_z, pos.z)

	if min_x == INF or max_x == -INF:
		return  # nenhum ponto visível

	var start_x = int(floor(min_x / block_size))
	var end_x = int(ceil(max_x / block_size))
	var start_z = int(floor(min_z / block_size))
	var end_z = int(ceil(max_z / block_size))

	# Gera novos blocos
	for x in range(start_x, end_x + 1):
		for z in range(start_z, end_z + 1):
			var key = Vector2i(x, z)
			if not generated_blocks.has(key):
				_generate_block_at(key)

	# Limpa blocos fora da área visível + margem
	var margin := 2  # margem extra além da tela
	var blocks_to_remove := []

	for key in generated_blocks:
		var bx = key.x * block_size
		var bz = key.y * block_size

		if bx < (min_x - margin) or bx > (max_x + margin) or bz < (min_z - margin) or bz > (max_z + margin):
			blocks_to_remove.append(key)

	for key in blocks_to_remove:
		generated_blocks[key].queue_free()
		generated_blocks.erase(key)

func _generate_block_at(block_coords: Vector2i):
	var block = block_scene.instantiate()
	var pos = Vector3(
		block_coords.x * block_size,
		0,
		block_coords.y * block_size
	)
	block.global_position = pos
	add_child(block)
	generated_blocks[block_coords] = block
