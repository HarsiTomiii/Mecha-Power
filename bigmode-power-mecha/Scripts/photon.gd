extends Area2D

@export var damage: int = 0 #gets updated from global script

var speed: int = 400
var direction: Vector2 = Vector2(0.5,0.5)
var range: int = 700

@export var final_position: Vector2 = Vector2(0,0)
@export var initial_postition: Vector2 = Vector2(0,0)


func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta
	if int(initial_postition.distance_to(self.global_position)) >= range:
		queue_free()
	
