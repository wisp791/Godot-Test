extends CharacterBody2D

@export_category("Movement")
@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

@export_category("Feel & Polish")
@export var coyote_time: float = 0.15     # Time window to jump after leaving a ledge
@export var jump_buffer_time: float = 0.1 # Time window to pre-register a jump input before landing

@onready var hp_component = $HpComponent
@onready var cliff = $"../Cliff"
@onready var money = $"Camera2D/Money Counter"

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Timers for coyote time and jump buffering
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

func _physics_process(delta: float) -> void:
	# 1. Handle Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		coyote_timer -= delta
	else:
		# Reset coyote timer whenever firmly on the ground
		coyote_timer = coyote_time

	# 2. Handle Jump Buffer Input
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	# 3. Execute Jump (Using Coyote Time & Jump Buffering)
	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = jump_velocity
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	# Variable Jump Height: Cut jump short if the player releases jump early
	if (Input.is_action_just_released("ui_accept")) and velocity.y < 0.0:
		velocity.y *= 0.5

	# 4. Handle Horizontal Movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# 5. Update Animations & Sprite Flip
	update_animations(direction)

	# 6. Move Character
	move_and_slide()

func update_animations(direction: float) -> void:
	# Flip sprite based on movement direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play appropriate animation based on state
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			#animated_sprite.play("fall")
			pass
	else:
		if direction != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")

func teleport():
		position.x = $"../Cliff/Teleport Point".position.x
		position.y = $"../Cliff/Teleport Point".position.y
		hp_component.take_damage(10)
		money.reward(10)
		cliff.grow()
