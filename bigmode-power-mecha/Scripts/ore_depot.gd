extends StaticBody2D

#currently not in use
#var depot_capacity: int = 500


func _on_collision_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("miner") or area.is_in_group("fighter"):
		area.queue_free()


func _on_depot_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.deposit_ore()
