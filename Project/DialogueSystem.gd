extends Node
signal dialogueFinshed
export (String, FILE, "*.json") var dialogue_file: String
var dialogues: Dictionary

var conversations = []

var current_index = 0
var current_name_who_talk = ""
var current_expression = ""
var current_text = ""
var current_decisions = []


func start():
	init_dialogue()
	
func init_dialogue():
	print(dialogue_file)
	dialogues = load_dialogue(dialogue_file)
	
func load_dialogue(file_path) -> Dictionary:
	var file = File.new()
	assert(file.file_exists(file_path)) #terminate the program if the file doesnt exists
	
	file.open(file_path,File.READ)
	var dialogue = parse_json(file.get_as_text())
	file.close()
	return dialogue

func dialogue_start():
	conversations = dialogues.values()
	
	#start the conversation
	current_index = 0
	update_context()
	
func dialogue_next(next_conversation) -> bool:

	if next_conversation == -1: # there is no more conversation
		return false
	current_index = next_conversation
	update_context()
	return true


func update_context():
	
	#update the current context
	current_decisions = []
	current_name_who_talk = conversations[current_index].name
	current_expression = conversations[current_index].expression
	current_text = conversations[current_index].dialogue
	current_decisions = conversations[current_index].decisions

