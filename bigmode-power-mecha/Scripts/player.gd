extends CharacterBody2D


@export var speed : float = 500.0
@export var health : int = 500
@export var max_health : float = 500
@export var charge_level : float = 50.0
@export var max_charge_level : float = 100.0
@export var drain_rate : float = 1.0 # how many charge per second
@export var pitch_transition_time: float = 3.0

@onready var photon_scene: PackedScene = preload("res://Scenes/Props/photon.tscn")
@onready var photon_cooldown: Timer = $PhotonCooldown
@onready var charge_drain_timer: Timer = $ChargeDrainTimer

@onready var cannon_1: Marker2D = $Cannon_1
@onready var cannon_2: Marker2D = $Cannon_2

@onready var gui: CanvasLayer = %GUI
@onready var move_sound: AudioStreamPlayer2D = $MoveSound

var is_shooting : bool = false
var empty_charge : bool = false
var speed_multiplier = 1.0
var transition_time = 1.0  # Time in seconds for the transition
var transition_timer = 0.0
var target_multiplier = 1.0
var current_pitch: float = 0.6
var target_pitch: float = 1.0
var pitch_transition_timer: float = 3.0

func _ready() -> void:
	charge_level = max_charge_level
	
	

func _physics_process(delta: float) -> void:
	if charge_level <=0:
		empty_charge = true
	else:
		empty_charge = false
	
	if Input.is_action_pressed("shooting_left") and photon_cooldown.is_stopped() and not empty_charge:
		is_shooting = true
		shooting(Global.photon_damage)
	if Input.is_action_just_released("shooting_left"):
		is_shooting = false
	
	# Getting input and translating it to movement vector
	var input_direction: Vector2 = Input.get_vector("left","right","up","down")
	
	#Making the character turn towards the mouse pointer
	var mouse_position: Vector2 = get_global_mouse_position()
	look_at(mouse_position)
	
	
	if speed_multiplier != target_multiplier:
		transition_timer += delta
		var t = clamp(transition_timer / transition_time, 0.0, 1.0)
		speed_multiplier = lerp(speed_multiplier, target_multiplier, t)
		
		if t >= 1.0:
			speed_multiplier = target_multiplier
			transition_timer = 0.0
			
	if empty_charge:
		if target_multiplier != 0.3:
			target_multiplier = 0.3
			transition_timer = 0.0

	elif is_shooting:
		if target_multiplier != 0.5:
			target_multiplier = 0.5
			transition_timer = 0.0
	else:
		if target_multiplier != 1.0:
			target_multiplier = 1.0
			transition_timer = 0.0
	
	velocity = input_direction * speed * speed_multiplier #* delta
	var velocity_magnitude = velocity.length()
	var max_speed = speed * speed_multiplier
	target_pitch = remap(velocity_magnitude, 0, max_speed, 0.6, 1.0)
	
	
	if current_pitch != target_pitch:
		pitch_transition_timer += delta
		var t = clamp(pitch_transition_timer / pitch_transition_time, 0.0, 1.0)
		current_pitch = lerp(current_pitch, target_pitch, t)
		
		if t >= 1.0:
			current_pitch = target_pitch
			pitch_transition_timer = 0.0
		move_sound.pitch_scale = current_pitch

	move_and_slide()
	charge_level_update()


func shooting(damage) -> void:
	photon_cooldown.wait_time = Global.photon_cooldown
	photon_cooldown.start()
	var photon_temp = photon_scene.instantiate()
	var target_position = (get_global_mouse_position() - self.global_position).normalized()
	var final_position = get_global_mouse_position()
	photon_temp.initial_postition = self.global_position
	photon_temp.final_position = final_position
	photon_temp.direction = target_position
	photon_temp.look_at(target_position)
	photon_temp.damage = Global.photon_damage
	#add here a marker to target form
	photon_temp.global_position = cannon_1.global_position
	get_node("../Projectiles").add_child(photon_temp)
	$ShootingSound.play()
	charge_level -= 1



func charge_level_update() -> void:
	gui.get_node("MinerStats/ChargeBar").value = charge_level
	gui.get_node("WorldStats/ChargeBar").value = Global.current_base_charge
	pass

#here we constantly reduce the charging
func _on_charge_drain_timer_timeout() -> void:
	charge_level -= charge_drain_timer.wait_time * drain_rate 

func deposit_ore():
	var ore_to_deposit: int = Global.collected_ore
	Global.collected_ore = 0
	gui.get_node("MinerStats/OreMined").value = Global.collected_ore
	for i in ore_to_deposit:
		await get_tree().create_timer(Global.deposit_time_tick).timeout
		ore_to_deposit -= 1
		Global.deposited_ore += 1
		gui.get_node("WorldStats/OreContainer/OreAmount").text = str(Global.deposited_ore)

func recharging():
	if Global.current_base_charge <= 0:
		pass
	else:
		var missing_charge : int = float(max_charge_level) - charge_level
		for i in missing_charge:
			if Global.current_base_charge <= 0:
				pass
			else:
				#await get_tree().create_timer(Global.deposit_time_tick).timeout
				Global.current_base_charge -= 1
				charge_level += 1
				charge_level_update()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_fighter"):
		$GettingHit.play()
		area.queue_free()
		health -= area.damage
		gui.update_gui()
		if health <= 0:
			var game_over_text = "Game Over"
			$"..".game_over(game_over_text)
