extends Node
const Action = preload("res://Scenes/AI_states/Action.gd")
const Observation = preload("res://Scenes/AI_states/Observation.gd")

export var learning_rate = 0.1
export var Discount_rate = 1
var Q_Table = []
var trail_count = 0

var starter_observation: Observation = null
var current_Observation: Observation  = null
var next_Observation: Observation = null 
var current_action : Action	 = null
var pervoius_stopwatch = 0


var per_cell_gap = 3

func trail_start(newObservation = null):
	trail_count += 1
	if newObservation:
		starter_observation = newObservation
		
		load_Q_Table()
		add_or_change_observation(newObservation)
		return next_perfered_action(newObservation)
		
	return next_perfered_action(starter_observation)
	
func get_currentObservation():
	return current_Observation
	
func get_nextObservation():
	return next_Observation
	
func next_perfered_action(observation: Observation):
	
	var next_action : Action = observation.best_action()
	next_action.Reward = 0
	
	current_action = next_action
	current_Observation = observation
	#the next state in unknown
	if next_action.Next_Observation_ID == -1:
		
		next_action.Next_Observation_ID = Q_Table.size()
		next_Observation = Observation.new(Q_Table.size(), [0,0], "None")#next_Observation here needs to filling informations
		#add_or_change_observation(next_Observation)
		add_or_change_observation(next_Observation)
		return [false,next_action] #return a false because the perfered action lead to an unknown observation
	
	#next state is known.
	#next_Observation = Q_Table[next_action.Next_Observation_ID]
	
	return [true,next_action]

	
func trail_end(stopwatch_value):
	current_action.Reward += 40
	learn()
	save_Q_Table()
	current_Observation = null
	
func trail_reset():

	learn()
	save_Q_Table()
	current_Observation = null
	return next_perfered_action(starter_observation)
	
func learn():
	if !current_Observation:
		return
	current_action.Q_Value = current_action.Q_Value + learning_rate * (current_action.Reward + Discount_rate * next_Observation.best_action().Q_Value -  current_action.Q_Value )
		
	Q_Table[find_observation_by_ID(current_Observation)].add_or_change_action(current_action) 


#add a new pair of a state and an action
func add_or_change_observation(observation: Observation):
	
	#try to find it in the array of observations
	var index = find_observation_by_position(observation.Position)
	if index != -1:
		Q_Table[index].Actions = observation.Actions
		
		return index
	
	index = find_observation_by_ID(observation)
	if index != -1:
		Q_Table[index].Position = observation.Position
		Q_Table[index].Actions = observation.Actions	

		return index
		
	#if it doesnt exists, add it to the array of observations

	Q_Table.append(observation) 
	return find_observation_by_ID(observation)


func find_observation_by_ID(observation):
	var index = Q_Table.bsearch_custom(observation,self,"compare_function_ID") -1

	if index >= 0 and Q_Table.size() > 0:
		return index
		
	return -1
	
func find_observation_by_position(Position):
	var index = 0
	for each_observation in Q_Table:
		
		var each_observation_position = each_observation.Position
		var x_diff = Position[0] - each_observation_position[0]
		var y_diff = Position[1] - each_observation_position[1]
		var distance = sqrt(x_diff * x_diff + y_diff * y_diff)
		if per_cell_gap >= distance:
			return index
		index += 1
		
	return -1
	
func compare_function_ID(observation_a,observation_b ):
	return observation_a.ID == observation_b.ID


	
func save():
	var save_dict = {
		
	}
	for observation in Q_Table:
		var actions = {}
	
		for action in observation.Actions:
			actions[action.Name] = {"Q_Value":action.Q_Value,"Reward":action.Reward,"Next_Observation_ID":action.Next_Observation_ID}

		var observation_dict = {"Position":observation.Position,"State":observation.State,"Actions":actions}

		save_dict[observation.ID] = observation_dict
		
	return save_dict	
	
	
func save_Q_Table():
	var save_game = File.new()
	save_game.open("res://Scenes/AI_states/AI_data/AI_Data.save", File.WRITE)


	# Call the node's save function.
	var node_data = self.call("save")

	# Store the save dictionary as a new line in the save file.
	save_game.store_line(to_json(node_data))
	save_game.close()


func load_Q_Table():
	var save_game = File.new()
	if not save_game.file_exists("res://Scenes/AI_states/AI_data/AI_Data.save"):
		return # Error! We don't have a save to load.


	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("res://Scenes/AI_states/AI_data/AI_Data.save", File.READ)
	var node_data = parse_json(save_game.get_line())
	
	for observation in node_data:
		var the_observation = node_data[observation]
		
		var new_actions_array = []
		
		var new_actions = the_observation["Actions"]
		for action in new_actions:

			var newAction = Action.new(action,int(new_actions[action]["Next_Observation_ID"]))
			newAction.Q_Value = float(new_actions[action]["Q_Value"])
			newAction.Reward = int(new_actions[action]["Reward"])
			new_actions_array.append(newAction)
		

		var new_observation = Observation.new(Q_Table.size(),the_observation["Position"],the_observation["State"])
		new_observation.Actions = new_actions_array
		Q_Table.append(new_observation) 
	
	save_game.close()
