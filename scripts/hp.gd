extends ProgressBar

var health := 100
@onready var characterBody2D = get_node("../../")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if characterBody2D.position.y > 75:
		health -= 10
	value = health
