extends Node2D

@onready var inputs = $Inputs
@onready var outputs = $Outputs
@onready var wire_grab = $WireGrab
@onready var indicator = $SolvedIndicator
@onready var label = $RichTextLabel

var prompts = {
	"big": "small",
	"mean": "nice",
	"hot": "cold",
	"fast": "slow",
	"tall": "short",
	"long": "short",
	"heavy": "light",
	"hard": "soft",
	"high": "low",
	"up": "down",
	"left": "right",
	"front": "back",
	"first": "last",
	"new": "old",
	"young": "old",
	"good": "bad",
	"right": "wrong",
	"true": "false",
	"yes": "no",
	"on": "off",
	"open": "closed",
}

var selected_wire: Node
var solved: bool = false
var mode: String = "OPPOSITES"

func _ready():
	var colors = []

	if randf() < 0.5:
		mode = "COLORS"
	
	label.text = "[center]Match all the wires by their [b]%s[/b].[/center]" % mode

	for i in range(inputs.get_child_count()):
		colors.push_back(Color(randf_range(0.25, 0.75), randf_range(0.25, 0.75), randf_range(0.25, 0.75), 1.0))
	
	for i in range(colors.size()):		
		inputs.get_children()[i].set_color(colors[i])
		outputs.get_children()[i].set_color(colors[i])
	
	for i in range(20):
		var i1 = inputs.get_children()[randi() % inputs.get_child_count()]
		var i2 = inputs.get_children()[randi() % inputs.get_child_count()]
		var temp = i1.position
		i1.position = i2.position
		i2.position = temp
		
		var o1 = outputs.get_children()[randi() % outputs.get_child_count()]
		var o2 = outputs.get_children()[randi() % outputs.get_child_count()]
		temp = o1.position
		o1.position = o2.position
		o2.position = temp
	
	var available = []
	for node in outputs.get_children():
		available.push_back(node)
	
	var questions = []
	for prompt in prompts:
		questions.push_back(prompt)
	
	for node in inputs.get_children():
		var partner = available[randi() % available.size()]
		available.erase(partner)
		var question = questions[randi() % questions.size()]
		node.set_prompt(question)
		node.input_event.connect(_on_wire_input.bind(node))
		partner.set_prompt(prompts[question])
	
	for node in outputs.get_children():
		node.input_event.connect(_on_wire_input.bind(node))

	
	set_process_mode(PROCESS_MODE_DISABLED)


func check_solved() -> void:
	var good = 0
	for node in inputs.get_children():
		if node.solved():
			good += 1
	
	if good == inputs.get_child_count():
		indicator.play("solved")
		solved = true
	elif good > 0:
		indicator.play("in_progress")
	else:
		indicator.play("unsolved")


func _on_wire_input(viewport:Node, event:InputEvent, shape_idx:int, node: Node) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if not node.solved():
				selected_wire = node
				selected_wire.selected = true


func _input(event):
	if event is InputEventScreenDrag:
		if selected_wire != null:
			wire_grab.position = event.position


func _unhandled_input(event: InputEvent):
	if event is InputEventScreenTouch:
		if not event.pressed:
			if selected_wire:
				for area in wire_grab.get_overlapping_areas():
					if area is Wire:
						if selected_wire == area:
							break
						
						var solved: bool = false
						
						if mode == "COLORS":
							if selected_wire.color == area.color:
								solved = true
						else:
							if not selected_wire.prompt in prompts:
								if prompts[area.prompt] == selected_wire.prompt:
									solved = true
							elif prompts[selected_wire.prompt] == area.prompt:
								solved = true
						
						if solved:
							selected_wire.set_solved_pos(area.global_position)
							area.set_solved_pos(selected_wire.global_position)
							selected_wire.breakage.hide()
							area.breakage.hide()
							check_solved()
							break
						
				selected_wire.selected = false
				selected_wire.queue_redraw()
				selected_wire = null


func _process(delta):
	pass
