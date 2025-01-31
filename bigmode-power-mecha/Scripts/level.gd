extends Node

@onready var ore_node_scene = preload("res://Scenes/Props/ore_node.tscn")
@onready var tree_scene = preload("res://Scenes/Props/tree.tscn")
@onready var gui: CanvasLayer = %GUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node_count: int = randi_range(600,800)
	for i in node_count:
		var temp_ore_position : Vector2 = Vector2(randi_range(0,75)*64, randi_range(-75,75)*64)
		var temp_ore_node = ore_node_scene.instantiate()
		temp_ore_node.position = temp_ore_position
		get_node("Resources").add_child(temp_ore_node)

	var tree_count: int = randi_range(1000,2000)
	for i in tree_count:
		var temp_tree_position : Vector2 = Vector2(randi_range(0,75)*64, randi_range(-75,75)*64)
		var temp_tree_node = tree_scene.instantiate()
		temp_tree_node.position = temp_tree_position
		get_node("Landscape").add_child(temp_tree_node)
	enemy_count_update()
	pass # Replace with function body.

func enemy_count_update():
	var enemy_count = get_node("/root/Level/Enemies").get_child_count()
	Global.enemy_count = enemy_count
	gui.update_gui()
	
