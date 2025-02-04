extends CanvasLayer

var time_since_last_shot = 0.0
var fire_rate = 1.0
var can_shoot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)
	$AnimatedSprite2D.play(Global.current_weapon + "_i")
	$Crosshair.play("default")
	$Music.play(0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_last_shot += delta
	can_shoot = time_since_last_shot >= (1.0 / fire_rate)

	# Handle "Out of Ammo"
	if Global.current_weapon != "knife" and Global.ammo <= 0:
		Global.current_weapon = "knife"
		Global.ammo = 0
		$AnimatedSprite2D.play("knife_i")

	# Handle Weapon Selection
	if Input.is_action_just_pressed("ws_1"):
		Global.current_weapon = "knife"
		$AnimatedSprite2D.play("knife_i")
	elif Input.is_action_just_pressed("ws_2"):
		Global.current_weapon = "pistol"
		$AnimatedSprite2D.play("pistol_i")
	elif Input.is_action_just_pressed("ws_3"):
		Global.current_weapon = "mgun"
		$AnimatedSprite2D.play("mgun_i")
	elif Input.is_action_just_pressed("ws_4"):
		Global.current_weapon = "bgun"
		$AnimatedSprite2D.play("bgun_i")

	# Handle Firing
	if Input.is_action_pressed("shoot") and can_shoot:
		time_since_last_shot = 0.0
		if Global.current_weapon != "knife":
			$Gun.play(0.0)
			$AnimatedSprite2D.play(Global.current_weapon + "_f")
		else:
			$Knife.play(0.0)
			$AnimatedSprite2D.play("knife_f")
		
		if Global.current_weapon != "knife":
			if Global.ammo > 0:
				Global.ammo -= 1

	# Handle Fire Rate
	match Global.current_weapon:
		"pistol":
			fire_rate = 2
		"mgun":
			fire_rate = 4
		"bgun":
			fire_rate = 500
		"knife":
			fire_rate = 1

func _on_AnimatedSprite2D_animation_finished():
	if Global.current_weapon == "knife":
		$AnimatedSprite2D.play("knife_i")
	elif Global.current_weapon == "pistol":
		$AnimatedSprite2D.play("pistol_i")
	elif Global.current_weapon == "mgun":
		$AnimatedSprite2D.play("mgun_i")
	elif Global.current_weapon == "bgun":
		$AnimatedSprite2D.play("bgun_i")

func hitmarker():
	$Crosshair.play("hit")
	await $Crosshair.animation_finished
	$Crosshair.play("default")
