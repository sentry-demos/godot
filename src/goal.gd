extends Area2D
## Triggers victory animation when entered... except it doesn't exist, so this results in error.


@export var animation_player: AnimationPlayer


func _play_victory_animation():
	# Results in error since "victory" animation doesn't exist.
	animation_player.play("victory")


func _on_body_entered(_player: CharacterBody2D):
	_play_victory_animation()
