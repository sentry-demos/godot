extends Area2D

var Confetti = preload("res://src/confetti.tscn")

@onready var confetti_particles = $ConfettiParticles

func _on_body_entered(_player: CharacterBody2D):
	# We only look for the player mask here so we know
	# this only tirggers when the player enters.
	await Game.wait(0.16)
	var pos = Vector2(global_position.x, global_position.y - 152)
	var confetti = Game.instance_scene_on_main(Confetti, pos)
	confetti.emitting = true
