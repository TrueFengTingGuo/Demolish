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

var snap_vector = SNAP_DIRECTION * SNAP_LENGTH
var chain_velocity = Vector2(0,0)
var velocity = Vector2(0,0)


var get_down = false
var go_right = false
var go_left = false
var jump = false
var just_jump = false
var space = false

func _ready():
	GlobalAccess.Player = self


func _input(event):

	if event is InputEventMouseButton:

		if event.pressed:
			# We clicked the mouse -> shoot()
			var target = get_global_mouse_position()
			
			if position.direction_to(target).x > 0:
				$Sprite.flip_h = false
			elif position.direction_to(target).x < 0:
				$Sprite.flip_h = true
				
			$Chain.shoot(position.direction_to(target) * 0.5)
		else:
			# We released the mouse -> release()
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
		
		
func _physics_process(delta):
	
	
	var player_Position = self.global_position
	
	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -VELOCITY_X_LIMIT, VELOCITY_X_LIMIT)
	
	if is_on_ceiling():
		velocity.y = 0

		# Hook physics
	if $Chain.hooked:
		snap_vector = Vector2.ZERO * SNAP_LENGTH
		
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL
		
		if chain_velocity.y > 0:
			# Pulling down isn't as strong
			chain_velocity.y *= 0.01
		else:
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


	# if the player on the floor
	if is_on_floor():

		velocity = move_and_slide_with_snap(velocity, snap_vector ,FLOOR_NORMAL,true)	
		snap_vector = SNAP_DIRECTION * SNAP_LENGTH

		#lerp: doing Linear Interpolation (make small changes between two variable)		
		if get_down:
				
			if abs(velocity.x) > 50:
				velocity.x = lerp(velocity.x,0,0.02)
				$Sprite.play("Slide_begin")
			elif abs(velocity.x) > 5:
				velocity.x = lerp(velocity.x,0,0.05)
				$Sprite.play("Slide_end")
			else:
				#play idle animation
				$Sprite.play("Idle")
				velocity.x = lerp(velocity.x,0,0.09)
			
		#if player is not sliding
		else:
			
			velocity.x = lerp(velocity.x,0,0.05)
			if(abs(velocity.x) > 40):
				velocity.x = lerp(velocity.x,0,0.05)
				$Sprite.play("Run")
			else:
				#play idle animation
				$Sprite.play("Idle")
		
			if go_right:
				velocity.x += SPEED
				#Sprite image flip is equal to false
				$Sprite.flip_h = false
			if go_left:
				velocity.x -= SPEED
				$Sprite.flip_h = true
			if jump:
				velocity.y = JUMPFORCE	
				snap_vector = Vector2.ZERO * SNAP_LENGTH
	
	else:
		# if player is not on the floor

		#give extra force
		velocity.y += GARAVITY
		#slow down speed	
		velocity.x = lerp(velocity.x,0,0.01)
		move_and_slide(velocity, Vector2.UP)
		
		if is_on_wall():
			$Sprite.play("WallSlide")	
			
			if go_right and jump and velocity.x < 0:

				velocity.y = JUMPFORCE
				velocity.x = 3.5 * SPEED
				#Sprite image flip is equal to false
				$Sprite.flip_h = false
					
			elif go_left and jump and velocity.x > 0:
				velocity.x = 0
				velocity.y = JUMPFORCE
				velocity.x =  -3.5 *  SPEED
				$Sprite.flip_h = true
			
			elif jump and not go_left and not go_right:
				velocity.y = lerp(velocity.y,0,0.3)
		
		else:
			if velocity.y > 0:
				$Sprite.play("Fall")
			else:
				$Sprite.play("Jump")
				
				





func _on_Fall_Zone_body_entered(body):
	if body == self:
		var sceneName = get_tree().current_scene.name
		get_tree().change_scene("res://Scenes/" + sceneName + ".tscn")
