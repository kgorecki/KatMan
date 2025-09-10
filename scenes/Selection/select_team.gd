extends Control

# Node paths to the team TextureRects
@onready var team_nodes = [
	$ColorRect/HBoxContainer/TeamA,
	$ColorRect/HBoxContainer/TeamB
]
@onready var marker = $ColorRect/TextureRect
@onready var start_button = $ColorRect/StartButton

var selected_index := 0
var marker_y_offset := 25

func _ready() -> void:
	await get_tree().process_frame
	_update_marker_position()
	for i in team_nodes.size():
		team_nodes[i].gui_input.connect(_on_team_gui_input.bind(i))
	start_button.pressed.connect(_on_start_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		selected_index = max(0, selected_index - 1)
		_update_marker_position()
	elif event.is_action_pressed("ui_right"):
		selected_index = min(team_nodes.size() - 1, selected_index + 1)
		_update_marker_position()

func _on_team_gui_input(event: InputEvent, idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		selected_index = idx
		_update_marker_position()
	
func _on_start_pressed():
	Global.selected_team = selected_index
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
	
func _update_marker_position():
	var target = team_nodes[selected_index]
	var target_center = target.global_position.x + target.size.x / 2
	marker.global_position.x = target_center - marker.size.x / 2
	marker.global_position.y = target.global_position.y + target.size.y - marker.size.y + marker_y_offset

func _input(event):
	if Input.is_action_just_pressed("ui_start"):
		start_button.emit_signal("pressed")
