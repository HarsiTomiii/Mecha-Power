extends StaticBody2D

#currently not in use
#var depot_capacity: int = 500

@onready var ore_processing: float = $OreProcessingTimer.wait_time #process tick time
@export var processing_rate: int = 3 #number of ore to power
@export var power_rate: int = 1 #number of power from processing_rate
@onready var gui: CanvasLayer = %GUI


func _on_collision_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("miner") or area.is_in_group("fighter") or area.is_in_group("trees") or area.is_in_group("nodes"):
		area.queue_free()


func _on_depot_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.deposit_ore()


func _on_ore_processing_timer_timeout() -> void:
	if Global.deposited_ore >= processing_rate and (Global.current_base_charge < Global.max_base_charge):
		Global.deposited_ore -= processing_rate
		Global.current_base_charge += power_rate
		gui.update_gui()
