extends Area2D

@export var animation_player: AnimationPlayer


func _play_victory_animation():
	# Results in error as "victory" animation doesn't exist.
	animation_player.play("victory")


func _on_body_entered(_player: CharacterBody2D):
	_play_victory_animation()
