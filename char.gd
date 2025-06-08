extends CharacterBody3D

@export var speed := 10.0
@export var camera: Camera3D
@export var bullet_scene: PackedScene
@export var shoot_interval := 0.5

var _shoot_timer := 0.0

func _ready():
	global_transform.origin.y = 1.0
	$AnimatedSprite3D.play("idle")
	
func _process(delta):
	_shoot_timer += delta
	if _shoot_timer >= shoot_interval:
		_shoot_timer = 0.0
		_shoot()

func _physics_process(_delta):
	var direction = Vector3.ZERO
	var sprite = $AnimatedSprite3D

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
	
	if direction.length() > 0.01:
		if sprite.animation != "walk":
			sprite.play("walk")
		sprite.speed_scale = 2.5
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
		sprite.speed_scale = 1.5
	
	move_and_slide()
	
		# Girar sprite para a esquerda/direita com base em dir.x
	if dir.x > 0.1:
		$AnimatedSprite3D.scale.x = abs($AnimatedSprite3D.scale.x)  # Direita
	elif dir.x < -0.1:
		$AnimatedSprite3D.scale.x = -abs($AnimatedSprite3D.scale.x)  # Esquerda
	
	if global_transform.origin.y < -10.0:
		global_transform.origin.y = 1.0
		print("Resetou altura")
		
		
		
func _shoot():
	if bullet_scene == null or camera == null:
		return

	var forward = -camera.global_transform.basis.z.normalized()
	
	var spawn_position = global_transform.origin + forward * -0.5
	spawn_position.y = 1.5
	var basis = Basis().looking_at(forward, Vector3.UP)
	var transform = Transform3D(basis, spawn_position)

	var bullet = bullet_scene.instantiate()
	bullet.global_transform = transform
	get_tree().current_scene.add_child(bullet)
	bullet.initialize(forward)  # <-- aqui define a direção após o spawn
