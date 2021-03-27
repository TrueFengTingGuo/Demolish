
extends Object

const Action = preload("res://Scenes/AI_states/Action.gd")

var ID = 0
var Position = []
var State = ''
var Actions = []

func _init(id, position, state):
	ID = id
	Position = position
	State = state
	
	Actions = [Action.new("Left", -1),Action.new("Right", -1),Action.new("Idle", -1), Action.new("Jump", -1)]

#find the best action among all actions
func best_action():
	var the_best = Actions[0]
	
	#find the best action with the highest q value
	for action in Actions:
		if the_best.Q_Value < action.Q_Value:
			the_best = action

	
	return the_best	
	

func add_or_change_action(searched_action:Action):
	var action_Count = 0
	for action in Actions:
		if action.Name == searched_action.Name:
			#print(action.Name)
			#print(action.Q_Value)
			#print(action.Next_Observation_ID)
			action.Q_Value = searched_action.Q_Value
			action.Reward = searched_action.Reward
			action.Next_Observation_ID = searched_action.Next_Observation_ID
			#print(action.Name)
			#print(action.Q_Value)
			#print(action.Next_Observation_ID)
		action_Count += 1
		
func find_action(searched_action):
	var count = 0
	for action in Actions:
		if action.Name == searched_action.Name:
			return count
		count += 1	
	return count
