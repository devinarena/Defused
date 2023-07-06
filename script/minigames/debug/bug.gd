extends Area2D

var hitpoints: int = 5

@onready var debug = get_parent().get_parent()
@onready var hp_bar = $HealthBar

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_input_event(viewport:Node, event:InputEvent, shape_idx:int):
	if event is InputEventScreenTouch:
		if event.pressed:
			hitpoints -= 1
			hp_bar.update()
			if hitpoints <= 0:
				#fix this
				debug.bug_exited()
				call_deferred("queue_free")