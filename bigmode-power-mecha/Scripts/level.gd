extends Node

@onready var ore_node_scene = preload("res://Scenes/Props/ore_node.tscn")
@onready var tree_scene = preload("res://Scenes/Props/tree.tscn")
@onready var gui: CanvasLayer = %GUI
@onready var player: CharacterBody2D = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	Global.exp_collected = 0
	Global.exp_for_next_level = 150.0
	Global.current_level = 1
	
	var node_count: int = randi_range(600,800)
	for i in node_count:
		var temp_ore_position : Vector2 = Vector2(randi_range(1,75)*64, randi_range(-75,75)*64)
		var temp_ore_node = ore_node_scene.instantiate()
		temp_ore_node.position = temp_ore_position
		get_node("Resources").add_child(temp_ore_node)

	var tree_count: int = randi_range(1000,2000)
	for i in tree_count:
		var temp_tree_position : Vector2 = Vector2(randi_range(1,75)*64, randi_range(-75,75)*64)
		var temp_tree_node = tree_scene.instantiate()
		temp_tree_node.position = temp_tree_position
		get_node("Landscape").add_child(temp_tree_node)
	gui.update_gui()
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	Global.max_base_charge = 100 * Global.number_of_batteries
	gui.update_gui()
		

#this is for testing creep spawning, no other functionality
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("shooting_right"):
		#$Enemies/MotherShip.spawn_creeps(15)

func level_up():
	$Enemies/MotherShip.spawn_creeps(Global.current_level)


func _on_day_counter_timeout() -> void:
	$Enemies/MotherShip.spawn_creeps(Global.current_level)
	Global.current_level += 1
	player.max_health += player.max_health*(float(Global.current_level) * 0.1)
	player.health = player.max_health
	player.max_charge_level += player.max_charge_level*(float(Global.current_level) * 0.1)

	
func game_over(string):
	$GameOver/Label.text = string
	$GameOver.visible = true
	
	get_tree().paused = true
	
