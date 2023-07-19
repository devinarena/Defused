extends Area3D

@onready var game = get_tree().root.get_node("Game")
@onready var password_lbl = $PasskeyMesh/Password
@onready var mod_lights = $ModuleLights

var wires_module: bool = false
var num_wires: int = 3
var password = 0

func _ready():
	password = randi_range(1000, 9999)

	var light_colors = [Color.RED, Color.GREEN, Color.BLUE, Color.ORANGE_RED, Color.YELLOW, Color.PURPLE, Color.DARK_GOLDENROD, Color.PINK]

	for light in mod_lights.get_children():
		var col = light_colors.pop_at(randi() % light_colors.size())
		light.set_color(col)



func show_passkey() -> void:
	password_lbl.text = "Passkey: %s" % password


func turn_off_light(index: int) -> void:
	mod_lights.get_child(index).turn_off()


func _process(delta):
	pass
