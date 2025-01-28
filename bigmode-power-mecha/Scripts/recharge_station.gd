extends StaticBody2D


@onready var recharge_timer: Timer = $RechargeTimer



func _on_recharge_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		recharge_timer
		print ("hello")
		pass
