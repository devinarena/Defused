extends Area2D

func _ready():
	pass


func _process(delta):
	pass


func _on_body_entered(body:Node2D) -> void:
	if body is GolfBall:
		body.sink()
