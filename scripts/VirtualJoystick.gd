extends Control

@export var radius := 100.0
var drag_position := Vector2.ZERO

func _ready():
    visible = DisplayServer.is_touchscreen_available()

func _gui_input(event):
    if event is InputEventScreenTouch or event is InputEventScreenDrag:
        if event.pressed:
            drag_position = (event.position - global_position).clamp(Vector2(-radius, -radius), Vector2(radius, radius))
        else:
            drag_position = Vector2.ZERO

func get_value() -> Vector2:
    return drag_position / radius
