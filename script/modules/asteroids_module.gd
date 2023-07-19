extends "res://script/modules/module.gd"


func _ready():
	$Sprite3D.texture.region = Rect2(0, randi_range(0, 3) * 16, 16, 16)


func _process(delta):
	pass


func is_solved() -> bool:
	return $Asteroids.is_solved()
