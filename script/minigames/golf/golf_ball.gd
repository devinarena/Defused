extends RigidBody2D

class_name GolfBall

@onready var game = get_parent().get_parent()

const STRENGTH: float = 0.5

var sinking: bool = false
var pressed: bool = false
var spin: float = 0

func _ready():
	pass  # Replace with function body.


func sink() -> void:
	sinking = true
	game.get_node("SolvedIndicator").play("solved")


func _process(delta):
	if sinking:
		$Sprite2D.scale = lerp($Sprite2D.scale, Vector2.ZERO, 0.05)

	if pressed:
		queue_redraw()


func _physics_process(delta):
	linear_velocity *= 0.98
	if sinking:
		linear_velocity *= 0.9

	$Sprite2D.rotation += spin * delta
	spin = linear_velocity.length() * 0.05



func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if sinking:
		return

	if event is InputEventScreenTouch and event.pressed:
		pressed = true


func _unhandled_input(event) -> void:
	if event is InputEventScreenTouch and not event.pressed and pressed:
		var direction = (global_position - event.position) / STRENGTH
		linear_velocity = direction
		pressed = false
		queue_redraw()
		game.get_node("SolvedIndicator").play("in_progress")
		game.add_stroke()


func _draw():
	var dir = (global_position - get_viewport().get_mouse_position()) / STRENGTH

	if pressed:
		draw_line(
			-dir / 2,
			dir / 2,
			Color(1, 1, 1, 0.5),
			2
		)
