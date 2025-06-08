extends CharacterBody3D

@export var speed: float = 20.0
var direction := Vector3.ZERO

func _ready():
	$AnimatedSprite3D.play("shoot")

func initialize(dir: Vector3):
	direction = dir.normalized()

	var sprite = $AnimatedSprite3D
	if sprite:
		var angle_y = atan2(direction.x, direction.z)
		sprite.rotation_degrees = Vector3(0, rad_to_deg(angle_y), 0)

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()

	# Destruir quando sair da tela
	var cam = get_viewport().get_camera_3d()
	if cam:
		var screen_pos = cam.unproject_position(global_position)
		var screen_size = get_viewport().size
		if screen_pos.x < -100 or screen_pos.x > screen_size.x + 100 or screen_pos.y < -100 or screen_pos.y > screen_size.y + 100:
			queue_free()
