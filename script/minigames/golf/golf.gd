extends Node2D

const courses = [preload("res://scenes/minigames/golf/course_1.tscn"), 
				preload("res://scenes/minigames/golf/course_2.tscn")]

var course
var ball 

var strokes: int = 0

func _ready() -> void:
	var template = courses[randi() % courses.size()]
	course = template.instantiate()
	add_child(course)
	course.name = "Course"
	ball = course.get_node("GolfBall")

func _process(delta) -> void:
	pass


func is_solved() -> bool:
	return ball.sinking


func add_stroke() -> void:
	strokes += 1
	$Label.text = "Golf!\nStrokes: %s" % [strokes]	
