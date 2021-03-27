extends Object

var Name = ""
var Q_Value = 0
var Reward = 0
var Next_Observation_ID = -1


func _init(name, next_observation):
	Name = name
	Next_Observation_ID = next_observation
