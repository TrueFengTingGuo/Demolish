
extends Node

signal finished(next_state_name)

# Initialize the state. E.g. change the animation
func enter(host):
	return

# Clean up the state. Reinitialize values like a timer
func exit(host):
	return

#handle any input that does require _delta time
func handle_input(host,event):
	return

func update(host,delta):
	return

func _on_animation_finished(anim_name):
	return
