extends Area2D

func _on_body_entered(_player: CharacterBody2D):
	call("run_victory_animation")
