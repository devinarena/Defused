extends Node2D

const asteroid = preload("res://scenes/minigames/asteroids/asteroid.tscn")
const bullet_tex = preload("res://scenes/minigames/asteroids/bullet_texture.tscn")
const rocket = preload("res://scenes/minigames/asteroids/rocket.tscn")

@export var num_asteroids: int = 0

@onready var asteroids = $Asteroids
@onready var bullet_indicator = $BulletIndicator
@onready var rockets = $Rockets
@onready var ship = $Ship
@onready var retry_msg = $RetryMessage

var bullets: int

func _ready():
	spawn_asteroids()

	set_process_mode(PROCESS_MODE_DISABLED)


func spawn_asteroids() -> void:
	bullets = num_asteroids

	for i in range(bullets - bullet_indicator.get_child_count()):
		var bullet = bullet_tex.instantiate()
		bullet_indicator.add_child(bullet)

	for i in range(num_asteroids):
		var child = asteroid.instantiate()
		asteroids.add_child(child)
		var x = randi_range(32, get_viewport_rect().size.x - 64)
		var y = -randi_range(32, get_viewport_rect().size.y - 128)
		child.position = Vector2(x, y)


func lose() -> void:
	retry_msg.show()
	for rocket in rockets.get_children():
		rocket.queue_free()
	for asteroid in asteroids.get_children():
		asteroid.queue_free()
	$SolvedIndicator.play("unsolved")


func _process(delta):
	for asteroid in asteroids.get_children():
		if asteroid.position.y > get_viewport_rect().size.y:
			lose()
			break


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if bullets > 0:
				var r = rocket.instantiate()
				rockets.add_child(r)
				r.position = ship.position
				r.target(event.position)
				bullets -= 1
				bullet_indicator.get_child(bullets).queue_free()


func asteroid_destroyed() -> void:
	$SolvedIndicator.play("solved")

	var count: int = 0
	for asteroid in asteroids.get_children():
		if asteroid is Asteroid:
			count += 1
	
	if count > 1:
		$SolvedIndicator.play("in_progress")


func is_solved() -> bool:
	return not retry_msg.visible and asteroids.get_child_count() == 0


func _on_retry_button_pressed() -> void:
	retry_msg.hide()
	spawn_asteroids()
