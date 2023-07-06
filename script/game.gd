extends Node

const minigames = {
	"wires": "Bomb/Modules/WiresModule/Wires",
	"debug": "Bomb/Modules/DebugModule/Debug"
}

@onready var bomb = $Bomb
@onready var timer_label = $GUI/MarginContainer/Timer
@onready var solved_label = $GUI/MarginContainer/Solved
@onready var minigame_container = $GUI/MarginContainer/MinigameContainer
@onready var camera = $Camera3D
@onready var win_dialog = $GUI/MarginContainer/WinDialog
@onready var time_lbl = win_dialog.get_node("MarginContainer/VBoxContainer/Time")
@onready var timer = $SecondsTimer

var sky_color_start = Color(0.08, 0.22, 0.48, 1)
var sky_color_end = Color(0.4, 0.08, 0.12)

var start_time: int = 60
var time_left: int = 60
var modules: int = 0

var dragging: bool = false
var minigame_module: Node

func _ready():
	modules = bomb.get_node("Modules").get_child_count()

func _process(delta):
	pass


func start_minigame(path: String) -> void:
	if minigame_container.visible:
		return
		
	minigame_container.show()
	var minigame_node = get_node(path)
	minigame_module = minigame_node.get_parent()
	minigame_module.remove_child(minigame_node)
	minigame_container.add_child(minigame_node)
	minigame_node.global_position = Vector2(0, 8)
	minigame_node.show()


func show_win_dialog() -> void:
	get_tree().paused = true
	win_dialog.show()
	time_lbl.text = "Time: %s seconds" % [start_time - time_left]


func _unhandled_input(event: InputEvent) -> void:
	if minigame_container.visible:
		return

	if event is InputEventScreenTouch:
		dragging = event.pressed
	elif event is InputEventScreenDrag:
		if dragging:
			bomb.rotate_y(deg_to_rad(event.relative.x))
			bomb.rotate_x(deg_to_rad(event.relative.y))


func _on_seconds_timer_timeout() -> void:
	time_left -= 1
	var time_str = ""
	var mins: int = int(float(time_left) / 60.0)
	var secs: int = time_left - mins * 60
	time_str += "%d:%02d" % [mins, secs]

	timer_label.text = time_str

	camera.environment.sky.sky_material.sky_top_color = lerp(sky_color_end, sky_color_start, float(time_left) / start_time)


func _on_bomb_enter_minigame(minigame: String) -> void:
	start_minigame(minigames[minigame])


func _on_back_to_bomb_pressed() -> void:
	var minigame_node = minigame_container.get_children().back()
	minigame_container.hide()
	minigame_node.hide()
	minigame_container.remove_child(minigame_node)
	minigame_module.add_child(minigame_node)

	var solved = 0

	for node in bomb.get_node("Modules").get_children():
		print(node.is_solved())
		if node.is_solved():
			solved += 1
	
	solved_label.text = "Modules Solved: %d/%d" % [solved, modules]
	
	if solved == modules:
		timer.stop()
		show_win_dialog()


func _on_play_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
