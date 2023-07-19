extends Area2D

class_name Car

var speed: int

func _ready():
	speed = randi_range(100, 150)

	$Sprite2D.texture = $Sprite2D.texture.duplicate()
	$Sprite2D.texture.region = Rect2(0, randi_range(0, 1) * 16, 16, 16)

	$Sprite2D.modulate = Color(randf(), randf(), randf(), 1)


func _process(delta) -> void:
	if position.x < -100:
		queue_free()
	elif position.x > get_viewport_rect().size.x + 100:
		queue_free()


func _physics_process(delta) -> void:
	position.x += speed * delta
