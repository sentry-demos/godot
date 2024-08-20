extends CharacterBody2D

var JumpSkid = preload("res://src/jumo_skid.tscn")
var can_move = true

const SPEED = 350
const JUMP_VELOCITY = -450
const GRAVITY = 900

@onready var sprite = $AnimatedSprite

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
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			sprite.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
	
func jump():
	velocity.y = JUMP_VELOCITY
	# Show jump skid.
	var skid = Global.instance_scene_on_main(JumpSkid, global_position)
	skid.flip_h = sprite.flip_h
	
func _on_goal_detector_area_area_entered(_goal: Area2D):
	await Global.wait(0.16)
	can_move = false
	velocity = Vector2.ZERO
	sprite.play("cheer")
