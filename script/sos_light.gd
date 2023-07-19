extends Node3D

@onready var delay_timer = $DelayTimer
var bulb
var blinking: bool = false

var count = 0

func _ready():
	bulb = $BulbMesh
	bulb.mesh = bulb.mesh.duplicate(true)

	turn_off()

func is_on() -> bool:
	return bulb.mesh.material.emission.r > 0.5


func turn_off() -> void:
	bulb.mesh.material.emission = Color(0, 0, 0, 1)


func turn_on() -> void:
	bulb.mesh.material.emission = Color(1, 0, 0, 1)


func _process(delta):
	pass


func _on_delay_timer_timeout() -> void:

	# if not is_on():
	# 	turn_on()
	# 	delay_timer.start(0.5)
	# else:
	# 	turn_off()
	# 	delay_timer.start(0.5)

	if not is_on():
		turn_on()
		count += 1
		if count <= 3:
			delay_timer.start(0.1)
		elif count >= 4 and count <= 6:
			delay_timer.start(0.3)
		else:
			delay_timer.start(0.1)
	else:
		turn_off()
		if count == 3 or count == 6:
			delay_timer.start(0.3)
		elif count == 9:
			count = 0
			delay_timer.start(1)
		else:
			delay_timer.start(0.1)