extends Node

@onready var player = $Player

func before_send(event):
	event.message.formatted += "_modified_from_godot_side"
	return event

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_P):
		SentrySdk.capture_message("pressed P!")
	
	if Input.is_action_just_pressed("ui_fullscreen"):
		var mode = DisplayServer.window_get_mode()
		if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
	if Input.is_action_just_pressed("ui_reset"):
		Global.reset_scene()
		
func _physics_process(_delta):
	# Reset the game if the player fell down
	if player and player.position.y > 800:
		await Global.wait(0.16)
		Global.reset_scene()
