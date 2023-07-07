extends Node3D

@onready var mesh = $MeshInstance3D

func _ready():
	mesh.mesh = mesh.mesh.duplicate(true)


func set_color(color: Color):
	mesh.mesh.material.emission_enabled = true
	mesh.mesh.material.emission_energy = 4.0
	mesh.mesh.material.emission = color


func turn_off() -> void:
	mesh.mesh.material.emission_enabled = false


func _process(delta):
	pass
