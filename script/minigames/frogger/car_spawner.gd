extends Node2D

const car = preload("res://scenes/minigames/frogger/car.tscn")

@export var flip_direction = false
@onready var frogger = get_parent().get_parent()

func _ready():
	pass # Replace with function body.


func reset() -> void:
	for i in range(2):
		var car_instance = car.instantiate()
		frogger.get_node("Cars").add_child(car_instance)
		car_instance.position = position
		car_instance.position.x = randf_range(32, get_viewport_rect().size.x - 32)
		if flip_direction:
			car_instance.speed *= -1
			car_instance.get_node("Sprite2D").flip_h = true


func _process(delta):
	pass


func _on_timer_timeout() -> void:
	if frogger.solved:
		return
	
	var car_instance = car.instantiate()
	frogger.get_node("Cars").add_child(car_instance)
	car_instance.position = position
	if flip_direction:
		car_instance.speed *= -1
		car_instance.get_node("Sprite2D").flip_h = true

	$Timer.stop()
	$Timer.start(randf_range(1.5, 3))
