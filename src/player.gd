class_name Player
extends CharacterBody2D
## Player controller. Also controlled via Automator.


var JumpSkid = preload("res://src/jumo_skid.tscn")
var can_move = true

const SPEED = 350
const JUMP_VELOCITY = -450
const GRAVITY = 900

@onready var sprite = $AnimatedSprite

var move_request: float = 0.0


func _ready() -> void:
	# Setting a tag example.
	var player_type = "VIP" if randf() < 0.2 else "regular"
	SentrySDK.set_tag("player_category", player_type)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Only handle player input if we can move
	if can_move:
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			jump()

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		move_request += Input.get_axis("ui_left", "ui_right")
		move_request = clampf(move_request, -1.0, 1.0)

		if move_request:
			velocity.x = move_request * SPEED
			sprite.flip_h = move_request < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_request = 0.0

	move_and_slide()


func jump():
	SentrySDK.add_breadcrumb("Jumping!", "Note")
	velocity.y = JUMP_VELOCITY
	# Show jump skid.
	var skid = Global.instance_scene_on_main(JumpSkid, global_position)
	skid.flip_h = sprite.flip_h


func move(direction: float) -> void:
	move_request += direction
