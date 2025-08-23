
extends CharacterBody2D

@export var speed: float = 140.0

var desired_dir := Vector2.ZERO
@onready var joystick := get_tree().root.get_node("scripts/VirtualJoystick")

func _ready() -> void:
	set_process(true)

func _process(_delta: float) -> void:
	var input := Vector2.ZERO

	if joystick and joystick.visible:
		# sterowanie dotykowe
		input = joystick.get_value()
	else:
		# sterowanie klawiaturą/padem
		if Input.is_action_pressed("ui_right"):
			input.x += 1
		if Input.is_action_pressed("ui_left"):
			input.x -= 1
		if Input.is_action_pressed("ui_down"):
			input.y += 1
		if Input.is_action_pressed("ui_up"):
			input.y -= 1

	input = input.normalized()
	velocity = input * speed
	move_and_slide()
	queue_redraw()


#func _draw() -> void:
	#draw_circle(Vector2.ZERO, 14.0, Color(1,1,0.2))
	## simple wedge "mouth"
	#draw_arc(Vector2.ZERO, 14.0, deg_to_rad(-20), deg_to_rad(20), 8, Color(0,0,0), 6.0)
