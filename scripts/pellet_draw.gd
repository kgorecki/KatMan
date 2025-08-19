
extends Node2D
func _draw() -> void:
	draw_circle(Vector2.ZERO, 3.5, Color(1,1,0.9))
func _process(_delta: float) -> void:
	queue_redraw()
