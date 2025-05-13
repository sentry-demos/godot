extends Area2D

@export var victory_animation: Node


func _play_victory_animation():
	# Results in error as victory_animation is not initialized or assigned.
	victory_animation.play()


func _on_body_entered(_player: CharacterBody2D):
	_play_victory_animation()
