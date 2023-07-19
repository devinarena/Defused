extends Area2D

class_name Goal

var velocity: Vector2 = Vector2(0, 200)


func _ready():
	pass


func _process(delta):
	if position.y > get_viewport_rect().size.y / 2:
		velocity = Vector2.ZERO


func _physics_process(delta):
	position += velocity * delta