extends CharacterBody3D

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")

@export var SPEED = 5.0
@export var attack_range = 5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dead = false
var is_attacking = false

func _ready():
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	
	if dead or is_attacking:
		return

	if player == null:
		return

	# Direction to player
	var dir = player.global_position - global_position
	var dist_to_player = global_position.distance_to(player.global_position)
	dir.y = 0.0
	dir = dir.normalized()
	
	# Walking
	velocity = dir * SPEED
	
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Determine walk/attack behaviour
	if not is_attacking and dist_to_player > attack_range:
		$AnimatedSprite3D.play("default")
		move_and_slide()
	else:
		attack()

func attack():
	is_attacking = true
	$AnimatedSprite3D.play("shoot")
	Global.health -= 6
	await $AnimatedSprite3D.animation_finished
	is_attacking = false

func die():
	dead = true
	$CollisionShape3D.disabled = true
	$Death.play(0.0)
	$AnimatedSprite3D.play("die")
