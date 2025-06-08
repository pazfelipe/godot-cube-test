extends Node3D

@export var char: Node3D
@export var block_scene: PackedScene
@export var block_size: float = 0.2
@export var view_distance: int = 5

var generated_blocks := {}

func _ready():
	update_ground()

func _process(_delta):
	update_ground()

func update_ground():
	if char == null:
		return

	var char_block = Vector2i(
		int(char.global_transform.origin.x / block_size),
		int(char.global_transform.origin.z / block_size)
	)
	
	print("char_block:", char_block)

	for x in range(char_block.x - view_distance, char_block.x + view_distance + 1):
		for z in range(char_block.y - view_distance, char_block.y + view_distance + 1):
			var key = Vector2i(x, z)
			if not generated_blocks.has(key):
				print("Instanciando bloco em:", key)
				_generate_block_at(key)
				
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return

	var blocks_to_remove := []

	for key in generated_blocks:
		var block = generated_blocks[key]
		var block_pos = block.global_transform.origin

		# Verifica se o bloco está visível na câmera
		if not camera.is_position_in_frustum(block_pos):
			blocks_to_remove.append(key)

	# Remove os blocos fora da visão da câmera
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
	var collider = block.find_child("CollisionShape3D")
	var has_shape = collider != null and collider.shape != null
	print("Bloco tem colisor válido?", has_shape)
	
