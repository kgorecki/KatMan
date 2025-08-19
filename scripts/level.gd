
extends Node2D

@onready var score_label: Label = $UI/ScoreLabel

const CELL := 32
const WALL_COLOR := Color(0.1, 0.2, 0.9)
const PELLET_COLOR := Color(1, 1, 0.9)
const PLAYER_COLOR := Color(1, 1, 0.2)
const GHOST_COLOR := Color(1, 0.2, 0.2)

var score:int = 0
var lives:int = 3
var player: Node2D

# Very small, simple map: #=wall, .=pellet, P=player start, G=ghost start, ' ' empty
const MAP := [
	"##########################",
	"#P..........#............#",
	"#.####.###...##.####.###.#",
	"#.#....#...#.......#...G##",
	"#.####.#.###..#.#.##.##.##",
	"#......#....#..#..#.#...##",
	"###.######.#....#.#.####G#",
	"#...........#..#.........#",
	"##########################"
]

func _ready() -> void:
	randomize()
	_build_level()
	_update_hud()

func _build_level() -> void:
	var y := 0
	for row in MAP:
		var x := 0
		for ch in row:
			var pos := Vector2(x * CELL + CELL/2, y * CELL + CELL/2)
			match ch:
				"#":
					_spawn_wall(pos)
				".":
					_spawn_pellet(pos)
				"P":
					_spawn_player(pos)
					_spawn_pellet(pos)
				"G":
					_spawn_ghost(pos)
				" ":
					pass
				_:
					# treat other as empty
					pass
			x += 1
		y += 1

func _spawn_wall(pos: Vector2) -> void:
	var wall := StaticBody2D.new()
	var col := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(CELL, CELL)
	col.shape = shape
	wall.add_child(col)
	wall.position = pos
	add_child(wall)
	# visual
	var v := ColorRect.new()
	v.size = Vector2(CELL, CELL)
	v.color = WALL_COLOR
	v.position = pos - v.size/2
	add_child(v)

func _spawn_pellet(pos: Vector2) -> void:
	var pellet := Area2D.new()
	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 4
	col.shape = shape
	pellet.add_child(col)
	pellet.position = pos
	pellet.set_meta("pellet", true)
	pellet.body_entered.connect(_on_pellet_body_entered.bind(pellet))
	# visual
	var dot := Node2D.new()
	dot.position = Vector2.ZERO
	dot.set_script(load("res://scripts/pellet_draw.gd"))
	pellet.add_child(dot)

	add_child(pellet)

func _spawn_player(pos: Vector2) -> void:
	player = CharacterBody2D.new()
	player.position = pos
	player.set_script(load("res://scripts/player.gd"))
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/hat32.png")
	player.add_child(sprite)
	add_child(player)
	# collision
	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 12
	col.shape = shape
	player.add_child(col)

func _spawn_ghost(pos: Vector2) -> void:
	var ghost := CharacterBody2D.new()
	ghost.position = pos
	ghost.set_script(load("res://scripts/ghost.gd"))
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/harris32.png")
	ghost.add_child(sprite)
	add_child(ghost)
	# collision
	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 12
	col.shape = shape
	ghost.add_child(col)

func _on_pellet_body_entered(body: Node, pellet: Area2D) -> void:
	if body == player and pellet.is_inside_tree():
		pellet.queue_free()
		score += 10
		_update_hud()

func _update_hud() -> void:
	score_label.text = "Score: %d    Lives: %d" % [score, lives]
