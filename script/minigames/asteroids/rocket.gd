extends Area2D

class_name Rocket


const SPEED = 300.0


var velocity: Vector2


func _ready():
	pass


func die() -> void:
	call_deferred("queue_free")


func target(target_pos: Vector2) -> void:
	velocity = (target_pos - position).normalized() * SPEED
	rotation = velocity.angle() + PI / 2


func _process(delta):
	if position.y < -32:
		die()


func _physics_process(delta):
	position += velocity * delta