extends KinematicBody2D

signal state_changed

const Action = preload("res://Scenes/AI_states/Action.gd")
const Observation = preload("res://Scenes/AI_states/Observation.gd")


const SPEED = 250
const GARAVITY = 5
const JUMPFORCE = -200
const VELOCITY_X_LIMIT = 250
const FLOOR_NORMAL = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 12.0
const FLOOR_ANGLE = deg2rad(45)
const CHAIN_PULL = 20
const ARROW_SPEED = Vector2(15,0)


var animation_state_machine
var current_state = null
var pervious_state = null


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
var goal = [0,0]
var goabl_reached = false
var air_attack_amp = 0
var hp = 100

var next_observation_is_known = false
var current_lock_down_position = Vector2(0,0)
var stopwatch = 0
var stopwatch_stopped = false

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
	
	
	var position = [int(global_position.x),int(global_position.y)]
	var state = current_state
	var newObservation = Observation.new($Q_Table.Q_Table.size(), position, state)
	stopwatch_start()
	var data_array =$Q_Table.trail_start(newObservation)
	handle_next_move(data_array)
	$Timer.start()
	


func _physics_process(delta):
	
	#grab_hook_effect_player_velocity()
	
	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -VELOCITY_X_LIMIT, VELOCITY_X_LIMIT)

	if goabl_reached:
		_on_Timer_timeout()
	
	if !stopwatch_stopped:
		stopwatch += delta
		
	current_state.update(self,delta)
	
func _change_state(state_name):
	
	if state_name == current_state.name:	
		return
		
	current_state.exit(self)
	
	pervious_state = current_state
	current_state = states[state_name]	
	
	current_state.enter(self)


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

func handle_next_move(data_array): 
	if data_array[0]:
		#next observation is known to AI		

		next_observation_is_known = true
	else:
		
		#next observation is unknown to AI
		next_observation_is_known = false
	
	var next_move: Action = data_array[1]
	var nameOfNext = next_move.Name

	#print(nameOfNext)
	if nameOfNext == "Jump":
		jump = true
	else:
		jump = false
			
	if nameOfNext == "Right":
		go_right = true
	else:
		go_right = false
			
	if nameOfNext == "Left":
		go_left = true
	else:
		go_left = false	
	
	if nameOfNext == "LeftJump":
		go_left = true
		jump = true
	else:
		go_left = false	
		jump = false
		
	if nameOfNext == "RightJump":
		go_right = true
		jump = true
	else:
		go_right = false	
		jump = false

func observe_enviornment():
	var new_Position = [int(global_position.x),int(global_position.y)]	
	var index_in_Q_table = $Q_Table.find_observation_by_position(new_Position)
	if index_in_Q_table == -1:
			
		var new_ID = $Q_Table.Q_Table.size()
		var a_new_Observation = Observation.new(new_ID,new_Position,current_state.name)
		index_in_Q_table = $Q_Table.add_or_change_observation(a_new_Observation)
		$Q_Table.current_action.Next_Observation_ID = index_in_Q_table
		$Q_Table.Q_Table[$Q_Table.find_observation_by_ID($Q_Table.current_Observation)].add_or_change_action($Q_Table.current_action) 
		
	$Q_Table.next_Observation = $Q_Table.Q_Table[index_in_Q_table]
	
func calculate_reward():
	if $Q_Table.current_action.Name == "Jump" or $Q_Table.current_action.Name == "RightJump" or $Q_Table.current_action.Name == "LeftJump":
		$Q_Table.current_action.Reward -= 2

	if $Sprite/Detect_top_wall.is_colliding() :	
		$Q_Table.current_action.Reward -= 0.5
	
	if $Sprite/Detect_side_wall.is_colliding() :	
		$Q_Table.current_action.Reward -= 0.5
		
	var x_diff = $Q_Table.next_Observation.Position[0] - goal[0]
	var y_diff = $Q_Table.next_Observation.Position[1] - goal[1]
	var new_distance = 1 * sqrt(x_diff * x_diff + y_diff * y_diff)
	
	x_diff = $Q_Table.current_Observation.Position[0] - goal[0]
	y_diff = $Q_Table.current_Observation.Position[1] - goal[1]
	var old_distance = 1 * sqrt(x_diff * x_diff + y_diff * y_diff)
	
	var distance_diff =  old_distance - new_distance
	
	#action getting closer to goal, gain reward
	$Q_Table.current_action.Reward  += clamp(distance_diff, -2, 2)
	
	#closer to goal, less punish
	$Q_Table.current_action.Reward  -= 0.1 * new_distance
	
	#less step, less punish
	$Q_Table.current_action.Reward -= 0.1
	
		
func _on_Timer_timeout():
	
	if goabl_reached:
		goabl_reached = false		
		$Q_Table.trail_end(stopwatch_stop())
		$Q_Table.save_Q_Table()
		var data_array = $Q_Table.trail_start()
		stopwatch_start()
		handle_next_move(data_array)

	if current_state.name != "In_Air":
		observe_enviornment()
		calculate_reward()
		$Q_Table.learn()
			
		var data_array = $Q_Table.next_perfered_action($Q_Table.next_Observation)
		handle_next_move(data_array)
	
	#set the next time coutn
	$Timer.wait_time = 0.1

func stopwatch_start():
	stopwatch_stopped = false
	stopwatch = 0

func stopwatch_stop():
	stopwatch_stopped = true

	return stopwatch
	
func lock_down_release_detect_and_reward(currentPosition:Vector2):

	if current_lock_down_position.distance_to(currentPosition) > 10:
		current_lock_down_position = currentPosition 
		return 1
	return -1

func trail_count():
	return $Q_Table.trail_count
