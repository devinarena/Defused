extends Camera3D

@onready var game = get_parent()

var shake: float = 0.0	

func _ready():
	pass # Replace with function body.


func _process(delta):
	if shake > 0:
		h_offset = randf_range(-shake, shake)
		v_offset = randf_range(-shake, shake)
		shake -= delta / 4
		print(shake)
	else:
		h_offset = 0
		v_offset = 0
	
	if game.time_left == 0:
		$Fade.color.a = min(1.0, $Fade.color.a + delta * 2)
		print($Fade.color.a)
