extends Node2D
class_name Hp
signal health_changed(health:float, max_health:float)

var max_health := 100
var health := max_health

@export var characterBody2D: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func take_damage(amount) -> void:
	health -= amount
	health_changed.emit(health, max_health)
func is_alive() -> bool:
	return health >= 0
	
