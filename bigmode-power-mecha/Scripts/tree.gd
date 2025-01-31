extends StaticBody2D


func _on_hit_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("miner"):
		Global.collected_ore += 2
		area.queue_free()
		self.queue_free()
	elif area.is_in_group("fighter"):
		self.queue_free()
		area.queue_free()
