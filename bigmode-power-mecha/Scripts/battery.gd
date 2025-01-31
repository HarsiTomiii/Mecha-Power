extends StaticBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var charge_level: float

func _physics_process(_delta: float) -> void:
	charge_level = (float(Global.current_base_charge) / float(Global.max_base_charge)) * 13
	animated_sprite_2d.frame = int(charge_level)

func _ready() -> void:
	Global.number_of_batteries += 1

func _on_collision_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("miner") or area.is_in_group("fighter"):
		area.queue_free()
