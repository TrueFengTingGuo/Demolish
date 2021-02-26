extends "res://Scenes/AI_states/state.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enter(host):
	host.animation_state_machine.travel("Idle")


func handle_input(host,event):	
	
	if Input.is_action_just_pressed("ui_up"):		
		emit_signal("finished", "Jump")
		
	if Input.is_action_just_pressed("Switch_weapon"):
		host.bow = !host.bow
		host.sword = !host.sword
			
func update(host, _delta):
	
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):	
		emit_signal("finished", "Run")
		
	host.velocity.x = lerp(host.velocity.x,0,0.1)
	host.invincible_toggle(false)#player takes no damage
	
	host.velocity = host.move_and_slide_with_snap(host.velocity, host.snap_vector ,host.FLOOR_NORMAL,false, 4, PI/4, false)
	host.snap_vector = host.SNAP_DIRECTION * host.SNAP_LENGTH
	
	if !host.is_on_floor():
		emit_signal("finished", "In_Air")

func exit(host):
	pass
