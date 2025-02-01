extends StaticBody2D

var health: int = 500
var creep_spawn: PackedScene = preload("res://Scenes/Enemies/creep.tscn")
@onready var gui: CanvasLayer = %GUI
@onready var mother_ship_spawn: NavigationRegion2D = $"../../MotherShipSpawn"

func _ready() -> void:
	var polygon = mother_ship_spawn.navigation_polygon.get_vertices()
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF
	
	for point in polygon:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
	
	var random_x = randf_range(min_x, max_x)
	var random_y = randf_range(min_y, max_y)
	
	# Set the position
	position = Vector2(random_x, random_y)

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("fighter"):
		area.queue_free()
		health -= area.damage
		if health <= 0:
			Global.enemy_count -= 1
			self.queue_free()

func _process(delta: float) -> void:
	self.rotation_degrees += 90 * delta
	$Orbit_01.rotation_degrees -= 300 * delta
	$Orbit_02.rotation_degrees += 310 * delta
	$Orbit_03.rotation_degrees += 330 * delta
	$Orbit_04.rotation_degrees -= 360 * delta
	
func spawn_creeps(level):
	var spawn_points = [$Orbit_01/Spawn_1, $Orbit_02/Spawn_2, $Orbit_03/Spawn_3, $Orbit_04/Spawn_4]

	for i in level:
		await get_tree().create_timer(0.5).timeout
		var spawn_point = spawn_points[randi_range(0, spawn_points.size() - 1)]
		var creep_temp = creep_spawn.instantiate()
		creep_temp.global_position = spawn_point.global_position
		var target_position = self.position + Vector2(100,100)
		creep_temp.look_at(target_position)
		get_node("../../Enemies").add_child(creep_temp)
		gui.update_gui()
