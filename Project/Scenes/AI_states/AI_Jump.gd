extends "res://Scenes/AI_states/state.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enter(host):
	host.jump = false
	host.velocity.y = host.JUMPFORCE	
	host.snap_vector = Vector2.ZERO * host.SNAP_LENGTH
	emit_signal("finished", "In_Air")


