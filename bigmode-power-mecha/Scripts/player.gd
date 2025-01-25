extends CharacterBody2D


@export var speed : float = 330.0
@export var health : int = 150
@export var max_health : int = 200
@export var charge_level : int = 50
@export var max_charge_level : int = 100


func _physics_process(delta: float) -> void:
	
	# Getting input and translating it to movement vector
	var input_direction: Vector2 = Input.get_vector("left","right","up","down")
	
	#Making the character turn towards the mouse pointer
	var mouse_position: Vector2 = get_global_mouse_position()
	look_at(mouse_position)
	
	velocity = input_direction * speed
	
	move_and_slide()

func shooting(damage) -> void:
	pass

#TODO make a pickup radius
#TODO shooting the beam
#TODO connecting to power source
#TODO depositing ore
