extends Node3D

@onready var delay_timer = $DelayTimer
var bulb
var blinking: bool = false

func _ready():
	bulb = $BulbMesh
	bulb.mesh = bulb.mesh.duplicate(true)

func blink() -> void:
	if blinking:
		return
	
	blinking = true

	for i in range(3):
		turn_on()
		delay_timer.start(0.1)
		await delay_timer.timeout
		turn_off()
		delay_timer.start(0.1)
		await delay_timer.timeout
	
	delay_timer.start(0.2)
	await delay_timer.timeout

	for i in range(3):
		turn_on()
		delay_timer.start(0.3)
		await delay_timer.timeout
		turn_off()
		delay_timer.start(0.3)
		await delay_timer.timeout
	
	delay_timer.start(0.2)
	await delay_timer.timeout
	
	for i in range(3):
		turn_on()
		delay_timer.start(0.1)
		await delay_timer.timeout
		turn_off()
		delay_timer.start(0.1)
		await delay_timer.timeout
	
	delay_timer.start(1)
	await delay_timer.timeout
	
	blinking = false


func turn_off() -> void:
	bulb.mesh.material.emission_enabled = false


func turn_on() -> void:
	bulb.mesh.material.emission_enabled = true


func _process(delta):
	blink()
