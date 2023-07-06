extends Node2D

const bug = preload("res://scenes/minigames/debug/bug.tscn")

@export var num_bugs: int = 0

@onready var bugs = $Bugs

func _ready():
	for i in range(num_bugs):
		var b = bug.instantiate()
		bugs.add_child(b)
		b.position = Vector2(randi_range(32, get_viewport_rect().size.x - 64), randi_range(32, get_viewport_rect().size.y - 128))


func _process(delta):
	pass


func bug_exited() -> void:
	if bugs.get_child_count() - 1 == 0:
		$SolvedIndicator.play("solved")
	else:
		$SolvedIndicator.play("in_progress")

func is_solved() -> bool:
	return bugs.get_child_count() == 0