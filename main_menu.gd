extends Control



signal newRun



func _ready() -> void:
	%NewRunButton.pressed.connect(func():newRun.emit())
