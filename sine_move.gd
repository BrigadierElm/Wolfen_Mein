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


func _on_area_entered(area: Area3D) -> void:
	
	pass # Replace with function body.
