extends Node2D

@onready var bomb = get_tree().root.get_node("Game/Bomb")
@onready var answer_lbl = $PanelContainer/MarginContainer/Answer
@onready var button_sound = $ButtonSound
var btns

var password: String = ""
var solved: bool = false

func scramble_buttons() -> void:
	for i in range(100):
		var a = randi() % 12
		var b = randi() % 12
		var tmp = btns.get_child(a).text
		btns.get_child(a).text = btns.get_child(b).text
		btns.get_child(b).text = tmp

func _ready():
	btns = $Buttons
	
	scramble_buttons()

	for button in btns.get_children():
		button.pressed.connect(_on_button_pressed.bind(button.text))
	
	set_process_mode(PROCESS_MODE_DISABLED)



func _process(delta):
	pass

func _on_button_pressed(button):
	if solved:
		return

	password += button
	answer_lbl.text += "* "

	$SolvedIndicator.play("in_progress")
	button_sound.play()
		
	if password.length() >= 4:
		if password == str(bomb.password):
			answer_lbl.text = "Authorized"
			$SolvedIndicator.play("solved")
			solved = true
		else:
			answer_lbl.text = "Unauthorized"
			$SolvedIndicator.play("unsolved")
			return


func _on_reset_button_pressed():
	if solved:
		return

	answer_lbl.text = ""
	password = ""
	$SolvedIndicator.play("unsolved")
