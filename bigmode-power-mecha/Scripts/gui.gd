extends CanvasLayer




func _ready() -> void:
	$MinerStats/OreMined.value = 0
	$MinerStats/OreMined.max_value = Global.max_ore_collected
	
	$WorldStats/OreContainer/OreAmount.text = str(0)
