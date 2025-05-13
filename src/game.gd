extends Node

@onready var player = $Player


func _ready() -> void:
	print("Game starting!")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_fullscreen"):
		var mode = DisplayServer.window_get_mode()
		if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	if Input.is_action_just_pressed("ui_reset"):
		Global.reset_scene()


func _physics_process(_delta):
	if player and player.position.y > 2000:
		# Detect player falling through level boundaries as error.
		push_error("Player left playable area! Restarting scene.")
		Global.reset_scene()
