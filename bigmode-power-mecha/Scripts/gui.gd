extends CanvasLayer

@onready var player: CharacterBody2D = $"../Player"

func update_gui():
	$WorldStats/ChargeBar.value = Global.current_base_charge
	$WorldStats/ChargeBar.max_value = Global.max_base_charge
	$WorldStats/OreContainer/OreAmount.text = str(Global.deposited_ore)
	$EnemyCounter/EnemiesRemaining.text = str(Global.enemy_count)
	$MinerStats/HealthBar.value = player.health
	$MinerStats/HealthBar.max_value = player.max_health
	$MinerStats/ChargeBar.value = player.health
	$MinerStats/ChargeBar.max_value = player.max_charge_level
	var enemy_count = get_node("/root/Level/Enemies").get_child_count()
	Global.enemy_count = enemy_count
	$EnemyCounter/EnemiesRemaining.text = str(Global.enemy_count)

func _ready() -> void:
	$MinerStats/OreMined.value = 0
	$MinerStats/OreMined.max_value = Global.max_ore_collected
	$MinerStats/HealthBar.max_value = player.max_health
	$WorldStats/OreContainer/OreAmount.text = str(0)
