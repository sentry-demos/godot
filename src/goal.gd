extends Area2D
## Triggers victory animation when entered... except it doesn't exist, so this results in error.


@export var animation_player: AnimationPlayer
@export var dance_victory_animation: StringName = "Dance"


func _play_victory_animation():
	# Results in error since "victory" animation doesn't exist.
	var goal_name: String = self.name
	var breadcrumb: SentryBreadcrumb = SentryBreadcrumb.create("Reached: " + goal_name)
	breadcrumb.category = "Milestone"
	SentrySDK.add_breadcrumb(breadcrumb)
	animation_player.play(dance_victory_animation)


func _on_body_entered(_player: CharacterBody2D):
	_play_victory_animation()
