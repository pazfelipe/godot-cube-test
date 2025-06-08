extends MeshInstance3D

@onready var cam = $"../Camera3D"

func _process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("ui_up"):
		# Direção para frente da câmera (ignorando o eixo Y)
		var forward = -cam.global_transform.basis.z
		forward.y = 0
		direction += forward
		
	if Input.is_action_pressed("ui_down"):
		var backward = cam.global_transform.basis.z
		backward.y = 0
		direction += backward
		
	if Input.is_action_pressed("ui_right"):
		var right = cam.global_transform.basis.x
		right.y = 0
		direction += right
		
	if Input.is_action_pressed("ui_left"):
		var left = -cam.global_transform.basis.x
		left.y = 0
		direction += left

	position += direction.normalized() * 2.0 * delta
	position.x = clamp(position.x, -10, 10)
	position.z = clamp(position.z, -10, 10)
