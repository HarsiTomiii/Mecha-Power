extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Level/MotherShip.rotation_degrees += 90 * delta
	$Level/MotherShip/Orbit_01.rotation_degrees -= 300 * delta
	$Level/MotherShip/Orbit_02.rotation_degrees += 310 * delta
	$Level/MotherShip/Orbit_03.rotation_degrees += 330 * delta
	$Level/MotherShip/Orbit_04.rotation_degrees -= 360 * delta


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level.tscn")
