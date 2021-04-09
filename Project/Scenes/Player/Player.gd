extends KinematicBody2D


const SPEED = 30
const GARAVITY = 5
const JUMPFORCE = -200
const VELOCITY_X_LIMIT = 180
const FLOOR_NORMAL = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 12.0
const FLOOR_ANGLE = deg2rad(45)
const CHAIN_PULL = 20
const ARROW_SCENE = preload("res://Scenes/Player/Player_Arrow.tscn")
const ARROW_SPEED = Vector2(15,0)


var animation_state_machine
var snap_vector = SNAP_DIRECTION * SNAP_LENGTH
var chain_velocity = Vector2(0,0)
var velocity = Vector2(0,0)
export (int, 0, 500) var push = 100

#player state
var get_down = false
var go_right = false
var go_left = false
var jump = false
var just_jump = false
var space = false
var attack = false
var air_attack = false
var hurt = false
var invincible = false

var bow = false
var sword = true

var coins = 0
var air_attack_amp = 0
var hp = 100
var _init_hp = 100

func _ready():
	GlobalAccess.Player = self
	animation_state_machine =$AnimationTree.get("parameters/playback")

func _input(event):
	
	#if player is play attack animation, then it should not get any input
	if attack:
		return

	if Input.is_action_just_pressed("Shoot_Chain"):
		# We clicked the mouse -> shoot()
		var target = get_global_mouse_position()
			
		if position.direction_to(target).x > 0:
			$Sprite.scale.x = 1

		elif position.direction_to(target).x < 0:
			$Sprite.scale.x = -1

				
		$Chain.shoot(position.direction_to(target) * 0.5,self.global_position)
	elif $Chain.hooked and !Input.is_action_pressed("Shoot_Chain"):

			# We released the mouse -> release()
			$Chain.release()
		
	if Input.is_action_pressed("Attack"):
			
		attack = true
		if $Chain.hooked:
				$Chain.release()
			

	if Input.is_action_pressed("ui_down"):
		get_down = true
	else:
		get_down = false
		
	if Input.is_action_pressed("ui_right"):	
		go_right = true
	else:
		go_right = false
		
	if Input.is_action_pressed("ui_left"):	
		go_left = true
	else:	
		go_left = false
		
	if Input.is_action_just_pressed("ui_up"):	
		
		just_jump = true
	else:
		just_jump = false
		
	if Input.is_action_pressed("ui_up"):	
		jump = true
	else:
		jump = false
		
	if Input.is_action_pressed("ui_space"):
		space = true
	else:
		space = false
			
	if Input.is_action_just_pressed("Switch_weapon"):
		bow = !bow
		sword = !sword

		
		
