extends "res://Scenes/AI_states/state.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enter(host):
	host.animation_state_machine.travel("Idle")

		
			
func update(host, _delta):

	if host.jump:		
		emit_signal("finished", "Jump")
		
	if host.go_right or host.go_left:	
		emit_signal("finished", "Run")
		
		
	host.velocity.x = lerp(host.velocity.x,0,0.1)
	host.invincible_toggle(false)#player takes no damage
	
	host.velocity = host.move_and_slide_with_snap(host.velocity, host.snap_vector ,host.FLOOR_NORMAL,false, 4, PI/4, false)
	host.snap_vector = host.SNAP_DIRECTION * host.SNAP_LENGTH
	
	if !host.is_on_floor():
		emit_signal("finished", "In_Air")

func exit(host):
	pass
