extends "res://Scenes/AI_states/state.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enter(host):
	pass

func handle_input(host,event):
		
		if Input.is_action_pressed("ui_right"):

			host.flip_sprite(1)

		if Input.is_action_pressed("ui_left"):	

			host.flip_sprite(-1)
			
		if Input.is_action_just_pressed("Switch_weapon"):
			host.bow = !host.bow
			host.sword = !host.sword

			
func update(host, _delta):


	host.give_gravity()
	
	if host.is_on_ceiling():
		host.velocity.y = 0
	
	if host.is_on_wall():
		emit_signal("finished", "Wall_Slide")
		
		
	if host.velocity.y > 0:
		host.animation_state_machine.travel("Fall")
	else:
		host.animation_state_machine.travel("Jump")
					
	if host.is_on_floor():
		emit_signal("finished", "Idle")
		
		
func exit(host):
	host.velocity.y = 0
