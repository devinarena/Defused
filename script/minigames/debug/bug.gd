extends Area2D

@export var hitpoints: int = 5
@export var move: bool = true

var target_pos = Vector2.ZERO
var velocity: Vector2

@onready var debug = get_parent().get_parent()
@onready var hp_bar = $HealthBar
@onready var move_timer = $MoveTimer

func _ready():
	rotation = 2 * randf() * PI


func _process(delta):
	if move:
		if target_pos == Vector2.ZERO:
			target_pos = Vector2(randi_range(32, get_viewport_rect().size.x - 64), randi_range(32, get_viewport_rect().size.y - 128))

func _physics_process(delta):
	if move:
		if target_pos != Vector2.ZERO:
			if position.distance_squared_to(target_pos) > 10:
				velocity = (target_pos - position).normalized() * 100
				position += velocity * delta
				rotation = lerp_angle(rotation, velocity.angle() + PI / 2, 0.1)
			else:
				move = false
				move_timer.start()
				await move_timer.timeout
				target_pos = Vector2.ZERO
				move = true

func _on_input_event(viewport:Node, event:InputEvent, shape_idx:int):
	if event is InputEventScreenTouch:
		if event.pressed:
			hitpoints -= 1
			hp_bar.update()
			if hitpoints <= 0:
				#fix this
				debug.bug_exited()
				call_deferred("queue_free")
