extends ProgressBar

@onready var target: Node = get_parent()

func _ready():
	max_value = target.hitpoints

func update() -> void:
	if not visible:
		show()
	value = target.hitpoints

func _process(delta):
	pass