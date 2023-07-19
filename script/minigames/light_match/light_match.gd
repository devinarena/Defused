extends Node2D

@onready var guide = $Guide
@onready var lights = $Lights
@onready var switches = $Switches

var solved: bool = false

func _ready():
	for light in guide.get_children():
		if randf() < 0.5:
			light.toggle()

	var idx = 0
	for switch in switches.get_children():
		switch.input_event.connect(_switch_pressed.bind(idx))
		idx += 1

	set_process_mode(PROCESS_MODE_DISABLED)


func check_win() -> void:
	var idx = 0
	for light in lights.get_children():
		if light.on != guide.get_child(idx).on:
			$SolvedIndicator.play("in_progress")
			return
		idx += 1

	solved = true
	$SolvedIndicator.play("solved")

func _switch_pressed(viewport:Node, event:InputEvent, shape_idx:int, idx: int) -> void:
	if not event is InputEventScreenTouch or not event.pressed or solved:
		return

	var light = lights.get_child(idx)
	
	if light.on:
		switches.get_child(idx).get_node("Sprite2D").play("off")
	else:
		switches.get_child(idx).get_node("Sprite2D").play("on")
	
	light.toggle()

	check_win()


func _process(delta):
	pass
