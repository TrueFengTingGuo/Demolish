#Credit for making a platformer AI https://www.youtube.com/watch?v=WXC8eBCEbho


extends "res://Scenes/Enemy.gd"

var healer_init_hp = 20
var heal = false
var running = true
var is_hurt = false

func _ready():
	hp = healer_init_hp
	init_hp = healer_init_hp
	animation_state_machine =$AnimationTree.get("parameters/playback")
	
func _physics_process(delta):
	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -VELOCITY_X_LIMIT, VELOCITY_X_LIMIT)
	
	if is_on_ceiling():
		velocity.y = 0
	
	#change the direction of the sprite
	fliping()
		
	process_hurt()
	
	if (hp < healer_init_hp):
		self.get_healing()
		animation_state_machine.travel("Healing")
	
	if is_on_floor():
		
		on_floor_physics()

		#print("attack " + str(attack) + "attack_finished " + str(attack_finished))		
		
		
		if heal :
			#print("HHH")		
			running = false
			animation_state_machine.travel("Healing")
		elif(abs(velocity.x) > 40) and running :
			#he is running	
			#print("RRR")
			animation_state_machine.travel("Run")	
			heal = false		
		else:			
			#he is not moving
			#print("Idle")
			animation_state_machine.travel("Idle")	
		if ($Follow_Target.is_in_group("Warrior") ):	
			#print("follow")
			follow_target_sequence()
		else:
			escape_from_target()
	else:	
		
		in_air_physics()
		
	process_died()
		
func stop_healing():
	if heal == true:
		heal = false

func _on_Effect_animation_finished():
	$Effect.visible = false

func remove_from_targetable():
	remove_from_group("Enemy")
	#remove_from_group("Warrior")
	set_collision_layer_bit( 2, false )



	
func _on_Area2D_body_entered(body):
	if body.is_in_group("Warrior") and !heal:
		running = true
		$Follow_Target.set_target(body)
		

	elif body.is_in_group("Player") and running:
		
		$Follow_Target.set_target(body)


func _on_Area2D_body_exited(body):
	if $Follow_Target.target_node == body:
		$Follow_Target.deselcet_target()


func _on_Healing_area_body_entered(body):
	if body.is_in_group("Enemy") :
		
		if (body.hp < body.init_hp):
			print(body.hp)
			body.get_healing()
			heal = true
		
			
		


func _on_Healing_area_body_exited(body):
	if body.is_in_group("Enemy") :
		stop_healing()
