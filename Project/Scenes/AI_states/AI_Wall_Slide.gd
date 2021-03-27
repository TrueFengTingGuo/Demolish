extends "res://Scenes/AI_states/state.gd"




# Clean up the state. Reinitialize values like a timer
func enter(host):
	
	if host.velocity.x > 0:
		host.flip_sprite(1)#Sprite image flip 
	elif host.velocity.x < 0:
		host.flip_sprite(-1)#Sprite image flip 
		
func handle_input(host,event):
	return

func update(host,delta):

	host.animation_state_machine.travel("Wall_slide")
	
	if host.go_right and host.velocity.x < 0:

		host.velocity.y = host.JUMPFORCE
		host.velocity.x = 0.5 * host.SPEED

		host.flip_sprite(1)#Sprite image flip 
		
	elif host.go_left  and host.velocity.x > 0:	
			
		host.velocity.y = host.JUMPFORCE
		host.velocity.x = -0.5 * host.SPEED

		host.flip_sprite(-1)#Sprite image flip 
		
	elif host.jump and not host.go_left and not host.go_right:
		host.velocity.y = lerp(host.velocity.y,0,0.3)		
			
	host.give_gravity()

	if !host.is_on_wall():
		emit_signal("finished", "In_Air")
	if host.is_on_floor():
		emit_signal("finished", "Idle")
		
func _on_animation_finished(anim_name):
	
	return
