extends Area2D
signal interacted()

@export var is_interactable:bool
@onready var prompt:Control = $"Interact Prompt"
@onready var shop:Control = $"../../Player/Camera2D/Shop"
var in_shop:bool

var in_area:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	prompt.hide()
	shop.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_area and Input.is_action_just_pressed("interact"):
		interacted.emit()
		print("Interacted")
		shop.show()
		in_shop = true
	if in_shop and Input.is_action_just_pressed("leave"):
		shop.hide()
		in_shop = false		
func _on_body_entered(body):
	#print("Area entered:", area.name)
	if body is CharacterBody2D:
		print("Can interact with merchant")
		prompt.show()
		in_area = true
		
func _on_body_exited(body):
	if body is CharacterBody2D:
		print("Cannot interact with merchant")
		prompt.hide()
		in_area = false
		
