extends Area3D

signal enter_minigame(minigame: String)

@onready var game = get_tree().root.get_node("Game")

var wires_module: bool = false
var num_wires: int = 3


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_wires_module_input_event(camera:Node, event:InputEvent, position:Vector3, normal:Vector3, shape_idx:int) -> void:
	if event is InputEventScreenTouch and event.pressed:
		enter_minigame.emit("wires")


func _on_debug_module_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventScreenTouch and event.pressed:
		enter_minigame.emit("debug")
