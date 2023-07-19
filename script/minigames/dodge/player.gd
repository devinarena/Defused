extends Area2D

@onready var dodge = get_parent()

const SPEED: float = 250.0

var target_pos: Vector2
var start: Vector2


func _ready():
	start = position


func reset() -> void:
	position = start

func _process(delta):
	pass


func _physics_process(delta) -> void:
	# move toward target_pos
	if position.distance_squared_to(target_pos) > pow(SPEED * delta, 2):
		var velocity = (target_pos - position).normalized() * SPEED
		position += velocity * delta

func _on_area_entered(area:Area2D):
	if area is Enemy:
		dodge.reset()
	
	if area is Goal:
		dodge.solve()
