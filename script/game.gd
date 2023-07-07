extends Node

const minigames = {
	"wires": "Bomb/Modules/WiresModule/Wires",
	"debug": "Bomb/Modules/DebugModule/Debug",
	"passkey": "Bomb/Modules/PasskeyModule/Passkey",
}

@onready var bomb = $Bomb
@onready var timer_label = $GUI/MarginContainer/Timer
@onready var solved_label = $GUI/MarginContainer/Solved
@onready var minigame_container = $GUI/MarginContainer/MinigameContainer
@onready var camera = $Camera3D
@onready var environment = $WorldEnvironment
@onready var win_dialog = $GUI/MarginContainer/WinDialog
@onready var time_lbl = win_dialog.get_node("MarginContainer/VBoxContainer/Time")
@onready var timer = $SecondsTimer

#var sky_color_start = Color(67 / 255, 90 / 255, 117 / 255, 1)
var sky_color_start = Color(0.1, 0.2, 0.35, 1)
# var sky_color_end = Color(61 / 255, 28 / 255, 28 / 255, 1)
var sky_color_end = Color(0.2, 0.08, 0.08, 1)

var start_time: int = 60
var time_left: int = 60
var modules: int = 0

const DRAG_CUTOFF: int = 85
var drag_time: float = 0
var ray_origin: Vector3
var ray_end: Vector3
var drag_origin: Vector2
var minigame_module: Node

func _ready():
	modules = bomb.get_node("Modules").get_child_count()

	environment.environment.background_color = lerp(sky_color_end, sky_color_start, float(time_left) / start_time)


func _process(delta):
	pass

func _physics_process(delta):
	if ray_origin != Vector3.ZERO and ray_end != Vector3.ZERO:
		var space_state = camera.get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		query.collide_with_areas = true

		var result = space_state.intersect_ray(query)

		if result:
			if result.collider is Module:
				start_minigame(minigames[result.collider.module_name])
		
		ray_origin = Vector3.ZERO
		ray_end = Vector3.ZERO

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
		if not event.pressed:
			if Time.get_ticks_msec() - drag_time < DRAG_CUTOFF or drag_origin.distance_squared_to(event.position) < 10:
				var mouse_pos = minigame_container.get_global_mouse_position()
				
				ray_origin = camera.project_ray_origin(mouse_pos)
				ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 1000
			drag_time = 0
		elif not drag_time:
			drag_time = Time.get_ticks_msec()
			drag_origin = event.position
	elif event is InputEventScreenDrag:
		if Time.get_ticks_msec() - drag_time  >= DRAG_CUTOFF:
			bomb.rotate_y(deg_to_rad(event.relative.x))
			bomb.rotate_x(deg_to_rad(event.relative.y))


func _on_seconds_timer_timeout() -> void:
	time_left -= 1
	var time_str = ""
	var mins: int = int(float(time_left) / 60.0)
	var secs: int = time_left - mins * 60
	time_str += "%d:%02d" % [mins, secs]

	timer_label.text = time_str

	environment.environment.background_color = lerp(sky_color_end, sky_color_start, float(time_left) / start_time)


func _on_back_to_bomb_pressed() -> void:
	var minigame_node = minigame_container.get_children().back()
	minigame_container.hide()
	minigame_node.hide()
	minigame_container.remove_child(minigame_node)
	minigame_module.add_child(minigame_node)

	var solved = 0
	var idx = 0

	for node in bomb.get_node("Modules").get_children():
		if node.is_solved():
			solved += 1
			bomb.turn_off_light(idx)
		idx += 1
	
	solved_label.text = "Modules Solved: %d/%d" % [solved, modules]

	if solved >= modules / 2:
		bomb.show_passkey()
	
	if solved == modules:
		timer.stop()
		show_win_dialog()


func _on_play_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
