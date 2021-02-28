extends KinematicBody2D

signal state_changed
var current_state = null

var pervious_state = null


const SPEED = 30
const GARAVITY = 5
const JUMPFORCE = -200
const VELOCITY_X_LIMIT = 180
const FLOOR_NORMAL = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 12.0
const FLOOR_ANGLE = deg2rad(45)
const CHAIN_PULL = 20
const ARROW_SCENE = preload("res://Scenes/Player_Arrow.tscn")
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
var hurt = false
var invincible = false

var coins = 0
var air_attack_amp = 0
var hp = 100


onready var states = {
	"Idle": $State/Idle,
	"Attack": $State/Attack,
	"Wall_Slide": $State/Wall_Slide,
	"In_Air": $State/In_Air,
	"Run": $State/Run,
	"Jump": $State/Jump
}

func _ready():

	if !is_on_floor():
		current_state = $State/In_Air
	else:
		current_state = $State/Idle
	pervious_state = current_state
	
	
	for state_node in $State.get_children():
		
		state_node.connect("finished", self, "_change_state")

	GlobalAccess.Player = self
	animation_state_machine =$AnimationTree.get("parameters/playback")
		
func _physics_process(delta):
	
	grab_hook_effect_player_velocity()
	
	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -VELOCITY_X_LIMIT, VELOCITY_X_LIMIT)
	current_state.update(self,delta)
	#print(velocity.x)
	#print(current_state.name)
	
func _change_state(state_name):
	
	if state_name == current_state.name:	
		return
		
	current_state.exit(self)
	
	pervious_state = current_state
	current_state = states[state_name]	
	
	current_state.enter(self)
	
func _input(event):
	
	if event is InputEventMouseButton:

		if event.button_index == BUTTON_RIGHT and event.pressed:
			# We clicked the mouse -> shoot()
			var target = get_global_mouse_position()
			
			if position.direction_to(target).x > 0:
				$Sprite.scale.x = 1

			elif position.direction_to(target).x < 0:
				$Sprite.scale.x = -1

				
			$Chain.shoot(position.direction_to(target) * 0.5,self.global_position)
		else:
			# We released the mouse -> release()
			if $Chain.hooked:
				$Chain.release()
				
				
	
	if Input.is_action_just_pressed("ui_up"):
		jump = true
	else:
		jump = false
		
	if Input.is_action_pressed("ui_right"):
		go_right = true
	else:
		go_right = false
		
	if Input.is_action_pressed("ui_left"):
		go_left = true
	else:
		go_left = false	
		
					
	current_state.handle_input(self,event)



func flip_sprite(value):
	$Sprite.scale.x = value

func invincible_toggle(input):
	invincible = input
		
		
func give_gravity():
	#give extra force while in air
	velocity.y += GARAVITY
	#slow down speed	
	velocity.x = lerp(velocity.x,0,0.01)
	velocity.y = move_and_slide(velocity, Vector2.UP,
					false, 4, PI/4, false).y
					
func get_Chain():
	return $Chain		
			
func grab_hook_effect_player_velocity():
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
