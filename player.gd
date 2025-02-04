class_name Player extends CharacterBody3D

@export var SPEED := 5.0
enum CAMERA_CONTROL {MOUSE, KEYBOARD}
@export var CAMERA_TYPE = CAMERA_CONTROL.MOUSE
@export var TURN_SENSITIVITY := 0.05
var rot_x : float
var rot_y : float
@export var MOUSE_SENSITIVITY := 0.0125

@onready var ui_script = $ui
@onready var ray = $Camera3D/RayCast3D
@onready var camera: Camera3D = $Camera

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_captured: bool = false
var look_dir: Vector2 # Input direction for look/aim

func _ready():
	if CAMERA_TYPE == CAMERA_CONTROL.MOUSE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and CAMERA_TYPE == CAMERA_CONTROL.MOUSE:
		# Modify accumulated mouse rotation
		rot_x += -event.relative.x * MOUSE_SENSITIVITY
		rot_y += -event.relative.y * MOUSE_SENSITIVITY / 2.33
		transform.basis = Basis()	# Reset rotation
		rotate_object_local(Vector3(0,1,0), rot_x)
		rotate_object_local(Vector3(1,0,0), rot_y)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var mouse_look: Vector2
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_pressed("move_turn_left") and CAMERA_TYPE == CAMERA_CONTROL.KEYBOARD:
		self.rotate_y(TURN_SENSITIVITY)
	if Input.is_action_pressed("move_turn_right") and CAMERA_TYPE == CAMERA_CONTROL.KEYBOARD:
		self.rotate_y(-TURN_SENSITIVITY)
	if Input.is_action_pressed("shoot"):
		if ui_script.can_shoot:
			shoot()

	move_and_slide()

func shoot():
	if ray.is_colliding() and ray.get_collider().has_method("die"):
		ray.get_collider().die()
		ray.add_exception(ray.get_collider())
