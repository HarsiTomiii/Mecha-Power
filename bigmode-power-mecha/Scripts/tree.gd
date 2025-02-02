extends StaticBody2D


func _on_hit_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("miner"):
		Global.collected_ore += 2
		$GettingHit.play()
		area.queue_free()
		self.visible = false
		$".".set_collision_mask_value(1, false)
		$".".set_collision_layer_value(3, false)
		$HitZone.queue_free()
		await $GettingHit.finished
		self.queue_free()
	elif area.is_in_group("fighter") or area.is_in_group("enemy_fighter"):
		$GettingHit.play()
		area.queue_free()
		self.visible = false
		$".".set_collision_mask_value(1, false)
		$".".set_collision_layer_value(3, false)
		$HitZone.queue_free()
		await $GettingHit.finished
		self.queue_free()
