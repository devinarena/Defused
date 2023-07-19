extends Area2D

const MOVE_SNAP: int = 32

@onready var frogger = get_parent()

var start_pos: Vector2

func _ready() -> void:
	start_pos = position


func reset() -> void:
	position = start_pos


func move_left() -> void:
	if position.x > 16:
		position.x -= MOVE_SNAP


func move_right() -> void:
	if position.x < get_viewport_rect().size.x - 16:
		position.x += MOVE_SNAP


func move_up() -> void:
	if position.y > 16:
		position.y -= MOVE_SNAP


func move_down() -> void:
	if position.y < get_viewport_rect().size.y - 16:
		position.y += MOVE_SNAP


func _process(delta) -> void:
	pass


func _on_area_entered(area:Area2D) -> void:
	if area is Car:
		frogger.reset()
	elif "Egg" in area.name:
		frogger.win()