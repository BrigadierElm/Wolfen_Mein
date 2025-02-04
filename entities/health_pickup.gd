extends Area3D

var time: float = 0.0
var amplitude: float = 0.25	# Control Height
var speed: float = 2.0
var start_pos: Vector3
var offset: float = 0.5

@onready var bottle_mesh: MeshInstance3D = $BottleMesh

func _ready():
	start_pos = position
	start_pos[1] += offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	bottle_mesh.position.y = start_pos[1] + sin(time * speed) * amplitude
	bottle_mesh.rotation.y += 0.02

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$BottleColl.disabled
		$BottleMesh.hide()
		Global.health += 25
		$AudioStreamPlayer.play(0)
		await  $AudioStreamPlayer.finished
		queue_free()
