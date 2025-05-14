extends Node

@onready var player = $Player

var level_bottom := 2000


func _ready() -> void:
	print("Game starting!")
	SentrySDK.set_tag("level", "clouds")


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
	if not is_instance_valid(player):
		return

	var pos: Vector2 = player.position
	if pos.y > level_bottom:
		# Detect player falling through level boundaries as error.
		push_error("Player left playable area! Restarting scene.")
		Global.reset_scene()
