extends Area2D


func _on_area_entered(_area: Area2D) -> void:
	print("Calling into native code that crashes the game.")
	SentrySDK._demo_helper_crash_app()
