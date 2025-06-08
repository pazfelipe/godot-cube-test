extends CharacterBody3D

@export var speed := 10.0
@export var camera: Camera3D

func _ready():
	global_transform.origin.y = 1.0

func _physics_process(_delta):
	var direction = Vector3.ZERO

	# WASD movimentação tradicional
	if Input.is_action_pressed("ui_up"):
		var forward = -camera.global_transform.basis.z
		forward.y = 0
		direction += forward

	if Input.is_action_pressed("ui_down"):
		var back = camera.global_transform.basis.z
		back.y = 0
		direction += back

	if Input.is_action_pressed("ui_left"):
		var left = -camera.global_transform.basis.x
		left.y = 0
		direction += left

	if Input.is_action_pressed("ui_right"):
		var right = camera.global_transform.basis.x
		right.y = 0
		direction += right

	# 🖱️ Se o botão esquerdo do mouse estiver pressionado
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * 1000

		var space_state = get_world_3d().direct_space_state
		var ray_params = PhysicsRayQueryParameters3D.create(from, to)
		ray_params.exclude = [self]

		var result = space_state.intersect_ray(ray_params)

		if result and result.has("position"):
			var target_pos = result.position
			var move_dir = (target_pos - global_transform.origin)
			move_dir.y = 0
			direction += move_dir.normalized()

	# Aplicar movimento
	var dir = direction.normalized()
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed

	# Adiciona gravidade (ou mantém no chão)
	velocity.y -= 9.8 * _delta  # ou 0 se você quiser fixo
	
	#print("CHAR POS: ", global_transform.origin)

	move_and_slide()
	
	if global_transform.origin.y < -10.0:
		global_transform.origin.y = 1.0
		print("Resetou altura")
