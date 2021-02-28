extends "res://Scenes/AI_states/state.gd"

func enter(host):
	host.animation_state_machine.travel("Run")

func handle_input(host,event):
			
				
	if host.jump:	
		emit_signal("finished", "Jump")
						
	if host.get_down:
		pass
		
		
func update(host, _delta):

	if host.go_right:

			host.velocity.x += host.SPEED
			host.flip_sprite(1)#Sprite image flip 

	elif host.go_left:	
			
			host.velocity.x -= host.SPEED
			host.flip_sprite(-1)	#Sprite image flip
	else:
		emit_signal("finished", "Idle")

			
	host.velocity.x = lerp(host.velocity.x,0,0.1)
	host.invincible_toggle(false)#player takes no damage
	
	host.velocity = host.move_and_slide_with_snap(host.velocity, host.snap_vector ,host.FLOOR_NORMAL,false, 4, PI/4, false)
	host.snap_vector = host.SNAP_DIRECTION * host.SNAP_LENGTH
			
	if !host.is_on_floor():
		emit_signal("finished", "In_Air")
		

func exit(host):
	pass
