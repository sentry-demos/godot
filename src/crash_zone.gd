extends Area2D


func _on_area_entered(_area: Area2D) -> void:
	# Calling into the native code that crashes application.
	SentrySDK._demo_helper_crash_app()
