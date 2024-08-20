extends Area2D

var Confetti = preload("res://src/confetti.tscn")

func _on_body_entered(_player: CharacterBody2D):
	# We only look for the player mask here so we know
	# this only tirggers when the player enters.
	await Global.wait(0.16)
	var pos = Vector2(global_position.x, global_position.y - 152)
	var confetti = Global.instance_scene_on_main(Confetti, pos)
	confetti.emitting = true
