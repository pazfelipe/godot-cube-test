extends Camera3D

@export var target: Node3D
@export var offset: Vector3 = Vector3(0, 10, 10)
@export var follow_speed: float = 5.0
@export var zoom_min: float = 4.0
@export var zoom_max: float = 8.0
@export var zoom_speed: float = 1.0

func _process(delta):
	# Seguir o personagem
	if target:
		var desired_position = target.global_transform.origin + offset
		global_transform.origin = global_transform.origin.lerp(desired_position, follow_speed * delta)
		look_at(target.global_transform.origin, Vector3.UP)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			size = max(zoom_min, size - zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			size = min(zoom_max, size + zoom_speed)
