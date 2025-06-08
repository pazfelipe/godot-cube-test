extends CharacterBody3D

@export var speed: float = 20.0
var direction := Vector3.ZERO

func _ready():
	direction = -global_transform.basis.z.normalized()
	velocity = direction * speed

func _physics_process(delta):
	move_and_slide()
	
	# Auto-destruir fora da tela
	var cam = get_viewport().get_camera_3d()
	if cam:
		var screen_pos = cam.unproject_position(global_position)
		var screen_size = get_viewport().size
		if screen_pos.x < -100 or screen_pos.x > screen_size.x + 100 or screen_pos.y < -100 or screen_pos.y > screen_size.y + 100:
			queue_free()
