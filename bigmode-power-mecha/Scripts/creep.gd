extends CharacterBody2D

@export var speed : float = 20000.0
@export var wander_radius = 200
@export var detection_radius = 1000
@export var health : int = 150
@export var max_health : int = 200

@onready var photon_scene: PackedScene = preload("res://Scenes/Props/enemy_photon.tscn")
@onready var photon_cooldown: Timer = $PhotonCooldown
@onready var cannon_1: Marker2D = $Cannon_1
@onready var player: CharacterBody2D = $"../../Player"

var is_shooting : bool = false
var damage: float = Global.photon_damage * 0.5
var state = "wander"  # Can be "wander" or "chase"
var current_target = Vector2.ZERO
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	pick_random_target()

func _process(delta):
	match state:
		"wander":
			wander(delta)
			check_for_player()
		"chase":
			chase_player(delta)

func wander(delta):
	# If close to current target, pick a new one
	if position.distance_to(current_target) < 10:
		pick_random_target()
	
	# Move towards target using existing movement code
	var direction = (current_target - position).normalized()
	velocity = speed * delta * direction
	# Rotate towards movement direction during wandering
	var angle = atan2(direction.y, direction.x)
	rotation = lerp_angle(rotation, angle, 0.1)
	move_and_slide()

func pick_random_target():
	# Pick a random point within wander radius
	var angle = rng.randf_range(0, 2 * PI)
	var distance = rng.randf_range(0, wander_radius)
	current_target = position + Vector2(cos(angle), sin(angle)) * distance

func check_for_player():
	if position.distance_to(player.position) < detection_radius:
		state = "chase"

func chase_player(delta):
	var distance_to_player = position.distance_to(player.position)
	
	# Combat logic
	if distance_to_player > 200 and distance_to_player < 3000:
		var direction = (player.global_position - self.global_position).normalized()
		velocity = speed * delta * direction
	else:
		velocity = Vector2.ZERO
	
	# Return to wandering if player is too far
	if distance_to_player > detection_radius:
		state = "wander"
		pick_random_target()
		return
	
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
