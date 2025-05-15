extends Area2D
## Area that triggers native code crash if entered.


func _on_area_entered(_area: Area2D) -> void:
	print("Triggering native code crash.")
	GameLogic.enter_crash_zone()
