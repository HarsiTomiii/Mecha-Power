extends CanvasLayer


func update_gui():
	$WorldStats/ChargeBar.value = Global.current_base_charge
	$WorldStats/OreContainer/OreAmount.text = str(Global.deposited_ore)


func _ready() -> void:
	$MinerStats/OreMined.value = 0
	$MinerStats/OreMined.max_value = Global.max_ore_collected
	
	$WorldStats/OreContainer/OreAmount.text = str(0)
