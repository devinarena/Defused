extends Node2D

const enemy = preload("res://scenes/minigames/dodge/enemy.tscn")

@export var num_enemies = 10

@onready var player = $Player
@onready var enemies = $Enemies


var dragging: bool = false
var solved: bool = false


func _ready():
	reset()
	
	set_process_mode(PROCESS_MODE_DISABLED)


func reset() -> void:
	dragging = false
	player.reset()

	for enemy in enemies.get_children():
		enemy.call_deferred("queue_free")
	
	for i in range(num_enemies):
		var e = enemy.instantiate()
		enemies.call_deferred("add_child", e)
		e.position = Vector2(randi_range(32, get_viewport_rect().size.x - 64), -randi_range(128, 2 * get_viewport_rect().size.y))
	
	$Goal.position = Vector2(randi_range(64, get_viewport_rect().size.x - 128), -get_viewport_rect().size.y * 2 - 64)

func solve() -> void:
	solved = true
	$SolvedIndicator.play("solved")


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		dragging = event.pressed
	
	if dragging:
		if event is InputEventScreenDrag:
			player.target_pos = event.position


func _process(delta):
	pass
