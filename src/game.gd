extends Node

@onready var player = $Player

func _init():
	var sentry = SentryExample.new()

func _process(_delta: float) -> void:	
	if Input.is_action_just_pressed("ui_fullscreen"):
		var mode = DisplayServer.window_get_mode()
		if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
	if Input.is_action_just_pressed("ui_reset"):
		reset_scene()
		
func _physics_process(delta):
	# Reset the game if the player fell down
	if player and player.position.y > 800:
		await wait(0.16)
		reset_scene()
		
func instance_scene_on_main(scene: PackedScene, position: Vector2):
	var main = get_tree().current_scene
	var instance = scene.instantiate()
	main.add_child(instance)
	instance.global_position = position
	return instance
	
func reset_scene():
	get_tree().call_group("instanced", "queue_free")
	get_tree().reload_current_scene()
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
