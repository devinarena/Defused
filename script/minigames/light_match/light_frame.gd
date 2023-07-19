extends Node2D

@onready var light = $Light
@onready var point_light = $PointLight2D

var on: bool = false

func _ready():
	pass # Replace with function body.


func toggle() -> void:
	if not on:
		light.show()
		point_light.show()
	else:
		light.hide()
		point_light.hide()

	on = not on		

func _process(delta):
	pass
