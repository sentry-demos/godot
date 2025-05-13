extends Node
## Automates player movement if launched with --automate.


@export var player: Player

var move_dir: float = 1.0


func _ready() -> void:
	set_physics_process(false)

	if not OS.get_cmdline_args().has("--automate"):
		return

	if randf() < 0.2:
		move_dir = -1.0

	await get_tree().create_timer(1.0).timeout
	set_physics_process(true)


func _physics_process(_delta: float) -> void:
	player.move(move_dir)


func _on_jump_cue_area_entered(_area: Area2D) -> void:
	if is_physics_processing():
		player.jump()
