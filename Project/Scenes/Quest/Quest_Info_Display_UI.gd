extends Label

var info = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func create_new_collecting(description,current,goal):
	info = {"type" : "collecting",
			"description":description,
			"current": current,
			"goal": goal}
	self.text = description + " "+ str(current) + "/" + str(goal)
	
func create_new_goal(description,completion = false):
	info = {"type" : "goal",
			"description":description,
			"completion": completion,
			}
	self.text = description + " "+ str(completion)

func update_collecting(current,goal = -1):
	if goal == -1:
		info["current"] = current
	else:
		info["current"] = current
		info["goal"] = goal
	self.text = info["description"] + " "+ str(info["current"]) + "/" + str(info["goal"])
	
func update_goal(completion):
	info["completion"] = completion
	self.text = info["description"] + " "+ str(info["completion"])
