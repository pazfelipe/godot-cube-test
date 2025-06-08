extends CharacterBody3D

@export var speed := 2.0
var target: Node3D

func _ready():
	target = get_parent().get_node_or_null("char")
	$AnimatedSprite3D.play("walk")

func _physics_process(delta):
	if target == null:
		return

	var direction = (target.global_position - global_position)
	direction.y = 0
	direction = direction.normalized()

	if direction.x > 0.1:
		$AnimatedSprite3D.scale.x = abs($AnimatedSprite3D.scale.x)
	elif direction.x < -0.1:
		$AnimatedSprite3D.scale.x = -abs($AnimatedSprite3D.scale.x)

	velocity = direction * speed
	move_and_slide()
