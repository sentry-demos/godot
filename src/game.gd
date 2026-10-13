extends Node

@onready var player = $Player

var level_bottom := 2000
var _level_span: SentrySpan
var _scene_reset_binding: Callable
var _time_taken_to_reach_goal: float = 0.0
var _jump_count: int = 0


func _ready() -> void:
	print("Game starting!")


func _enter_tree() -> void:
	_connect_signals()
	_enrich_sentry_context()
	_start_level_span()


func _exit_tree() -> void:
	_end_level_span(SentrySpan.SPAN_STATUS_OK)
	_disconnect_signals()


func _connect_signals() -> void:
	_scene_reset_binding = _end_level_span.bind(
		SentrySpan.SPAN_STATUS_ERROR, "Level interrupted by a scene reset.")
	Global.scene_resetting.connect(_scene_reset_binding)

	Global.goal_reached.connect(_on_goal_reached, CONNECT_ONE_SHOT)
	Global.player_jumped.connect(_on_player_jumped)


func _disconnect_signals() -> void:
	if _scene_reset_binding.is_valid() and Global.scene_resetting.is_connected(_scene_reset_binding):
		Global.scene_resetting.disconnect(_scene_reset_binding)

	if Global.goal_reached.is_connected(_on_goal_reached):
		Global.goal_reached.disconnect(_on_goal_reached)
	if Global.player_jumped.is_connected(_on_player_jumped):
		Global.player_jumped.disconnect(_on_player_jumped)


func _enrich_sentry_context() -> void:
	SentrySDK.set_tag("level", "clouds")
	# Add this attribute to every span, log, or metric emitted from now on.
	SentrySDK.set_attribute("level", "clouds")


func _start_level_span() -> void:
	_level_span = SentrySDK.start_span("Play level: clouds", {
		"sentry.op": "game.level",
		"level": "clouds",
	})


func _end_level_span(status: SentrySpan.SpanStatus, message: String = "") -> void:
	if _level_span == null:
		return

	_level_span.set_status(status)
	if not message.is_empty():
		_level_span.set_attribute("sentry.status.message", message)
	_level_span.end()
	_level_span = null


func _on_goal_reached() -> void:
	SentrySDK.metrics.distribution("level.time_to_goal", _time_taken_to_reach_goal, SentryUnit.second)
	SentrySDK.metrics.distribution("level.jumps_to_goal", _jump_count)


func _on_player_jumped() -> void:
	_jump_count += 1


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_fullscreen"):
		var mode = DisplayServer.window_get_mode()
		if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	if Input.is_action_just_pressed("ui_reset"):
		Global.reset_scene()

	_time_taken_to_reach_goal += _delta


func _physics_process(_delta):
	if not is_instance_valid(player):
		return

	var pos: Vector2 = player.position
	if pos.y > level_bottom:
		# Detect player falling through level boundaries as error.
		push_error("Player left playable area! Restarting scene.")
		Global.reset_scene()
