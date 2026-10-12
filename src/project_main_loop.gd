class_name ProjectMainLoop
extends SceneTree


func _initialize() -> void:
	SentrySDK.init(_configure)


func _configure(options: SentryOptions) -> void:
	for arg in OS.get_cmdline_args():
		if arg.begins_with("--dsn="):
			options.dsn = arg.trim_prefix("--dsn=")
