extends CharacterBody2D


@export var speed : float = 20000.0
@export var health : int = 150
@export var max_health : int = 200

@onready var photon_scene: PackedScene = preload("res://Scenes/Props/enemy_photon.tscn")
@onready var photon_cooldown: Timer = $PhotonCooldown

@onready var cannon_1: Marker2D = $Cannon_1
@onready var player: CharacterBody2D = $"../../Player"


var is_shooting : bool = false
var damage: float = Global.photon_damage * 0.5

func _ready() -> void:
	$NavigationAgent2D.target_position = Vector2(500,500)

func _process(delta):
	var direction = (player.global_position - self.global_position).normalized()
	if position.distance_to(player.position) > 200 and position.distance_to(player.position) < 3000:
		self.velocity = speed * delta * direction
	else:
		self.velocity = Vector2.ZERO
	look_at(player.global_position)
	move_and_slide()


func shooting(damage) -> void:
	var photon_temp = photon_scene.instantiate()
	var target_position = (player.position - self.global_position).normalized()
	var final_position = player.position
	photon_temp.initial_postition = self.global_position
	photon_temp.final_position = final_position
	photon_temp.direction = target_position
	photon_temp.look_at(target_position)
	photon_temp.damage = damage
	#add here a marker to target form
	photon_temp.global_position = cannon_1.global_position
	get_node("../../Projectiles").add_child(photon_temp)

func _on_photon_cooldown_timeout() -> void:
	if position.distance_to(player.position) < 400:
		shooting(damage)


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("fighter"):
		area.queue_free()
		health -= area.damage
		if health <= 0:
			Global.enemy_count -= 1
			self.queue_free()
			
