extends "res://Scenes/AI_states/state.gd"

func enter(host):
	host.animation_state_machine.travel("Run")

func handle_input(host,event):
			
				
	if Input.is_action_just_pressed("ui_up"):	
		emit_signal("finished", "Jump")
			
	if Input.is_action_just_pressed("Switch_weapon"):
		host.bow = !host.bow
		host.sword = !host.sword
			
	if Input.is_action_pressed("ui_down"):
		pass
		
		
			
			
func update(host, _delta):

	if Input.is_action_pressed("ui_right"):

			host.velocity.x += host.SPEED
			host.flip_sprite(1)#Sprite image flip 

	elif Input.is_action_pressed("ui_left"):	
			
			host.velocity.x -= host.SPEED
			host.flip_sprite(-1)	#Sprite image flip
	else:
		emit_signal("finished", "Idle")

			
	host.velocity.x = lerp(host.velocity.x,0,0.1)
	host.invincible_toggle(false)#player takes no damage
	
	host.velocity = host.move_and_slide_with_snap(host.velocity, host.snap_vector ,host.FLOOR_NORMAL,false, 4, PI/4, false)
	host.snap_vector = host.SNAP_DIRECTION * host.SNAP_LENGTH

	print(host.velocity.y)
			
	if !host.is_on_floor():
		emit_signal("finished", "In_Air")
		

func exit(host):
	pass
