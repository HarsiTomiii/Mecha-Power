extends Area2D

@export var damage: int = 5

var speed: int = 400
var direction: Vector2 = Vector2(0,0)

@export var final_position: Vector2 = Vector2(0,0)
@export var distance_to_target: int

func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta
	distance_to_target = int(final_position.distance_to(self.position))
	
	if distance_to_target < 10:
		self.queue_free()
