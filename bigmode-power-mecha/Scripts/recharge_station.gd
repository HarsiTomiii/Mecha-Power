extends StaticBody2D

@onready var recharge_area: Area2D = $RechargeArea
@onready var player: CharacterBody2D = $"../Player"

#func _physics_process(delta: float) -> void:
	#if recharge_area.overlaps_body(player):
		#await get_tree().create_timer(Global.deposit_time_tick).timeout
		#player.recharging()

func _on_recharge_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.recharging()
		pass


func _on_collision_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("miner") or area.is_in_group("fighter"):
		area.queue_free()