func _physics_process(delta):
	

	var player_Position = self.global_position
	
	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -VELOCITY_X_LIMIT, VELOCITY_X_LIMIT)
	
	if is_on_ceiling():
		velocity.y = 0

		# Hook physics
	$Chain.player_position = self.global_position
	if $Chain.hooked:
		snap_vector = Vector2.ZERO * SNAP_LENGTH
		
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL

		if $Chain.hooked_enemy:
			if abs(chain_velocity.y) < 3:
				chain_velocity.y -= 5
		
		elif $Chain.hooked_cargo:
			chain_velocity.y = 5
		else:
			if chain_velocity.y > 1:
				# Pulling down isn't as strong
				chain_velocity.y *= 0.1
				
			else:
				if abs(chain_velocity.y) < 3:
					chain_velocity.y -= 5
				# Pulling up is stronger
				chain_velocity.y *= 1.05
			
		if sign(chain_velocity.x) != sign(velocity.x):
			# if we are trying to walk in a different
			# direction than the chain is pulling
			# reduce its pull
			chain_velocity.x *= 0.7
	else:
		# Not hooked -> no chain velocity
		chain_velocity = Vector2(0,0)

		
	velocity += chain_velocity
	pushing_rigidbody()

	
	# if the player on the floor
	if is_on_floor():

		if air_attack:
			animation_state_machine.travel("Air_attack_end")
			
			
		#lerp: doing Linear Interpolation (make small changes between two variable)		
		if get_down:
			
			if abs(velocity.x) > 50:
				velocity.x = lerp(velocity.x,0,0.02)
				animation_state_machine.travel("Slide_begin")
			elif abs(velocity.x) > 5:
				velocity.x = lerp(velocity.x,0,0.05)
				animation_state_machine.travel("Slide_end")
			else:
				#play idle animation
				animation_state_machine.travel("Idle")
				velocity.x = lerp(velocity.x,0,0.09)
			
			if attack:
				attack()

			invincible_toggle(true) #player takes no damage
			
		#if player is not sliding
		else:
			
			velocity.x = lerp(velocity.x,0,0.1)
			invincible_toggle(false)#player taks damage
			
			#if the speed is high enough than run
			if go_left or go_right:

				animation_state_machine.travel("Run")
			else:
				#play idle animation
				animation_state_machine.travel("Idle")
		
			if hurt:
				animation_state_machine.travel("Hurt")
			else:
				
				#on the floor and attack
				if attack:
					
					attack()
				
				#on the floor can jump
				elif jump:
					velocity.y = JUMPFORCE	
					snap_vector = Vector2.ZERO * SNAP_LENGTH
				
				#go left or right
				else:	
					
					if go_right:
						velocity.x += SPEED
						#Sprite image flip is equal to false
						$Sprite.scale.x = 1
						
					elif go_left:
						velocity.x -= SPEED
						$Sprite.scale.x = -1
				
							
				
		velocity = move_and_slide_with_snap(velocity, snap_vector ,FLOOR_NORMAL,false, 4, PI/4, false)
		snap_vector = SNAP_DIRECTION * SNAP_LENGTH
		
	elif is_on_wall():
			
		if not hurt:
			animation_state_machine.travel("Wall_slide")
				
			if velocity.x < 0:
					$Sprite.scale.x = -1
			elif velocity.x > 0:
					$Sprite.scale.x = 1
					
			if go_right and jump and velocity.x < 0:
				
				velocity.y = JUMPFORCE
				velocity.x = 3.5 * SPEED
				#Sprite image flip is equal to false

						
			elif go_left and jump and velocity.x > 0:

				velocity.y = JUMPFORCE
				velocity.x =  -3.5 *  SPEED

				
			elif jump and not go_left and not go_right:
				velocity.y = lerp(velocity.y,0,0.3)
			
			if attack:
				attack = false
				air_attack = false
		else:
			animation_state_machine.travel("Hurt")	
		give_gravity()
	else:
			
		#if in the air
		if not hurt:
			if attack and sword:
				air_attack = true
				animation_state_machine.travel("Air_attack")
				
				# determine how powerful is this attack
				if velocity.y > 0:
					air_attack_amp += abs(velocity.y )
			elif attack and bow:
				animation_state_machine.travel("Bow")
			else:
				if go_right:
					$Sprite.scale.x = 1
				if go_left:
					$Sprite.scale.x = -1
					
				if velocity.y > 0:
					animation_state_machine.travel("Fall")
				else:
					animation_state_machine.travel("Jump")
		else:
			animation_state_machine.travel("Hurt")
		give_gravity()
		
func give_gravity():
	#give extra force while in air
	velocity.y += GARAVITY
	#slow down speed	
	velocity.x = lerp(velocity.x,0,0.01)
	velocity.y = move_and_slide(velocity, Vector2.UP,
					false, 4, PI/4, false).y

func pushing_rigidbody():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider!= null:
			if collision.collider.is_in_group("Cargo"):
				collision.collider.apply_central_impulse(-collision.normal * push)
				
func attack():
	if sword:
		if(abs(velocity.x) > 100):
			animation_state_machine.travel("Dash_attack")
		else:
			animation_state_machine.travel("Attack")
	elif bow:
		animation_state_machine.travel("Bow")
		
func take_damage():
	if (hp > 0) and not invincible:
		hurt = true
		hp -= 2
		if $Chain.hooked:
			$Chain.release()
			
		get_down = false
		go_right = false
		go_left = false
		jump = false
		just_jump = false
		space = false
		attack = false
		air_attack = false
		return true
	else:
		return false
func invincible_toggle(input):
	invincible = input
	
func create_a_force_on_player(force):
	if not invincible:
		velocity.x += force


func _on_Fall_Zone_body_entered(body):
	if body == self:
		var sceneName = get_tree().current_scene.name
		get_tree().change_scene("res://Scenes/" + sceneName + ".tscn")


func on_hurt_animation_Start():
	#player state
	get_down = false
	go_right = false
	go_left = false
	jump = false
	just_jump = false
	space = false
	attack = false
	air_attack= false
	air_attack_amp = 0

func on_hurt_animation_End():
	hurt = false
	
func on_attack_animation_Start():
	#player state
	get_down = false
	go_right = false
	go_left = false
	jump = false
	just_jump = false
	space = false

func on_attack_animation_End():
	attack = false
	air_attack= false
	air_attack_amp = 0

func fire_arrow():
	var arrow_instnace = ARROW_SCENE.instance()
	arrow_instnace.set_arrow_init_info($Sprite/Arrow_Fire_Point.global_position,$Sprite.scale.x,ARROW_SPEED * $Sprite.scale.x)
	get_parent().add_child(arrow_instnace)
	
	

func _on_Attack_area_body_entered(body):

	if body.is_in_group("Enemy"):
		body.take_damage(3)
		body.velocity += 30* self.global_position.direction_to(body.global_position).normalized()

func _on_Dash_attack_area_body_entered(body):
	if body.is_in_group("Enemy"):
		#print(0.004 *air_attack_amp)
		body.take_heavy_damage(0.04 * air_attack_amp,5)
		body.velocity += 60 * self.global_position.direction_to(body.global_position).normalized()
