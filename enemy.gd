extends CharacterBody3D

@export var speed := 2.0
var target: Node3D

func _ready():
	# Procura o personagem (ajuste o caminho se necessário)
	target = get_parent().get_node_or_null("char")

func _physics_process(delta):
	if target == null:
		return

	var direction = (target.global_position - global_position)
	direction.y = 0  # ignora diferença de altura
	direction = direction.normalized()

	velocity = direction * speed
	move_and_slide()
