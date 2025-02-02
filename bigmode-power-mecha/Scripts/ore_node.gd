extends StaticBody2D

@onready var node_health: int = 100
@onready var ore_amount: int = randi_range(30,50)
@onready var health_bar: ProgressBar = %HealthBar
@onready var exp_value: int = 10

func _ready() -> void:
	health_bar.value = node_health
	health_bar.max_value = node_health
	health_bar.hide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("miner"):
		$HealthBarHide.start()
		health_bar.show()
		$GettingHit.play()
		node_health -= area.damage
		health_bar.value = node_health
		#here instead of queu free, we will need to hide it and wait until animation is done
		#perhaps animation on the node also
		area.queue_free()
		if node_health <= 0:
			Global.collected_ore += ore_amount
			Global.exp_collected += exp_value
			get_node("../../GUI").get_node("MinerStats").get_node("OreMined").value = Global.collected_ore
			if Global.collected_ore >= Global.max_ore_collected:
				Global.collected_ore = Global.max_ore_collected
			self.hide()
			$".".set_collision_mask_value(1, false)
			$".".set_collision_layer_value(3, false)
			$Area2D.queue_free()
			await $GettingHit.finished
			queue_free()
	pass # Replace with function body.


func _on_health_bar_hide_timeout() -> void:
	health_bar.hide()
