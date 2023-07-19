extends Area2D

class_name Enemy

var velocity: Vector2 = Vector2(0, 0)
var angular_velocity: float = 0.0


func _ready():
	var type = randi() % 4 + 1
	$AnimatedSprite2D.play(str(type))

	match type:
		1:
			velocity = Vector2(0, 200)
		2:
			velocity = Vector2(0, 225)
		3:
			velocity = Vector2(0, 250)
			angular_velocity = (2 * randf() - 1) * PI
		4:
			velocity = Vector2(0, 275)
			angular_velocity = (2 * randf() - 1) * PI



func _process(delta):
	pass


func _physics_process(delta):
	position += velocity * delta
	$AnimatedSprite2D.rotation += angular_velocity * delta