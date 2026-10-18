extends ProgressBar

@export var hp: Hp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp.health_changed.connect(_on_health_changed)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_health_changed(health, max_health):
	value = health
	max_value = max_health
