
extends CharacterBody2D

@export var speed: float = 100.0
var dir := Vector2.RIGHT

func _ready() -> void:
	randomize()
	# pick a random direction
	var dirs = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
	dir = dirs[randi() % dirs.size()]

func _physics_process(_delta: float) -> void:
	print("Ghost physics running")
	# try to move; if hitting wall, pick a new random dir
	velocity = dir * speed
	var remainder := move_and_slide()
	if velocity.length() < 1.0:
		var dirs = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
		dir = dirs[randi() % dirs.size()]
	queue_redraw()

#func _draw() -> void:
	## simple ghost blob
	#draw_circle(Vector2.ZERO, 14.0, Color(1,0.3,0.3))
	#draw_rect(Rect2(Vector2(-14,0), Vector2(28,14)), Color(1,0.3,0.3))
