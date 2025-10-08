extends Node


func instance_scene_on_main(scene: PackedScene, position: Vector2):
	var main = get_tree().current_scene
	var instance = scene.instantiate()
	main.add_child(instance)
	instance.global_position = position
	return instance


func reset_scene():
	print("Reloading current scene.")
	get_tree().call_group("instanced", "queue_free")
	get_tree().reload_current_scene()


func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
