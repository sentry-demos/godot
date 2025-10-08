extends SentryConfiguration


func _configure(options: SentryOptions) -> void:
	for arg in OS.get_cmdline_args():
		if arg.begins_with("--dsn="):
			options.dsn = arg.trim_prefix("--dsn=")
