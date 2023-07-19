extends Node2D

@onready var chicken = $Chicken
@onready var egg = $Egg
@onready var cars = $Cars
@onready var buttons = $Buttons
@onready var spawners = $Spawners

var solved: bool = false

func _ready() -> void:
	set_process_mode(PROCESS_MODE_DISABLED)

	reset()


func _process(delta) -> void:
	pass

func reset() -> void:
	egg.position.x = randi_range(32, get_viewport_rect().size.x - 32)

	for car in cars.get_children():
		car.queue_free()
	
	# for spawner in spawners.get_children():
	# 	spawner.reset()
	
	chicken.reset()
	$SolvedIndicator.play("unsolved")

func win() -> void:
	for car in cars.get_children():
		car.queue_free()
	
	chicken.position = egg.position - Vector2(32, 0)
	chicken.get_node("PartyHat").show()
	egg.get_node("Balloon").show()

	buttons.hide()

	solved = true
	$SolvedIndicator.play("solved")

func _on_button_down_pressed() -> void:
	$SolvedIndicator.play("in_progress")
	chicken.move_down()

func _on_button_up_pressed() -> void:
	$SolvedIndicator.play("in_progress")
	chicken.move_up()

func _on_button_right_pressed() -> void:
	$SolvedIndicator.play("in_progress")
	chicken.move_right()

func _on_button_left_pressed() -> void:
	$SolvedIndicator.play("in_progress")
	chicken.move_left()

