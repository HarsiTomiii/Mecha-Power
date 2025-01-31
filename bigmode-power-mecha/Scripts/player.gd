extends CharacterBody2D


@export var speed : float = 25000.0
@export var health : int = 500
@export var max_health : int = 500
@export var charge_level : float = 50.0
@export var max_charge_level : float = 100.0
@export var drain_rate : float = 1.0 # how many charge per second 

@onready var photon_scene: PackedScene = preload("res://Scenes/Props/photon.tscn")
@onready var photon_cooldown: Timer = $PhotonCooldown
@onready var charge_drain_timer: Timer = $ChargeDrainTimer

@onready var cannon_1: Marker2D = $Cannon_1
@onready var cannon_2: Marker2D = $Cannon_2

@onready var gui: CanvasLayer = %GUI

var is_shooting : bool = false


func _ready() -> void:
	charge_level = max_charge_level
	
	

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shooting_left") and photon_cooldown.is_stopped():
		is_shooting = true
		shooting(Global.photon_damage)
	if Input.is_action_just_released("shooting_left"):
		is_shooting = false
	
	# Getting input and translating it to movement vector
	var input_direction: Vector2 = Input.get_vector("left","right","up","down")
	
	#Making the character turn towards the mouse pointer
	var mouse_position: Vector2 = get_global_mouse_position()
	look_at(mouse_position)
	
	
	if is_shooting:
		velocity = input_direction * speed * 0.5 * delta #decreasing movement speed while shooting
	else:
		velocity = input_direction * speed * delta
		
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
	charge_level -= 1



func charge_level_update() -> void:
	gui.get_node("MinerStats/ChargeBar").value = charge_level
	gui.get_node("WorldStats/ChargeBar").value = Global.current_base_charge

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
		if missing_charge > Global.current_base_charge:
			missing_charge = Global.current_base_charge
		else:
			missing_charge = missing_charge
		for i in missing_charge:
			await get_tree().create_timer(Global.deposit_time_tick).timeout
			charge_level += 1
			Global.current_base_charge -= 1
			charge_level_update()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("fighter"):
		area.queue_free()
		health -= area.damage
		gui.update_gui()
