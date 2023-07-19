extends Node2D


@onready var course = $Course
@onready var ball = course.get_node("GolfBall")

var strokes: int = 0

func _ready() -> void:
	pass # Replace with function body.


func _process(delta) -> void:
	pass


func is_solved() -> bool:
	return ball.sinking


func add_stroke() -> void:
	strokes += 1
	$Label.text = "Golf!\nStrokes: %s" % [strokes]	