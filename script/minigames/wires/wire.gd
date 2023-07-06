extends Area2D

class_name Wire

@export var answer_wire: bool = false
@export var small_text: bool = false
var color: Color = Color.WHITE
var base: Sprite2D
var breakage: Sprite2D 
var prompt: String
var prompt_lbl: Label
var selected: bool = false
var solved_pos: Vector2 = Vector2.ZERO

func _ready():
	base = $Base
	breakage = $Breakage
	prompt_lbl = $Prompt

	if small_text:
		prompt_lbl.add_theme_font_size_override("font_size", 10)

	if answer_wire:
		base.flip_v = true
		breakage.flip_v = true
		prompt_lbl.position.y *= -1
		prompt_lbl.position.y -= prompt_lbl.size.y


func set_color(color_: Color) -> void:
	color = color_
	base.self_modulate = color


func set_prompt(prompt_: String) -> void:
	prompt = prompt_
	prompt_lbl.text = prompt


func set_solved_pos(solved_pos_: Vector2) -> void:
	solved_pos = solved_pos_


func solved() -> bool:
	return solved_pos != Vector2.ZERO

func _process(delta):
	if selected or solved():
		queue_redraw()


func _draw():
	if selected:
		draw_line(Vector2(0, 16), get_global_mouse_position() - global_position, color, 4) 
	elif solved_pos:
		draw_line(Vector2(0, 16), solved_pos - global_position + Vector2(0, -16), color, 4)
		
