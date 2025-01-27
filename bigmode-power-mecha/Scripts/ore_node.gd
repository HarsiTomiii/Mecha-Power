extends StaticBody2D

@onready var node_health: int = 100
@onready var ore_amount: int = randi_range(20,33)
@onready var health_bar: ProgressBar = %HealthBar

func _ready() -> void:
	health_bar.value = node_health
	health_bar.max_value = node_health
	health_bar.hide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("miner"):
		$HealthBarHide.start()
		health_bar.show()
		node_health -= area.damage
		health_bar.value = node_health
		#here instead of queu free, we will need to hide it and wait until animation is done
		#perhaps animation on the node also
		area.queue_free()
		if node_health <= 0:
			Global.collected_ore += ore_amount
			
			queue_free()
	pass # Replace with function body.


func _on_health_bar_hide_timeout() -> void:
	health_bar.hide()
