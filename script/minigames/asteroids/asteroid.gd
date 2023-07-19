extends Area2D

class_name Asteroid

const explode = preload("res://scenes/minigames/asteroids/rocket_explosion.tscn")

@onready var asteroids = get_parent().get_parent()

var velocity: Vector2
var angular_velocity: float = 0

func _ready():
	$AnimatedSprite2D.play(str(randi() % 3 + 1))
	velocity = Vector2(0, randi_range(150, 225))
	angular_velocity = randf_range(-PI, PI)


func _process(delta):
	pass


func _physics_process(delta):
	position += velocity * delta
	rotation += angular_velocity * delta


func die():
	var exp = explode.instantiate()
	exp.position = position
	get_parent().add_child(exp)
	call_deferred("queue_free")


func _on_area_entered(area:Area2D) -> void:
	if area is Rocket:
		asteroids.asteroid_destroyed()
		die()
		area.die()
