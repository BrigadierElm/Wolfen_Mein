extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.health > 0:
		$".".text = str(Global.health)
	else:
		$".".text = "KIA"
