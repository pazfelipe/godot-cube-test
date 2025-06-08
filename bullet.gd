extends CharacterBody3D

@export var speed: float = 2.0
var direction := Vector3.ZERO

func _ready():
	direction = -transform.basis.z.normalized()
	velocity = direction * speed

func _physics_process(delta):
	#move_and_slide()

	# Destroi fora da tela
	var camera = get_viewport().get_camera_3d()
	#if camera:
		#var screen_pos = camera.unproject_position(global_position)
		#var size = get_viewport().size
		#if screen_pos.x < 0 or screen_pos.x > size.x or screen_pos.y < 0 or screen_pos.y > size.y:
			#queue_free()
